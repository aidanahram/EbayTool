//import 'package:flutter/material.dart';

import "package:ebay/data.dart";
import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/services.dart";

/// A data model to track the user and sign them in or out.
class UserModel extends DataModel {
  /// The currently signed-in user.
  UserProfile? userProfile;

  /// The user ID of the currently signed-in user, if any.
  UserID? get userID => userProfile?.id;

  @override
  Future<void> init() async {
    // Try to automatically sign-in
    await signIn();
  }

  /// Whether the user is signed in.
  bool get isSignedIn => userProfile != null;

  /// Signs the user in and downloads their profile.
  Future<void> signIn() async {
    final uid = services.auth.userID;
    if (uid == null) return;
    final profile = await services.database.getUserProfile(uid);
    print("User $uid logged in: ${profile?.lastName}, ${profile?.firstName}");
    if (profile == null) return;
    await models.onSignIn(profile);
  }

  @override
  Future<void> onSignIn(UserProfile profile) async {
    userProfile = profile;
    notifyListeners();
  }

  /// Signs the user out of their account.
  Future<void> signOut() async {
    await services.auth.signOut();
    userProfile = null;
    notifyListeners();
    await models.onSignOut();
    router.go("/login");
  }

  @override
  Future<void> onSignOut() async {}

  /// Updates the user's profile.
  Future<void> updateProfile(UserProfile newProfile) async {
    await services.database.saveUserProfile(newProfile);
    userProfile = newProfile;
    notifyListeners();
  }

  /// Gets a new token using the user's refresh token
  Future<bool> refreshToken() async {
    if (!isSignedIn) {print("Can't refresh token: User not signed in"); return false;}
    if (!userProfile!.ebayRefreshTokenValid) {print("Need to reauthorize ebay, refresh token expired"); return false;}
    final refreshTokenResponse = await services.ebayScraper.refreshToken(userProfile!);
    if (refreshTokenResponse == null) return false;
    userProfile!.ebayAPI!["expires_in"] = refreshTokenResponse["expires_in"];
    userProfile!.ebayAPI!["access_token"] = refreshTokenResponse["access_token"];
    return saveTokenResponse();
  }

  /// Generates a new token using the code from the API
  /// Save token response to the user profile
  Future<bool> generateToken(String code) async {
    userProfile!.ebayAPI = await services.ebayScraper.generateToken(code);
    return saveTokenResponse();
  }

  Future<bool> saveTokenResponse() async {
    if (!isSignedIn) {
      print("Can't save api response: User is not logged in");
      return false;
    }
    if (userProfile!.ebayAPI != null) {
      userProfile!.ebayAPI!['refresh_token_valid_time'] =
          DateTime.now().millisecondsSinceEpoch +
              userProfile!.ebayAPI!['refresh_token_expires_in'];

      /// userProfile!.ebayAPI!['expires_in'] is in seconds -- multiply by 1000 to get milliseconds
      userProfile!.ebayAPI!['token_valid_time'] =
          DateTime.now().millisecondsSinceEpoch +
              userProfile!.ebayAPI!['expires_in'] * 1000;
      await models.user.updateProfile(userProfile!);
      return true;
    }
    return false;
  }

  /// Updates the user's listing information
  /// Removes any listings that were saved before and don't exist anymore
  Future<void> updateListings(List<ItemID> newItems) async {
    if (!isSignedIn) return;
    print("Updating listings in database");
    final oldItems = userProfile!.listingIDs;
    for (final item in oldItems){
      if (!newItems.contains(item)){
        await services.database.deleteListing(item);
      }
    }
    userProfile!.listingIDs = newItems;
    await models.user.updateProfile(userProfile!);
  }

  Future<bool> refreshListingsInformation() async {
    if (!isSignedIn){
      print("Cannot refresh listing becuase user not signed in");
      return false;
    }
    if (!userProfile!.ebayRefreshTokenValid){
      print("Ebay token not valid...trying to refresh token");
      if(!await refreshToken()){
        print("Cannot refresh listing and cannot refresh Token. Must reconnect ebay API");
        return false;
      }
      print("Ebay token refreshed");
    }
    print("Getting listings");
    return services.ebayScraper.getListings(userProfile!);
  }

  Future<List<Listing>> getListingsInformationFromDatabase() async {
    if (!isSignedIn) return [];
    print("Getting listings from database");
    final List<Listing> listings = [];
    for(final itemId in userProfile!.listingIDs){
      final listing = await services.database.getListing(itemId);
      if(listing != null) listings.add(listing);
    }
    return listings;
  }

  Future<List<Order>> getOrdersInformation() async {
    if(!isSignedIn) return [];
    return services.ebayScraper.getOrders(userProfile!);
  }
}
