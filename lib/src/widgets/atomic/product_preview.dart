import 'package:flutter/material.dart';
import 'dart:convert';

class ProductPreview extends StatefulWidget {
  final String response;

  const ProductPreview({super.key, required this.response});

  @override
  State<ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {

  @override
  Widget build(BuildContext context) {
    if(widget.response == ""){
      return const Placeholder();
    } else {
      final data = json.decode(widget.response);
      final imageLinks = getProductImages(data);
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [for (final link in imageLinks) Image.network(
              link, width: 100, height: 100,
            )]
          ),
        ),
      );
    }
  }
}

List<String> getProductImages(dynamic data){
  final urls = data['aliexpress_ds_product_get_response']['result']['ae_multimedia_info_dto']['image_urls'];
  print(urls);
  return urls.toString().split(';');
}
