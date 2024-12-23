import "package:loading_animation_widget/loading_animation_widget.dart";

import 'package:ebay/models.dart';
import 'package:ebay/widgets.dart';
import 'package:ebay/services.dart';
import 'package:flutter/material.dart';
import 'package:ebay/pages.dart';
import 'package:url_launcher/url_launcher.dart';

class ListingsDataSource extends DataTableSource {
  String missingImage =
      "https://media.istockphoto.com/id/1472933890/vector/no-image-vector-symbol-missing-available-icon-no-gallery-for-this-moment-placeholder.jpg?s=612x612&w=0&k=20&c=Rdn-lecwAj8ciQEccm0Ep2RX50FCuUJOaEM8qQjiLL0=";

  final HomeViewModel model;

  @override
  ListingsDataSource({required this.model});

  @override
  int get rowCount => model.filteredListing.length;

  @override
  DataRow? getRow(int index) {
    if (index < 0 || index >= rowCount) {
      return null;
    } else {
      final listing = model.filteredListing[index];
      return DataRow(
        cells: <DataCell>[
          DataCell(Image.network(listing.mainImage ?? missingImage, width: 20, height: 20)),
          DataCell(SelectableText(listing.title ?? "missing name")),
          DataCell(SelectableText("\$${listing.price.toStringAsFixed(2)}")),
          DataCell(SelectableText(listing.quantity.toString())),
          DataCell(SelectableText(listing.itemID.toString())),
        ],
        onLongPress: () => launchUrl(Uri.parse("https://www.ebay.com/itm/${listing.itemID}")),
      );
    }
  }

  @override
  bool get isRowCountApproximate => false;
  
  @override
  int get selectedRowCount => 0;
}

class HomePage extends ReactiveWidget<HomeViewModel> {
  static const redirectUrl =
      "https://webhook.site/492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  static const aliSignOn =
      "https://api-sg.aliexpress.com/oauth/authorize?response_type=code&force_auth=true&redirect_uri=$redirectUrl&client_id=508156";
  static const ebaySignOn =
      "https://auth.ebay.com/oauth2/authorize?client_id=AidanAhr-first-PRD-9f5c11990-5d41c06c&response_type=code&redirect_uri=Aidan_Ahram-AidanAhr-first--jssslhkm&scope=https://api.ebay.com/oauth/api_scope https://api.ebay.com/oauth/api_scope/sell.marketing.readonly https://api.ebay.com/oauth/api_scope/sell.marketing https://api.ebay.com/oauth/api_scope/sell.inventory.readonly https://api.ebay.com/oauth/api_scope/sell.inventory https://api.ebay.com/oauth/api_scope/sell.account.readonly https://api.ebay.com/oauth/api_scope/sell.account https://api.ebay.com/oauth/api_scope/sell.fulfillment.readonly https://api.ebay.com/oauth/api_scope/sell.fulfillment https://api.ebay.com/oauth/api_scope/sell.analytics.readonly https://api.ebay.com/oauth/api_scope/sell.finances https://api.ebay.com/oauth/api_scope/sell.payment.dispute https://api.ebay.com/oauth/api_scope/commerce.identity.readonly https://api.ebay.com/oauth/api_scope/sell.reputation https://api.ebay.com/oauth/api_scope/sell.reputation.readonly https://api.ebay.com/oauth/api_scope/commerce.notification.subscription https://api.ebay.com/oauth/api_scope/commerce.notification.subscription.readonly https://api.ebay.com/oauth/api_scope/sell.stores https://api.ebay.com/oauth/api_scope/sell.stores.readonly";

  const HomePage({super.key});

  @override
  HomeViewModel createModel() => HomeViewModel();

  @override
  Widget build(BuildContext context, HomeViewModel model) => Scaffold(
    appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Ebay Drop Shipping Tool"),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => models.user.isSignedIn
                ? model.refreshListings()
                : print("user is not signed in"),
          ),
        ]),
    drawer: Drawer(
      child: Column(
        children: [
          DrawerHeader(
              child: Row(
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).closeDrawer();
                    },
                  );
                },
              ),
              const Text("Menu"),
            ],
          )),
          ListTile(
              title: const Text("Verify Ali Express Account"),
              tileColor: models.user.isSignedIn && models.user.userProfile != null && models.user.userProfile!.aliTokenValid ? Colors.green : Colors.red,
              onTap: () async {
                final url = Uri.parse(aliSignOn);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                  if (context.mounted) {
                    showDialog<void>(
                        context: context,
                        builder: (_) => APIEditor(
                              homeModel: model,
                              website: "AliExpress",
                            ));
                  }
                } else {
                  throw "Could not launch $url";
                }
              }),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("Verify eBay Account"),
            tileColor: models.user.isSignedIn && models.user.userProfile != null && models.user.userProfile!.ebayRefreshTokenValid ? Colors.green : Colors.red,
            onTap: () async {
              final url = Uri.parse(ebaySignOn); //
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.inAppWebView);
                if (context.mounted) {
                  showDialog<void>(
                      context: context,
                      builder: (_) => APIEditor(
                            homeModel: model,
                            website: "Ebay",
                          ));
                }
              } else {
                throw "Could not launch $url";
              }
            }),
          const Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: const Text("Orders"),
            onTap: () => router.go("/home/orders"),
          ),
          const Divider(
            color: Colors.grey,
          ),
          Expanded(
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ListTile(
                      hoverColor: Colors.blue,
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      title: const Text('Settings'),
                      onTap: () {
                        router.go("/home/settings");
                      },
                    ),
                    ListTile(
                      hoverColor: Colors.blue,
                      dense: true,
                      visualDensity: const VisualDensity(vertical: -4),
                      leading: const Icon(
                        Icons.logout,
                        color: Colors.black,
                      ),
                      title: const Text('Logout'),
                      onTap: () async {
                        await models.user.signOut();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                )),
          )
        ],
      ),
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
                columnSpacing: 15.0,
                columns: const <DataColumn>[
                  DataColumn(label: Text("Main Image")),
                  DataColumn(label: Text("Title")),
                  DataColumn(label: Text("Price")),
                  DataColumn(label: Text("Quantity")),
                  DataColumn(label: Text("Item ID")),
                ],
                source: ListingsDataSource(model: model),
                showEmptyRows: false,
              ),
            ),
          ),
        ],
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () => router.go("/home/addItem"),
      tooltip: 'Add new product',
      child: const Icon(Icons.add),
    ),
  );
}