import "dart:convert";

import "package:ebay/data.dart";
import "package:ebay/src/services/service.dart";
import "package:http/http.dart" as http;
import "package:ebay/models.dart";


class EbayScraper extends Service{
  final api = "localhost:8081";

  final client = http.Client();

  EbayScraper();

  /// Function to initialize the scraper
  @override
  Future<void> init() async {}

  /// Function to dispose of the scraper
  @override
  Future<void> dispose() async {}

  Future<Map<String, dynamic>?> generateToken(String code) async {
    final uri = Uri.http(api, "/identity/v1/oauth2/token");
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "true",
    };
    final Map<String, String> payload = {
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": "Aidan_Ahram-AidanAhr-first--jssslhkm",
    };
    try {
      final response = await client.post(uri, headers: headers, body: payload);
      if (response.statusCode >= 400) {
        print("Recieved error code from server");
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      print("Generated token");
      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT");
      print(e);
      return null;
    }
  }

  Future<Map<String, dynamic>?> refreshToken(UserProfile user) async{
    if(!user.ebayTokenValid){
      print("Ebay token not valid");
      return null;
    }
    final uri = Uri.http(api, "/identity/v1/oauth2/token");
    final Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "true",
    };
    final Map<String, String> payload = {
      "grant_type": "refresh_token",
      "refresh_token": user.ebayAPI!["refresh_token"],
      "redirect_uri": "Aidan_Ahram-AidanAhr-first--jssslhkm",
    };
    try {
      final response = await client.post(uri, headers: headers, body: payload);
      if (response.statusCode >= 400) {
        print("Recieved error code from server");
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      print("Refreshed token");
      return jsonDecode(response.body);
    } on Exception catch (e) {
      print("THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT");
      print(e);
      return null;
    }
  }

  Future<void> getProducts(UserProfile user) async {
    if(!user.ebayTokenValid){
      if(!user.ebayRefreshTokenValid){
        print("User needs to reauthorize Ebay API");
        return;
      }
      await models.user.refreshToken();
      user = models.user.userProfile!;
    }
    final uri = Uri.http(api, "/sell/feed/v1/inventory_task");
    final Map<String, String> headers = {
      "Authorization": "Bearer ${user.ebayAPI!["access_token"]}",
      "Accept": "application/json",
      "Content-Type": "application/json",  
      "X-EBAY-C-MARKETPLACE-ID": "EBAY_US",
    };
    final payload = jsonEncode({
      "schemaVersion": "1.0",
      "feedType": "LMS_ACTIVE_INVENTORY_REPORT",
    });
    try {
      final response = await client.post(uri, headers: headers, body: payload);
      if (response.statusCode >= 400) {
        print("Recieved error code from server");
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      if(response.headers['location'] == null){
        print("Response missing location");
        throw Error();
      }
      final location = response.headers['location'];
      if(!await checkStatus(location!.split("/").last, {"Authorization": "Bearer ${user.ebayAPI!["access_token"]}",})){
        print("Task not ready after 10 seconds");
        throw Error();
      }
      print("task is ready");

    } on Exception catch (e) {
      print("THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT");
      print(e);
    }
  }

  Future<bool> checkStatus(String taskId, Map<String, String> headers) async {
    final uri = Uri.http(api, "/sell/feed/v1/inventory_task/$taskId");
    for(int i = 0; i < 3; i++){
      final response = await client.get(uri, headers: headers);
      final json = jsonDecode(response.body);
      if(json["status"] == "COMPLETED"){
        return true;
      }
      await Future.delayed(const Duration(seconds: 3));
    }
    return false;
  }

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

}
