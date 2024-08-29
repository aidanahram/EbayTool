import "types.dart";

class Listing {
  ItemID itemID;
  UserID owner;
  String? productName;
  double price;
  int quantity;
  String? aliExpressLink;
  String? sku;
  String? mainImage;

  Listing({
    required this.itemID,
    required this.owner,
    required this.price,
    required this.quantity,
    this.aliExpressLink,
    this.productName,
    this.sku,
    this.mainImage,
  });

  Listing.fromJson(Json json) :
    itemID = json["itemID"],
    owner = json["owner"],
    productName = json["productName"],
    price = json["price"],
    quantity = int.parse(json["quantity"]),
    aliExpressLink = json["aliExpressLink"],
    sku = json["sku"],
    mainImage = json["mainImage"];

  Json toJson() => {
    "itemID": itemID,
    "owner": owner,
    "productName" : productName ?? "",
    "price": price,
    "quantity": quantity,
    "aliExpressLink": aliExpressLink ?? "",
    "sku": sku ?? "",
    "mainImage": mainImage ?? "",
  };
}
