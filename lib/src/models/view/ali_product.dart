import "dart:async";
import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class SubItem {
  final String name;
  final String price;
  final String? imageLink;
  SubItem(this.name, this.price, {this.imageLink});
}

class AliProductModel with ChangeNotifier {
  String response = "";
  dynamic data;
  String productName = "";
  int? price;
  List<String> imageLinks = [];
  List<SubItem> items = [];
  int mainIndex = 0;

  AliProductModel();

  void init() {
    try {
      data = json.decode(response);
      imageLinks = _getProductImages(data);
      items = _getSubItems(data);
      productName = data['aliexpress_ds_product_get_response']['result']
          ['ae_item_base_info_dto']['subject'];
      notifyListeners();
    } on Exception catch (e) {
      print("Error was thrown while trying to initialize");
      print(e);
    }
  }

  List<String> _getProductImages(dynamic data) {
    final urls = data['aliexpress_ds_product_get_response']['result']
        ['ae_multimedia_info_dto']['image_urls'];
    return urls.toString().split(';');
  }

  List<SubItem> _getSubItems(dynamic data) {
    List<SubItem> res = [];

    final items = data['aliexpress_ds_product_get_response']['result']
        ['ae_item_sku_info_dtos']['ae_item_sku_info_d_t_o'];
    for (final item in items) {
      final name = item['ae_sku_property_dtos']['ae_sku_property_d_t_o'][0]
          ['property_value_definition_name'];
      final price = item['offer_sale_price'];
      if (item['ae_sku_property_dtos']['ae_sku_property_d_t_o'][0]
          .containsKey('sku_image')) {
        final imageLink = item['ae_sku_property_dtos']['ae_sku_property_d_t_o']
            [0]['sku_image'];
        res.add(SubItem(name, price, imageLink: imageLink));
      } else {
        res.add(SubItem(name, price));
      }
    }
    return res;
  }

  void setMainImage(int index) {
    mainIndex = index;
    notifyListeners();
  }
}
