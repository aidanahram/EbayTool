import "types.dart";

/// Data for an eBay order
class Order {
  ItemID itemID;
  UserID? owner;
  String? title;
  double price;
  int quantity;
  String? sku;
  String? mainImage;

  Order({
    required this.itemID,
    this.owner,
    required this.price,
    required this.quantity,
    this.title,
    this.sku,
    this.mainImage,
  });

  Order.fromJson(Json json)
      : itemID = json["itemID"],
        owner = json["owner"],
        title = json["title"],
        price = json["price"],
        quantity = json["quantity"],
        sku = json["sku"],
        mainImage = json["mainImage"];

  Json toJson() => {
        "itemID": itemID,
        "owner": owner,
        "title": title ?? "",
        "price": price,
        "quantity": quantity,
        "sku": sku ?? "",
        "mainImage": mainImage ?? "",
      };
}
