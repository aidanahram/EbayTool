import "dart:async";
import "dart:convert";
import "dart:ui";
import "package:flutter/material.dart";
import "package:flutter/services.dart";

class AliProductModel with ChangeNotifier {
  String response = "";
  dynamic data;
  String itemName = "";
  List<String> imageLinks = [];
  int mainIndex = 0;

  AliProductModel();

  void init(){
    try{
      data = json.decode(response);
      imageLinks = _getProductImages(data);
      itemName = data['aliexpress_ds_product_get_response']['result']['ae_item_base_info_dto']['subject'];
      notifyListeners();
    } on Exception catch (e) {
      print("Error was thrown while trying to initialize");
      print(e);
    }
  }

  List<String> _getProductImages(dynamic data){
    final urls = data['aliexpress_ds_product_get_response']['result']['ae_multimedia_info_dto']['image_urls'];
    return urls.toString().split(';');
  }

  void setMainImage(int index){
    mainIndex = index;
    notifyListeners();
  }
}