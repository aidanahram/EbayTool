import "types.dart";

class Listing {
  ItemID itemID;
  UserID? owner;
  String? title;
  double price;
  int quantity;
  String? aliExpressLink;
  String? sku;
  String? mainImage;

  Listing({
    required this.itemID,
    this.owner,
    required this.price,
    required this.quantity,
    this.aliExpressLink,
    this.title,
    this.sku,
    this.mainImage,
  });

  Listing.fromJson(Json json)
      : itemID = json["itemID"],
        owner = json["owner"],
        title = json["title"],
        price = json["price"],
        quantity = json["quantity"],
        aliExpressLink = json["aliExpressLink"],
        sku = json["sku"],
        mainImage = json["mainImage"];

  Json toJson() => {
        "itemID": itemID,
        "owner": owner,
        "title": title ?? "",
        "price": price,
        "quantity": quantity,
        "aliExpressLink": aliExpressLink ?? "",
        "sku": sku ?? "",
        "mainImage": mainImage ?? "",
      };

  @override
  String toString() => "Listing($itemID, $title, $owner, $price, $quantity)";
}
