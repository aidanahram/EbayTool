import "package:ebay/src/data/user_profile.dart";
import 'package:flutter/material.dart';

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
    print("retreiving user $uid from database");
    final profile = await services.database.getUserProfile(uid);
    if (profile == null) return;
    await models.onSignIn(profile);
  }

  @override
  Future<void> onSignIn(UserProfile profile) async {
    userProfile = profile;
    refreshToken();
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
  Future<void> onSignOut() async { }

  /// Updates the user's profile.
  Future<void> updateProfile(UserProfile newProfile) async {
    await services.database.saveUserProfile(newProfile);
    userProfile = newProfile;
    notifyListeners();
  }

  Future<void> refreshToken() async {
    if(userProfile == null){
      print("User not signed in");
      return;
    }
    userProfile!.ebayAPI = await services.ebayScraper.refreshToken(userProfile!);
    saveTokenResponse();
    await services.database.saveUserProfile(userProfile!);
  }

  Future<void> generateToken(String code) async {
    userProfile!.ebayAPI = await services.ebayScraper.generateToken(code);
    saveTokenResponse();
  }

  void saveTokenResponse() {
    if(userProfile == null){
      print("Can't save api response: User is not logged in");
      return;
    }
    if(userProfile!.ebayAPI != null){
      userProfile!.ebayAPI!['refresh_token_valid_time'] = DateTime.now().millisecondsSinceEpoch + userProfile!.ebayAPI!['refresh_token_expires_in'];
      /// userProfile!.ebayAPI!['expires_in'] is in seconds -- multiply by 1000 to get milliseconds
      userProfile!.ebayAPI!['token_valid_time'] = DateTime.now().millisecondsSinceEpoch + userProfile!.ebayAPI!['expires_in'] * 1000;
      models.user.updateProfile(userProfile!);
    }
  }
}