import "package:loading_animation_widget/loading_animation_widget.dart";

import 'package:ebay/models.dart';
import 'package:ebay/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ebay/pages.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersDataSource extends DataTableSource {
  String missingImage =
      "https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=";

  final OrdersViewModel model;

  @override
  OrdersDataSource({required this.model});

  @override
  int get rowCount => model.filteredOrders.length;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= rowCount) {
      return null;
    } else {
      final order = model.filteredOrders[index];
      return DataRow(
        cells: <DataCell>[
          DataCell(SelectableText(order.orderID.toString())),
          DataCell(SelectableText(order.title)),
          DataCell(SelectableText("\$${order.soldPrice.toStringAsFixed(2)}")),
          DataCell(SelectableText("\$${order.payout.toStringAsFixed(2)}")),
          DataCell(SelectableText(order.quantity.toString())),
          DataCell(SelectableText(order.itemID.toString())),
          DataCell(DecoratedBox(
            decoration: BoxDecoration(
              color: order.shipped ? Colors.green : Colors.red,
            ),
          ),),
        ],
        onLongPress: () => launchUrl(Uri.parse("https://www.ebay.com/mesh/ord/details?orderid=${order.orderID}")),
      );
    }
  }

  @override
  bool get isRowCountApproximate => false;
  
  @override
  int get selectedRowCount => 0;
}

class OrdersPage extends ReactiveWidget<OrdersViewModel> {
  const OrdersPage({super.key});

  @override
  OrdersViewModel createModel() => OrdersViewModel();

  @override
  Widget build(BuildContext context, OrdersViewModel model) => Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.orange,
      title: const Text("Orders"),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => models.user.isSignedIn
              ? model.refreshOrders()
              : print("user is not signed in"),
        ),
      ],
    ),
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          SearchBar(
            hintText: "Search for a product",
            padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            leading: const Icon(Icons.search),
            onChanged: model.search,
          ),
          const SizedBox(height: 10),
          LayoutBuilder(
            builder: (context, constraints) => Container(
            //width: MediaQuery.of(context).size.width,
            //height: MediaQuery.of(context).size.height,
              margin: model.isLoading ? const EdgeInsets.symmetric(vertical: 100.0, horizontal: 80.0) : const EdgeInsets.symmetric(horizontal: 80.0),
              constraints: BoxConstraints(maxWidth: constraints.maxWidth, maxHeight: constraints.maxHeight),
              child: model.isLoading ? LoadingAnimationWidget.hexagonDots(color: Colors.black, size:  100.0) : PaginatedDataTable(
                columns: const <DataColumn>[
                  DataColumn(label: Text("Order Id")),
                  DataColumn(label: Text("Title")),
                  DataColumn(label: Text("Sold Price")),
                  DataColumn(label: Text("Payout")),
                  DataColumn(label: Text("Quantity")),
                  DataColumn(label: Text("Item ID")),
                  DataColumn(label: Text("Shipepd")),
                ],
                source: OrdersDataSource(model: model),
                showEmptyRows: false,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}