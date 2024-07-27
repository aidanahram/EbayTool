import 'dart:convert';

import 'package:http/http.dart' as http;

class EbayScraper{
  String? token;
  final baseEndpoint = "https://api.ebay.com/sell/feed/v1";
  Map<String, String> headers = {
    "Accept": "application/json",
    "Content-Type": "application/json",
    "X-EBAY-C-MARKETPLACE-ID": "EBAY_US"
  };

  EbayScraper();

   /// Function to initialize the scraper
  Future<void> init() async {}

  /// Function to dispose of the scraper
  Future<void> dispose() async {}

  Future<void> generateToken(String code) async {
    const endpoint = "https://api.ebay.com/identity/v1/oauth2/token";
    
    //base64Encode(bytes)
  }
  
  // Future<String> createTask() async {
  //   final url = "$baseEndpoint/inventory_task";
  //   final payload = {
  //       "schemaVersion": "1.0",
  //       "feedType": "LMS_ACTIVE_INVENTORY_REPORT",
  //       "filterCriteria": {
  //           "orderStatus": "ACTIVE"
  //       }
  //   };
  //   final response = await http.post(url, headers: headers, json: payload);
  //   return Future.value(response.headers["location"]);
  // }

  // Future<String> checkStatus(String url) async {
  //   for(int i = 0; i < 3; i++){
  //     final response = await http.get(url, headers: headers);
  //     final json = jsonDecode(response.body);
  //     if(json["status"] == "COMPLETED"){
  //       return Future.value(json["taskId"]);
  //     }
  //     await Future.delayed(const Duration(seconds: 3));
  //   }
  //   throw Error();
  // }

  // void downloadFile(String url) async {
  //   headers = {"Authorization": "Bearer $token", "Accept": "*/*"};
  //   final response = await http.get(url, headers: headers);
  //   try{

  //   } on Exception catch (e) {
  //     print(response.headers);
  //     print(response.body);
  //     rethrow;
  //   }
  // }

  // void gatherProductData() async {
  //   final url = await createTask();
  //   print(url);
  //   final taskId = await checkStatus(url);
  //   downloadFile("$baseEndpoint/task/$taskId/download_result_file");
  // }
}

void main(){
  final scraper = EbayScraper();
  //scraper.gatherProductData();
}
