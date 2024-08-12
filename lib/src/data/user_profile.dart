import "package:flutter/material.dart";

import "types.dart";

/// A user of the app. Can be a customer or seller.
class UserProfile {
  /// The user's ID.
  final UserID id;
  /// The user's first name.
  final String firstName;
  /// The user's last name.
  final String lastName;
  /// The user's theme preference.
  final ThemeMode theme;
  /// The API details from ebay
  Json? ebayAPI;
  /// The API details from aliexpress
  Json? aliAPI;

  /// Creates a new User object.
  UserProfile({
    required this.id,
    required this.firstName, 
    required this.lastName, 
    required this.ebayAPI,
    required this.aliAPI,
    required this.theme,
  });

  /// Creates a new User object from a JSON object.
  UserProfile.fromJson(Json json) : 
    firstName = json["first name"],
    lastName = json["last name"],
    id = json["id"],
    ebayAPI = json["ebay"],
    aliAPI = json["ali"],
    theme = json["theme"] == null ? ThemeMode.system : ThemeMode.values.byName(json["theme"]);

  /// Convert this user to its JSON representation
  Json toJson() => {
    "id": id,
    "first name": firstName,
    "last name": lastName,
    "ebay": ebayAPI,
    "ali": aliAPI,
    "theme": theme.name,
  };
}