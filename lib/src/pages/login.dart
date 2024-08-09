import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart'; 
import 'package:flutter/material.dart';

import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/services.dart";
import "package:ebay/widgets.dart";

class LoginPage extends ReactiveWidget<LoginViewModel> {
  /// The route to redirect to after sign-in or sign-up, if any.
  final String? redirect;
  /// Whether to skip to the signup page.
  final bool? showSignUp;
  /// Creates the login page.
  const LoginPage({super.key, this.redirect, this.showSignUp});

  @override
  LoginViewModel createModel() => LoginViewModel(
    redirect: redirect ?? Routes.home,
    showSignUp: showSignUp ?? false,
  );
   @override
  Widget build(BuildContext context, LoginViewModel model) => Scaffold(
    appBar: (showSignUp ?? false) ? AppBar(title: const Text("My Profile")) : null,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (model.showSignUp) ..._signUp(context, model) 
          else ..._signIn(context, model),
        ],
      ),
    ),
  );


  List<Widget> _signIn(BuildContext context, LoginViewModel model) => [
    const Spacer(),
    Text("Dropper", style: context.textTheme.headlineMedium),
    const SizedBox(height: 24),
    SizedBox(
      width: 300, 
      child: GoogleSignInButton(
        loadingIndicator: const CircularProgressIndicator(),
        overrideDefaultTapAction: true,
        onTap: model.onAuth, 
        clientId: googleID,
        label: "Sign in with Google",
      ),
    ),
    const SizedBox(height: 12),
    if (model.isSaving) const CircularProgressIndicator(),
    if (model.error != null) Text(model.error!, style: const TextStyle(color: Colors.red)),
    const Spacer(),
  ];

  List<Widget> _signUp(BuildContext context, LoginViewModel model) => [
    Text((showSignUp ?? false) ? "Edit account" : "Create an account", style: context.textTheme.headlineLarge),
    const SizedBox(height: 24),
    SizedBox(
      width: 200, 
      child: InputContainer(text: "First Name", controller: model.firstNameController),
    ),
    const SizedBox(height: 10),
    SizedBox(
      width: 200, 
      child: InputContainer(text: "Last Name", controller: model.lastNameController),
    ),
    const SizedBox(height: 16),
    SizedBox(
      width: 300,
      child: FilterOption(
        name: "Theme",
        child: DropdownMenu(
          initialSelection: model.theme,
          onSelected: model.updateTheme,
          dropdownMenuEntries: [
            for (final theme in ThemeMode.values)
              DropdownMenuEntry(value: theme, label: theme.displayName),
          ],
        ),
      ),
    ),
    const SizedBox(height: 16),
    FilledButton(
      onPressed: model.isReady ? model.signUp : null, 
      child: (showSignUp ?? false) ? const Text("Save") : const Text("Create account"),
    ),
  ];
}


/// A name and widget in a row, on opposite sides of each other,
class FilterOption extends StatelessWidget {
  /// The name of the option.
  final String name;
  /// The option to show.
  final Widget child;
  /// Creates a filter option widget.
  const FilterOption({super.key, 
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const SizedBox(width: 16),
      Text(
        name,
        style: context.textTheme.titleMedium,
      ),
      const Spacer(),
      Expanded(
        flex: 3, 
        child: Align(
          alignment: Alignment.centerRight,
          child: child,
        ),
      ),
      const SizedBox(width: 16),
    ],
  );
}
