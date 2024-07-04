import 'package:ebay/services.dart';
import 'package:flutter/material.dart';
import 'package:ebay/pages.dart';
import 'package:ebay/data.dart';


class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Add a new item"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 10.0),
            SearchBar(
              hintText: "Enter link to item",
              padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
              onSubmitted: (value) {
                services.ali_scraper.scrapePage(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}