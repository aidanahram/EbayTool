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
  Future<void> updateProfile(UserProfile profile) async {
    await services.database.saveUserProfile(profile);
    userProfile = profile;
    notifyListeners();
  }
}