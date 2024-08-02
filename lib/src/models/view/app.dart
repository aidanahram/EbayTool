import "package:flutter/material.dart";
import "dart:async";

import "package:ebay/data.dart";
import "package:ebay/models.dart";
import "package:ebay/services.dart";

/// The view model for the main page.
class AppModel extends DataModel {
  /// The dashboard's version from the `pubspec.yaml`.
  String? version;

  String? code;

  @override
  Future<void> onSignIn(UserProfile profile) async => (); //setTheme(profile.theme);

  @override
  Future<void> onSignOut() async { }

  @override
  Future<void> init() async {
    models.settings.addListener(notifyListeners);
  }

  @override
  void dispose() {
    models.settings.removeListener(notifyListeners);
    super.dispose();
  }
}
