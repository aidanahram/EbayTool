import "package:ebay/data.dart";
import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/services.dart";
import "package:firebase_ui_auth/firebase_ui_auth.dart";
import "package:flutter/material.dart";

/// A view model to sign the user in, show a sign-up form if needed, then redirect to another route.
class LoginViewModel extends BuilderModel<UserProfile> {
  /// Whether to show the signup form.
  bool showSignUp;

  /// The user ID, if the user is signed in.
  UserID? get userID => services.auth.userID;
  
  /// The text controller for the username text field.
  final usernameController = TextEditingController();
  
  /// The username entered in the text field, if any.
  String? get username => usernameController.text.trim().nullIfEmpty;

  /// The image uploaded, if any.
  String? imageUrl;

  /// The error when saving, if any.
  String? error;

  /// Whether the account is being saved.
  bool isSaving = false;

  /// The user's theme preference.
  ThemeMode theme = ThemeMode.system;

  /// The route to redirect to after a successful sign in or registration.
  final String redirect;

  /// The profile to edit, if any.
  UserProfile? initialProfile;

  /// Creates a view model to sign in or register then go to the redirect URL.
  LoginViewModel({required this.redirect, required this.showSignUp});

  @override
  Future<void> init() async {
    usernameController.addListener(notifyListeners);
    final profile = models.user.userProfile;
    if (profile != null) {
      initialProfile = profile;
      usernameController.text = profile.name;
      theme = profile.theme;
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  @override
  bool get isReady => userID != null
    && username != null
    && imageUrl != null
    && !isSaving;  

  @override
  UserProfile build() => UserProfile(
    name: username!, 
    id: userID!,
    theme: theme,
  );

  /// Once the user is signed in, checks their profile and sets [showSignUp], if needed.
  Future<void> onAuth() async {
    print("JUST AUTH");
    error = null;
    notifyListeners();
    await services.auth.signIn();
    await models.user.signIn();
    final email = services.auth.user?.email;
    if (email == null) return;
    if (models.user.isSignedIn) {
      print("user signed in");
      router.go(redirect);
      return;
    } else {
      final userID = services.auth.userID;
      if (userID == null) return;
      showSignUp = true;
    }
    notifyListeners();
  }

   /// Creates a [UserProfile] using the provided image and username.
  Future<void> signUp() async {
    final profile = build();
    isSaving = true;
    notifyListeners();
    await models.user.updateProfile(profile);
    isSaving = false;
    notifyListeners();
    router.go(redirect);
  }

  /// Updates [theme] and refreshes the UI.
  void updateTheme(ThemeMode? input) {
    if (input == null) return;
    theme = input;
    models.app.setTheme(input);
    notifyListeners();
  }

}