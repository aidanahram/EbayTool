import 'dart:convert';

// import 'package:requests/requests.dart';

// class EbayScraper{
//   String token;
//   final baseEndpoint = "https://api.ebay.com/sell/feed/v1";
//   Map<String, String> headers = {
//     "Accept": "application/json",
//     "Content-Type": "application/json",
//     "X-EBAY-C-MARKETPLACE-ID": "EBAY_US"
//   };

//   EbayScraper({required this.token}){
//     headers["Authorization"] = "Bearer $token";
//   }

//   Future<String> createTask() async {
//     final url = "$baseEndpoint/inventory_task";
//     final payload = {
//         "schemaVersion": "1.0",
//         "feedType": "LMS_ACTIVE_INVENTORY_REPORT",
//         "filterCriteria": {
//             "orderStatus": "ACTIVE"
//         }
//     };
//     final response = await Requests.post(url, headers: headers, json: payload);
//     response.throwForStatus();
//     return Future.value(response.headers["location"]);
//   }

//   Future<String> checkStatus(String url) async {
//     for(int i = 0; i < 3; i++){
//       final response = await Requests.get(url, headers: headers);
//       response.throwForStatus();
//       final json = jsonDecode(response.body);
//       if(json["status"] == "COMPLETED"){
//         return Future.value(json["taskId"]);
//       }
//       await Future.delayed(const Duration(seconds: 3));
//     }
//     throw Error();
//   }

//   void downloadFile(String url) async {
//     headers = {"Authorization": "Bearer $token", "Accept": "*/*"};
//     final response = await Requests.get(url, headers: headers);
//     try{
//       response.throwForStatus();
//     } on HTTPException {
//       print(response.headers);
//       print(response.body);
//       rethrow;
//     }
//   }

//   void gatherProductData() async {
//     final url = await createTask();
//     print(url);
//     final taskId = await checkStatus(url);
//     downloadFile("$baseEndpoint/task/$taskId/download_result_file");
//   }
// }

// void main(){
//   final scraper = EbayScraper(token: "v^1.1#i^1#p^3#I^3#f^0#r^0#t^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");
//   scraper.gatherProductData();
// }
