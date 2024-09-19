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
    if (profile == null) return;
    await models.onSignIn(profile);
  }

  @override
  Future<void> onSignIn(UserProfile profile) async {
    userProfile = profile;
    getListingsInformation();
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

  Future<void> refreshToken() async {
    if (!isSignedIn) {
      print("Can't refresh token: User not signed in");
      return;
    }
    userProfile!.ebayAPI =
        await services.ebayScraper.refreshToken(userProfile!);
    if (userProfile!.ebayAPI == null) return;
    saveTokenResponse();
    await services.database.saveUserProfile(userProfile!);
  }

  Future<void> generateToken(String code) async {
    userProfile!.ebayAPI = await services.ebayScraper.generateToken(code);
    saveTokenResponse();
  }

  void saveTokenResponse() async {
    if (!isSignedIn) {
      print("Can't save api response: User is not logged in");
      return;
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
    }
  }

  Future<void> updateListings(List<ItemID> items) async {
    if (!isSignedIn) return;
    userProfile!.listingIDs = items;
    await models.user.updateProfile(userProfile!);
  }

  Future<List<Listing>> getListingsInformation() async {
    if (!isSignedIn) return [];
    final List<Listing> listings = [];
    for (final itemID in userProfile!.listingIDs) {
      listings.add(await services.ebayScraper.getItemLegacyNoDataBase(userProfile!, itemID));
    }
    return listings;
  }

  Future<List<Listing>> getListingsInformationFromDatabase() async {
    if (!isSignedIn) return [];
    final List<Listing> listings = [];
    for(final itemId in userProfile!.listingIDs){
      final listing = await services.database.getListing(itemId);
      if(listing != null) listings.add(listing);
    }
    return listings;
  }

  Future<List<Order>> getOrdersInformation() async {
    if(!isSignedIn) return [];
    final orders = await services.ebayScraper.getOrders(userProfile!);
    if(orders.isEmpty){
      return [];
    }
    return orders;
  }
}
