import "package:cloud_firestore/cloud_firestore.dart";

import "package:ebay/data.dart";
import "package:ebay/services.dart";

import "firestore.dart";

/// A service to interface with our database, Firebase's Cloud Firestore.
class Database extends Service {
  /// The Cloud Firestore plugin.
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// A collection of [UserProfile] objects.
  Collection<UserProfile, UserID> get users =>
      firestore.collection("users").convert(
            fromJson: UserProfile.fromJson,
            toJson: (user) => user.toJson(),
          );

  /// A collection of [Listing] objects.
  Collection<Listing, ItemID> get listings =>
      firestore.collection("listings").convert(
            fromJson: Listing.fromJson,
            toJson: (listing) => listing.toJson(),
          );

  /// A collection of [Product] objects.
  // Collection<Product, ProductID> get products => firestore.collection("products").convert(
  //   fromJson: Product.fromJson,
  //   toJson: (product) => product.toJson(),
  // );

  @override
  Future<void> init() async {}

  @override
  Future<void> dispose() async {}

  /// Gets the currently signed-in user's profile.
  Future<UserProfile?> getUserProfile(UserID userId) =>
      users.doc(userId).getData();

  /// Saves the user's profile to their user document (in [users]).
  Future<void> saveUserProfile(UserProfile user) =>
      users.doc(user.id).set(user);

  /// Saves a ebay listing to the database
  Future<void> saveListing(Listing listing) =>
      listings.doc(listing.itemID).set(listing).catchError((err) => print(err));

  Future<Listing?> getListing(ItemID itemID) => listings.doc(itemID).getData().catchError((err) {print("$itemID $err"); return null;});
}
