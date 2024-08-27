import "types.dart";

class Listing {
  ItemID itemID;
  UserID owner;
  double price;
  int quantity;
  String aliExpressLink;

  Listing({
    required this.itemID,
    required this.owner,
    required this.price,
    required this.quantity,
    required this.aliExpressLink,
  });

  Listing.fromJson(Json json) :
    itemID = json["itemID"],
    owner = json["owner"],
    price = json["price"],
    quantity = int.parse(json["quantity"]),
    aliExpressLink = json["aliExpressLink"];

  Json toJson() => {
    "itemID": itemID,
    "owner": owner,
    "price": price,
    "quantity": quantity,
    "aliExpressLink": aliExpressLink,
  };
}
