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
  void save() async {
    final uri = Uri.parse(url.text);
    try {
      final code = uri.queryParameters['code'];
      if(code == null){
        print("Unable to save code");
        return;
      }
      switch (website) {
        case ("AliExpress"):
          services.aliScraper.generateToken(code!);
        case ("Ebay"):
          services.ebayScraper.generateToken(code!);
      }
    } on Exception catch (e) {
      print("Unable to save code");
      print(e);
      return;
    }
  }
}
