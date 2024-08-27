import "dart:convert";
//import "dart:io";

import "package:ebay/data.dart";
import "package:ebay/services.dart";
import "package:ebay/src/services/service.dart";
import "package:ebay/models.dart";
import "package:http/http.dart" as http;
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';


class EbayScraper extends Service{
  /// Url of the backend proxy server
  final api = "localhost:8081";

  /// [http.Client] to send requests from
  late final http.Client client;

  EbayScraper();

  /// Function to initialize the scraper
  @override
  Future<void> init() async {
    client = http.Client();
  }

  /// Function to dispose of the scraper
  @override
  Future<void> dispose() async {
    client.close();
  }

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
      print(" Ebay token notvalid");
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
      final taskId = response.headers['location']!.split("/").last;
      if(!await checkStatus(Uri.http(api, "/sell/feed/v1/inventory_task/$taskId"), {"Authorization": "Bearer ${user.ebayAPI!["access_token"]}",})){
        print("Task not ready after 30 seconds");
        throw Error();
      }
      print("task is ready");
      if(!await downloadResultFile(user, Uri.http(api, "/sell/feed/v1/task/$taskId/download_result_file"), {"Authorization": "Bearer ${user.ebayAPI!["access_token"]}",})){
        print("Unable to download result file");
      }

    } on Exception catch (e) {
      print("THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT");
      print(e);
    }
  }

  Future<bool> checkStatus(Uri uri, Map<String, String> headers) async {
    for(int i = 0; i < 5; i++){
      final response = await client.get(uri, headers: headers);
      final json = jsonDecode(response.body);
      if(json["status"] == "COMPLETED"){
        return true;
      }
      await Future.delayed(const Duration(seconds: 5));
    }
    return false;
  }

  Future<bool> downloadResultFile(UserProfile user, Uri uri, Map<String, String> headers) async {
    final response = await client.get(uri, headers: headers);
    if(response.statusCode == 200){
      final archive = ZipDecoder().decodeBytes(response.bodyBytes);
      // Iterate through the files in the archive
      print(archive.files);
      for (final file in archive) {
        // If it's a file, save it to the specified directory
        if (file.isFile) {
          print(String.fromCharCodes(file.content as List<int>));
          final document = XmlDocument.parse(String.fromCharCodes(file.content as List<int>));
          final SKUs = document.findAllElements("SKUDetails");
          final List<ItemID> items = [];
          for(final sku in SKUs){
            print("SKU: $sku");
            print("Item ID: ${sku.findElements("ItemID").single.innerText}");
            items.add(ItemID(sku.findElements("ItemID").single.innerText));
            final listing = Listing(
              itemID: ItemID(sku.findElements("ItemID").single.innerText),
              owner: user.id,
              quantity: int.parse(sku.findElements("Quantity").single.innerText),
              price: double.parse(sku.findElements("Price").single.innerText),
              aliExpressLink: "",
            );
            try{
              await services.database.saveListing(listing);
            } on Error{
              print("lisintg had an error");
              print(listing);
            }
          }
          await models.user.updateListings(items);
        }
      }
    } else {
      return false;
    }
    return true;
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
