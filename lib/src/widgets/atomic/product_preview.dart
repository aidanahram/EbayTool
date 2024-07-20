import 'package:flutter/material.dart';

class ProductPreview extends StatefulWidget {
  final String response;

  const ProductPreview({super.key, required this.response});

  @override
  State<ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: Text(widget.response),
  );
}