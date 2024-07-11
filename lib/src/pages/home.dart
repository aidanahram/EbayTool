import 'package:ebay/app.dart';
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
  final redirectUrl = "https://webhook.site/492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  final appKey = "508156";

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              margin: EdgeInsets.zero,
              padding: EdgeInsets.zero,
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
              )
            ),
            ListTile(
              title: const Text("Authenticate Ali Express Account"),
              onTap: () async {
                final url = Uri.parse("https://api-sg.aliexpress.com/oauth/authorize?response_type=code&force_auth=true&redirect_uri=$redirectUrl&client_id=$appKey");
                if(await canLaunchUrl(url)){
                  await launchUrl(url);
                } else {
                  throw "Could not launch $url";
                }
              }
            ),
            ListTile(
              title: const Text("Verify your eBay Account"),
              onTap: () async {
                final url = Uri.parse("https://ebay.com");//
                if(await canLaunchUrl(url)){
                  await launchUrl(url);
                } else {
                  throw "Could not launch $url";
                }
              }
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10),
            SearchBar(
              hintText: "Search for a product",
              padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
              onSubmitted: (value) {
                print(value);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(Routes.addItem),
        tooltip: 'Add new product',
        child: const Icon(Icons.add),
      ), 
    );
  }
}