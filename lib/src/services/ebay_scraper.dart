import 'dart:convert';

import 'package:ebay/data.dart';
import 'package:ebay/src/services/service.dart';
import 'package:http/http.dart' as http;


class EbayScraper extends Service{
  final api = 'localhost:8081';

  EbayScraper();

  /// Function to initialize the scraper
  @override
  Future<void> init() async {}

  /// Function to dispose of the scraper
  @override
  Future<void> dispose() async {}

  Future<Map<String, dynamic>?> generateToken(String code) async {
    final uri = Uri.http(api, '/identity/v1/oauth2/token');
    final Map<String, String> headers = {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Authorization': 'true',
    };
    final Map<String, String> payload = {
      'grant_type': 'authorization_code',
      'code': code,
      'redirect_uri': 'Aidan_Ahram-AidanAhr-first--jssslhkm',
    };
    try {
      final response = await http.post(uri, headers: headers, body: payload);
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      print(response.body);
      return jsonDecode(response.body);
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
      print(e);
      return null;
    }
  }

  Future<void> getProducts(UserProfile user) async {
    if(!user.ebayTokenValid){
      print("Ebay token not valid");
      return;
    }
    final uri = Uri.http(api, '/sell/feed/v1/inventory_task');
    print(uri);
    print(user.ebayAPI!["access_token"]);
    final Map<String, String> headers = {
      "Authorization": "Bearer ${user.ebayAPI!["access_token"]}",
      "Accept": "application/json",
      "Content-Type": "application/json",  
      //"X-EBAY-C-MARKETPLACE-ID": "EBAY_US",
    };
    final payload = jsonEncode({
      'schemaVersion': '1.0',
      'feedType': 'LMS_ACTIVE_INVENTORY_REPORT',
    });
    try {
      final response = await http.post(uri, headers: headers, body: payload);
      //final response = await http.post(uri, headers: headers, body: payload);
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      print(response.body);
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
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

void main() async {
  const auth = "v^1.1#i^1#r^0#I^3#f^0#p^3#t^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";

  final Map<String, String> headers = {
      "Authorization": "Bearer $auth",
      "Accept": "application/json",
      "Content-Type": "application/json",  
      "X-EBAY-C-MARKETPLACE-ID": "EBAY_US",
    };
    final payload = jsonEncode({
      'schemaVersion': '1.0',
      'feedType': 'LMS_ACTIVE_INVENTORY_REPORT',
    });
    try {
      final response = await http.post(Uri.parse('https://api.ebay.com/sell/feed/v1/inventory_task'), headers: headers, body: payload);
      print(response.statusCode);
      //final response = await http.post(uri, headers: headers, body: payload);
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      print(response.body);
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
      print(e);
    }
}
