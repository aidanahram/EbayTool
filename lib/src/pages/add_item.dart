import 'package:ebay/services.dart';
import 'package:ebay/src/models/view/ali_product.dart';
import 'package:flutter/material.dart';

// import 'package:ebay/pages.dart';
// import 'package:ebay/data.dart';
import 'package:ebay/widgets.dart';

class AddItemPage extends ReactiveWidget<AliProductModel> {
  const AddItemPage({super.key});

  @override
  AliProductModel createModel() => AliProductModel();

  @override
  Widget build(BuildContext context, AliProductModel model) {
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
              padding: const MaterialStatePropertyAll<EdgeInsets>(
                  EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
              onSubmitted: (value) async {
                model.response = await services.aliScraper.getProduct(value);
                model.init();
              },
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: model.response == ""
                    ? const SizedBox.shrink()
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(model.productName,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                            const Text("Images of Product"),
                            Image.network(model.imageLinks[model.mainIndex],
                                width: 450, height: 450),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                for (int i = 0;
                                    i < model.imageLinks.length;
                                    i++)
                                  Material(
                                    child: InkWell(
                                      onTap: () {
                                        model.setMainImage(i);
                                      },
                                      child: Image.network(
                                        model.imageLinks[i],
                                        width: 150,
                                        height: 150,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            const Text(
                              "Items Found on Page. Select one and choose which images to keep. Beware of duplicates",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: [
                                for (int i = 0; i < model.items.length; i++)
                                  Column(
                                    children: [
                                      Text(model.items[i].name),
                                      model.items[i].imageLink != null
                                          ? Image.network(
                                              model.items[i].imageLink!,
                                              width: 200,
                                              height: 200,
                                            )
                                          : const SizedBox(
                                              width: 200, height: 200),
                                      Text(model.items[i].price.toString()),
                                    ],
                                  ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
