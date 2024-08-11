import "package:ebay/data.dart";
import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/services.dart";
import "package:flutter/material.dart";

/// A view model to sign the user in, show a sign-up form if needed, then redirect to another route.
class LoginViewModel extends BuilderModel<UserProfile> {
  /// Whether to show the signup form.
  bool showSignUp;

  /// The user ID, if the user is signed in.
  UserID? get userID => services.auth.userID;
  
  /// The text controller for the first name text field.
  final firstNameController = TextEditingController();

  /// The text controller for the last name text field.
  final lastNameController = TextEditingController();
  
  /// The username entered in the text field, if any.
  String? get firstName => firstNameController.text.trim().nullIfEmpty;

  /// The username entered in the text field, if any.
  String? get lastName => lastNameController.text.trim().nullIfEmpty;

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
    firstNameController.addListener(notifyListeners);
    lastNameController.addListener(notifyListeners);
    final profile = models.user.userProfile;
    if (profile != null) {
      initialProfile = profile;
      firstNameController.text = profile.firstName;
      lastNameController.text = profile.lastName;
      theme = profile.theme;
    }
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  bool get isReady => userID != null
    && firstName != null
    && lastName != null
    && !isSaving;  

  @override
  UserProfile build() => UserProfile(
    firstName: firstName!, 
    lastName: lastName!, 
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

   /// Creates a [UserProfile] using the provided information.
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