import "types.dart";

/// A product being listed
///
/// It attaches a ebay listing and aliexpress item
class Product {
  /// This product's unique Product ID.
  final ProductID id;

  /// The user ID who owns this product and its seller profile.
  final UserID userID;

  /// The title or a name of the product.
  final String title;

  /// The product's description.
  final String description;

  /// The price of this product
  final int price;

  /// How many of this product are currently available.
  final int quantity;

  /// A list of images to show in this product's page.
  final List<String> imageUrls;

  /// Whether this product has been de-listed.
  ///
  /// When an item is no longer available, it is still shown but [quantity] will be set to zero.
  /// This is to allow customers to request more of the item from the seller. If the seller wants
  /// to get rid of the listing, they can simply set this to `true` to hide it from buyers. Deleting
  /// a product entirely should also delete its reviews, which can negatively impact the seller's
  /// profile, which is why they might wish to simply delist it instead.
  final bool delisted;

  /// When this product was listed.
  final DateTime dateListed;

  /// The sum of all ratings for the product
  final int ratingSum;

  /// The number of ratings for the product
  final int ratingCount;

  /// The average rating for the product
  final int? averageRating;

  /// A constructor to create a new product.
  const Product({
    required this.id,
    required this.userID,
    required this.title,
    required this.description,
    required this.price,
    required this.quantity,
    required this.imageUrls,
    required this.dateListed,
    this.averageRating = 0,
    this.ratingSum = 0,
    this.ratingCount = 0,
    this.delisted = false,
  });

  /// Creates a new Product object from a JSON object.
  Product.fromJson(Json json)
      : id = json["id"],
        userID = json["userID"],
        title = json["title"],
        description = json["description"],
        price = json["price"].round(),
        quantity = json["quantity"],
        imageUrls = List<String>.from(json["imageUrls"]),
        dateListed = DateTime.parse(json["dateListed"]),
        delisted = json["delisted"] ?? false,
        ratingSum = json["ratingSum"] ?? 0,
        ratingCount = json["ratingCount"] ?? 0,
        averageRating = json["averageRating"];

  /// Convert this Product to its JSON representation
  Json toJson() => {
        "id": id,
        "userID": userID,
        "title": title,
        "_searchKeywords": [
          for (final word in title.split(" ")) 
            word.toLowerCase(),
        ],
        "description": description,
        "price": price,
        "quantity": quantity,
        "imageUrls": imageUrls,
        "dateListed": dateListed.toIso8601String(),
        "delisted": delisted,
        "ratingSum": ratingSum,
        "ratingCount": ratingCount,
        "averageRating": ratingSum / ratingCount == 0 ? 1 : ratingCount,
      };
  
  /// The price, in USD, as a string.
  String get formattedPrice => "\$${(price / 100).toStringAsFixed(2)}";
}