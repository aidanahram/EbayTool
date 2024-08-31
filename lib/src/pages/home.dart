// import 'package:ebay/app.dart';
import 'package:ebay/models.dart';
import 'package:ebay/services.dart';
import 'package:ebay/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ebay/pages.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const redirectUrl =
      "https://webhook.site/492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  static const aliSignOn =
      "https://api-sg.aliexpress.com/oauth/authorize?response_type=code&force_auth=true&redirect_uri=$redirectUrl&client_id=508156";
  static const ebaySignOn =
      "https://auth.ebay.com/oauth2/authorize?client_id=AidanAhr-first-PRD-9f5c11990-5d41c06c&response_type=code&redirect_uri=Aidan_Ahram-AidanAhr-first--jssslhkm&scope=https://api.ebay.com/oauth/api_scope https://api.ebay.com/oauth/api_scope/sell.marketing.readonly https://api.ebay.com/oauth/api_scope/sell.marketing https://api.ebay.com/oauth/api_scope/sell.inventory.readonly https://api.ebay.com/oauth/api_scope/sell.inventory https://api.ebay.com/oauth/api_scope/sell.account.readonly https://api.ebay.com/oauth/api_scope/sell.account https://api.ebay.com/oauth/api_scope/sell.fulfillment.readonly https://api.ebay.com/oauth/api_scope/sell.fulfillment https://api.ebay.com/oauth/api_scope/sell.analytics.readonly https://api.ebay.com/oauth/api_scope/sell.finances https://api.ebay.com/oauth/api_scope/sell.payment.dispute https://api.ebay.com/oauth/api_scope/commerce.identity.readonly https://api.ebay.com/oauth/api_scope/sell.reputation https://api.ebay.com/oauth/api_scope/sell.reputation.readonly https://api.ebay.com/oauth/api_scope/commerce.notification.subscription https://api.ebay.com/oauth/api_scope/commerce.notification.subscription.readonly https://api.ebay.com/oauth/api_scope/sell.stores https://api.ebay.com/oauth/api_scope/sell.stores.readonly";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => models.user.isSignedIn ? services.ebayScraper.getProducts(models.user.userProfile!) : print("user is not signed in")         
        ),]
      ),
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
              onTap: () async {
                final url = Uri.parse(aliSignOn);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                  if (context.mounted) {
                    showDialog<void>(
                        context: context,
                        builder: (_) => const APIEditor(
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
                onTap: () async {
                  final url = Uri.parse(ebaySignOn); //
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.inAppWebView);
                    if (context.mounted) {
                      showDialog<void>(
                          context: context,
                          builder: (_) => const APIEditor(
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
                          if(context.mounted){
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  )
                ),
              )

          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            SearchBar(
              hintText: "Search for a product",
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
              onSubmitted: (value) {
                print(value);
              },
            ),
            const SizedBox(height: 10,),
            PaginatedDataTable(
              columns: const <DataColumn>[
                DataColumn(label: Text("Main Image")),
                DataColumn(label: Text("Title")),
                DataColumn(label: Text("Price")),
                DataColumn(label: Text("Quantity")),
                DataColumn(label: Text("Item ID")),
              ], 
              source: DataSource(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => router.go("/home/add_item"),
        tooltip: 'Add new product',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class DataSource extends DataTableSource {
  @override
  int get rowCount => models.user.userProfile!.listings.length;

  @override
  DataRow? getRow(int index) {
    switch (index) {
      case 0:
        return const DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
            DataCell(Text('Student')),
            DataCell(Text('Student')),
          ],
        );
      case 1:
        return const DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
            DataCell(Text('Student')),
            DataCell(Text('Student')),
          ],
        );
      case 2:
        return const DataRow(
          cells: <DataCell>[
            DataCell(Text('Sarah')),
            DataCell(Text('19')),
            DataCell(Text('Student')),
            DataCell(Text('Student')),
            DataCell(Text('Student')),
          ],
        );
      default:
        return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
