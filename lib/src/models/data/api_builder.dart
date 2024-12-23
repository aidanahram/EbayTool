// ignore_for_file: avoid_print

import "package:flutter/material.dart";
import "package:ebay/models.dart";
import "package:ebay/services.dart";

/// Save the API code based on user input
class APIBuilder extends ValueBuilder<void> {
  final String website;
  APIBuilder({required this.website});

  /// The text controller for the timer name.
  final url = TextEditingController();

  @override
  bool get isValid => url.text.isNotEmpty;

  @override
  void get value {/* Use [save] instead */}

  /// Updates the UI.
  void update(_) => notifyListeners();

  /// Saves the code
  Future<bool> save() async {
    final uri = Uri.parse(url.text);
    try {
      final code = uri.queryParameters['code'];
      if (code == null) {
        print("[ERROR] Unable to find code in URL");
        return false;
      }
      final profile = models.user.userProfile;
      if (profile == null) {
        print("[ERROR] User not logged in");
        return false;
      }
      switch (website) {
        case ("AliExpress"):
          profile.aliAPI = await services.aliScraper.generateToken(code);
          if (profile.aliAPI != null) {
            models.user.updateProfile(profile);
            return true;
          }
        case ("Ebay"):
          return await models.user.generateToken(code);
      }
    } on Exception catch (e) {
      print("[ERROR] Unable to save code");
      print(e);
      return false;
    }
    return false;
  }
}
