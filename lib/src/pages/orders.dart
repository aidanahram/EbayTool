import "package:loading_animation_widget/loading_animation_widget.dart";

import 'package:ebay/models.dart';
import 'package:ebay/widgets.dart';
import 'package:flutter/material.dart';
import 'package:ebay/pages.dart';
import 'package:url_launcher/url_launcher.dart';

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
  );
}