import 'dart:convert';

import 'package:http/http.dart' as http;

class EbayScraper {
  final api = 'localhost:8081';

  EbayScraper();

  /// Function to initialize the scraper
  Future<void> init() async {}

  /// Function to dispose of the scraper
  Future<void> dispose() async {}

  Future<void> generateToken(String code) async {
    final uri = Uri.http(api, '/identity/v1/oauth2/token');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      //'Authorization': 'Basic ${base64.encode(utf8.encode("$appId:$appSecret"))}',
      'Authorization': 'true',
    };
    final Map<String, String> payload = {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': 'Aidan_Ahram-AidanAhr-first--jssslhkm',
    };
    print("Sending first");
    try {
      final response = await http.post(uri, headers: headers, body: payload);
      print("wheres the error");
      print(response.statusCode);
      print(response.headers);
      print("BODY: ${response.body}");
    } on Exception catch (e) {
      print(e);
    }
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

void main() {
  final scraper = EbayScraper();
  scraper.generateToken(
      'v^1.1#i^1#p^3#f^0#r^1#I^3#t^Ul41XzExOkY1MUUwQUUzMjc0N0E4ODU2OUY2MENDMzYxQzQ5N0Q5XzFfMSNFXjI2MA==');
  //scraper.gatherProductData();
}
