import "package:flutter/material.dart";

import "listing.dart";
import "types.dart";

/// A user of the app. Can be a customer or seller.
class UserProfile {
  /// The user's ID.
  final UserID id;
  /// The user's first name.
  String firstName;
  /// The user's last name.
  String lastName;
  /// The user's theme preference.
  ThemeMode theme;
  /// The API details from ebay
  Json? ebayAPI;
  /// The API details from aliexpress
  Json? aliAPI;
  /// The user's ebay listingIDs which gets saved to the database
  List<ItemID> listingIDs;
  /// The user's ebay listings
  List<Listing> listings = [];

  /// Creates a new User object.
  UserProfile({
    required this.id,
    required this.firstName, 
    required this.lastName, 
    required this.ebayAPI,
    required this.aliAPI,
    required this.theme,
    required this.listingIDs,
  });

  bool get ebayRefreshTokenValid => ebayAPI != null && ebayAPI!['refresh_token_valid_time'] > DateTime.now().millisecondsSinceEpoch; 

  bool get ebayTokenValid => ebayAPI != null && ebayAPI!['token_valid_time'] > DateTime.now().millisecondsSinceEpoch; 

  bool get aliTokenValid => aliAPI != null && aliAPI!['refresh_token_valid_time'] > DateTime.now().millisecondsSinceEpoch; 

  /// Creates a new User object from a JSON object.
  UserProfile.fromJson(Json json) : 
    firstName = json["first name"],
    lastName = json["last name"],
    id = json["id"],
    ebayAPI = json["ebay"],
    aliAPI = json["ali"],
    theme = json["theme"] == null ? ThemeMode.system : ThemeMode.values.byName(json["theme"]),
    //TODO decode the json
    listingIDs = json["listingIDs"] == null ? [] : [const ItemID("WE HAVE AT LEAST ONE THING")];

  /// Convert this user to its JSON representation
  Json toJson() => {
    "id": id,
    "first name": firstName,
    "last name": lastName,
    "ebay": ebayAPI,
    "ali": aliAPI,
    "theme": theme.name,
    "listingIDs": listingIDs,
  };
}