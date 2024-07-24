
import 'package:flutter/material.dart';
import 'dart:convert';

class ProductPreview extends StatefulWidget {
  final String response;

  ProductPreview({super.key, required this.response});

  @override
  State<ProductPreview> createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  int mainIndex = 0;

  @override
  Widget build(BuildContext context) {
    if(widget.response == ""){
      return const Placeholder();
    } else {
      final data = json.decode(widget.response);
      final imageLinks = getProductImages(data);
      return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Images of Product"),
            Image.network(imageLinks[mainIndex], width: 500, height: 500),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [for(int i = 0; i < imageLinks.length; i++) Material(
                child: InkWell(
                  onTap: () {setState(() { mainIndex = i; }); },
                  child: Image.network(
                    imageLinks[i], width: 150, height: 150,
                  )
                )
              )]
            ),  
          ],
        )
      );
    }
  }
}

class ItemImageWidget extends InkWell{
  const ItemImageWidget({super.key});
}

List<String> getProductImages(dynamic data){
  final urls = data['aliexpress_ds_product_get_response']['result']['ae_multimedia_info_dto']['image_urls'];
  print(urls);
  return urls.toString().split(';');
}
