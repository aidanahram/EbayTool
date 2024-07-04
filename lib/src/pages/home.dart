import 'package:ebay/app.dart';
import 'package:ebay/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ebay/pages.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Ebay Drop Shipping Tool"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SearchBar(
              hintText: "Search for a product",
              padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
              leading: const Icon(Icons.search),
              onSubmitted: (value) {
                print(value);
              },
            ),



            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
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