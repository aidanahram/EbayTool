
import "package:flutter/material.dart";
import "dart:async";

import "package:ebay/data.dart";
import "package:ebay/models.dart";
//import "package:ebay/services.dart";

/// The view model for the main page.
class AppModel extends DataModel {
  ThemeMode _theme = ThemeMode.system;
  /// The current theme mode: light, dark, or system default.
  ThemeMode get theme => _theme;

  /// Sets the theme for the app.
  void setTheme(ThemeMode value) {
    _theme = value;
    notifyListeners();
  }

  @override
  Future<void> onSignIn(UserProfile profile) async => setTheme(profile.theme);

  @override
  Future<void> onSignOut() async { }

  /// A hook into the UI, to call [ScaffoldMessenger.of] with.
  BuildContext? context;

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

/// Useful methods on [ThemeMode]s.
extension ThemeModeUtils on ThemeMode {
  /// A human-friendly name for this option.
  String get displayName => switch (this) {
    ThemeMode.dark => "Dark",
    ThemeMode.light => "Light",
    ThemeMode.system => "System",
  };
}