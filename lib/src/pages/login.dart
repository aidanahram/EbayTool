import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; // new
import 'package:flutter/material.dart';

import 'home.dart';

class LoginPage extends StatelessWidget {
  /// The route to redirect to after sign-in or sign-up, if any.
  final String? redirect;
  /// Whether to skip to the signup page.
  final bool? showSignUp;
  /// Creates the login page.
  const LoginPage({super.key, this.redirect, this.showSignUp});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: [
              GoogleProvider(clientId: "1095906260558-d54anrdq5j0cr18vfm4paq7trvfvi09q.apps.googleusercontent.com"),  // new
            ],
          );
        }
        return const HomePage();
      },
    );
  }
}