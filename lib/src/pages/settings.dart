import 'package:flutter/material.dart';

import "package:ebay/src/pages/editors/filters.dart";
import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/widgets.dart";

/// The page to create or edit a seller profile.
class SettingsPage extends ReactiveWidget<LoginViewModel> {
  const SettingsPage({super.key});

  @override
  LoginViewModel createModel() => LoginViewModel(
    redirect: Routes.home,
    showSignUp: true,
  );

  @override
  Widget build(BuildContext context, LoginViewModel model) => Scaffold(
    appBar: AppBar(title: const Text("My Profile")),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Edit account", style: context.textTheme.headlineLarge),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Cancel"),
              ),
              const SizedBox(width: 10,),
              FilledButton(
                onPressed: model.isReady ? model.signUp : null, 
                child: const Text("Save"),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}