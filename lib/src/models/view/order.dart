import "package:ebay/data.dart";
import "package:ebay/models.dart";

/// A view model to show the order page.
class OrdersViewModel extends ViewModel {
  /// Whether the model is loading
  bool isLoading = false;
  /// List of [Listing] to be displayed in the UI
  List<Order> orders = [];

  String query = "";

  List<Order> get filteredOrders =>
    orders.where(filter).toList();

  bool filter(Order o) => o.title.toLowerCase().contains(query) || o.itemID.id.contains(query) || o.orderID.id.contains(query);

  OrdersViewModel();

  @override
  Future<void> init() async {
    isLoading = true;
    await refreshOrders();
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshOrders() async {
    isLoading = true;
    notifyListeners();
    orders = await models.user.getOrdersInformation();
    isLoading = false;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void search(String input){
    query = input.toLowerCase();
    notifyListeners();
  }
}