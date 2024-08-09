import "package:cloud_firestore/cloud_firestore.dart";

import "package:ebay/data.dart";

import "firestore.dart";
import "service.dart";

/// A service to interface with our database, Firebase's Cloud Firestore.
class Database extends Service {
  /// The Cloud Firestore plugin.
  FirebaseFirestore get firestore => FirebaseFirestore.instance;

  /// A collection of [UserProfile] objects.
  Collection<UserProfile, UserID> get users => firestore.collection("users").convert(
    fromJson: UserProfile.fromJson,
    toJson: (user) => user.toJson(),
  );

  /// A collection of [Product] objects.
  // Collection<Product, ProductID> get products => firestore.collection("products").convert(
  //   fromJson: Product.fromJson,
  //   toJson: (product) => product.toJson(),
  // );

  @override
  Future<void> init() async { }

  @override
  Future<void> dispose() async { }

  /// Gets the currently signed-in user's profile.
  Future<UserProfile?> getUserProfile(UserID userId) async{
      return users.doc(userId).getData();
    }

  /// Saves the user's profile to their user document (in [users]).
  Future<void> saveUserProfile(UserProfile user) =>
    users.doc(user.id).set(user);

  /// Saves a product to the database.
  // Future<void> saveProduct(Product product) =>
  //   products.doc(product.id).set(product);

  /// Gets a list of products listed by the seller with the given [sellerID].
  // Future<List<Product>> getProductsBySellerID(SellerID sellerID) =>
  //   products.where("sellerID", isEqualTo: sellerID).limit(20).getAll();

  // /// Gets the product from the the given product ID
  // Future<Product?> getProduct(ProductID productID) =>
  //   products.doc(productID).getData();

  // /// Deletes a product from the database.
  // Future<void> deleteProduct(ProductID id) => products.doc(id).delete();
}