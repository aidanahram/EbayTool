import "types.dart";

class Order {
  ItemID itemID;
  UserID? owner;
  String? title;
  double price;
  int quantity;
  String? aliExpressLink;
  String? sku;
  String? mainImage;

  Order({
    required this.itemID,
    this.owner,
    required this.price,
    required this.quantity,
    this.aliExpressLink,
    this.title,
    this.sku,
    this.mainImage,
  });

  Order.fromJson(Json json)
      : itemID = json["itemID"],
        owner = json["owner"],
        title = json["title"],
        price = json["price"],
        quantity = int.parse(json["quantity"]),
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
}
