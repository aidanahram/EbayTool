import "types.dart";

/// Data for an eBay order
class Order {
  OrderID orderID;
  ItemID itemID;
  String buyerUsername;
  String title;
  double soldPrice;
  double payout;
  int quantity;
  bool shipped;
  String? sku;

  Order({
    required this.orderID,
    required this.itemID,
    required this.buyerUsername,
    required this.soldPrice,
    required this.payout,
    required this.quantity,
    required this.title,
    required this.shipped,
    this.sku,
  });
}
