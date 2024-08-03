import "package:flutter/material.dart";

import "types.dart";

/// A user of the app. Can be a customer or seller.
class UserProfile {
  /// The user's ID.
  final UserID id;
  /// The user's name.
  final String name;
  /// The user's theme preference.
  final ThemeMode theme;

  /// Creates a new User object.
  UserProfile({
    required this.id,
    required this.name, 
    required this.theme,
  });

  /// Creates a new User object from a JSON object.
  UserProfile.fromJson(Json json) : 
    name = json["name"],
    id = json["id"],
    theme = json["theme"] == null ? ThemeMode.system : ThemeMode.values.byName(json["theme"]);

  /// Convert this user to its JSON representation
  Json toJson() => {
    "id": id,
    "name": name,
    "theme": theme.name,
  };
}