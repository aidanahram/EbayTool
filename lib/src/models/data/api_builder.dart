import "package:flutter/material.dart";
import "package:ebay/models.dart";
import "package:ebay/services.dart";

/// Save the API code based on user input
class APIBuilder extends ValueBuilder<void> {
  /// Whether the code worked or not
  bool? success;

  /// The text controller for the timer name.
  final code = TextEditingController();
  
  @override
  bool get isValid => code.text.isNotEmpty;

  @override
  void get value { /* Use [save] instead */ }

  /// Updates the UI.
  void update(_) => notifyListeners();

  /// Saves the code
  void save() async {
    models.settings.code = code.text;
    //services.aliScraper.authenticate(code.text);
  }
}