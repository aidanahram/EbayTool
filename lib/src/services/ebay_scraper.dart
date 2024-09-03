import "dart:convert";
//import "dart:io";

import "package:ebay/data.dart";
import "package:ebay/services.dart";
import "package:ebay/models.dart";
import "package:http/http.dart" as http;
import 'package:xml/xml.dart';
import 'package:archive/archive.dart';

class EbayScraper extends Service {
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

  Future<Map<String, dynamic>?> refreshToken(UserProfile user) async {
    if (!user.ebayTokenValid) {
      print(" Ebay token not valid");
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

  Future<bool> getProducts(UserProfile user) async {
    if (!await verifyToken(user)) return false;
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
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Exception("Recieved error code from server");
      }
      if (response.headers['location'] == null) {
        throw Exception("Response missing location");
      }
      final taskId = response.headers['location']!.split("/").last;
      if (!await checkStatus(
          Uri.http(api, "/sell/feed/v1/inventory_task/$taskId"), {
        "Authorization": "Bearer ${user.ebayAPI!["access_token"]}",
      })) {
        throw Exception("Task not ready after 30 seconds");
      }
      print("task is ready");
      if (!await downloadResultFile(user,
          Uri.http(api, "/sell/feed/v1/task/$taskId/download_result_file"), {
        "Authorization": "Bearer ${user.ebayAPI!["access_token"]}",
      })) {
        print("Unable to download result file");
      }
    } on Exception catch (e) {
      print("THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT");
      print(e);
    }
    return true;
  }

  Future<bool> checkStatus(Uri uri, Map<String, String> headers) async {
    for (int i = 0; i < 5; i++) {
      final response = await client.get(uri, headers: headers);
      final json = jsonDecode(response.body);
      if (json["status"] == "COMPLETED") {
        return true;
      }
      await Future.delayed(const Duration(seconds: 5));
    }
    return false;
  }

  Future<bool> downloadResultFile(
      UserProfile user, Uri uri, Map<String, String> headers) async {
    final response = await client.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final archive = ZipDecoder().decodeBytes(response.bodyBytes);
      // Iterate through the files in the archive
      for (final file in archive) {
        // If it's a file, save it to the specified directory
        if (file.isFile) {
          final document = XmlDocument.parse(
              String.fromCharCodes(file.content as List<int>));
          final skus = document.findAllElements("SKUDetails");
          final List<ItemID> items = [];
          for (final sku in skus) {
            items.add(ItemID(sku.findElements("ItemID").single.innerText));
            final listing = Listing(
              itemID: ItemID(sku.findElements("ItemID").single.innerText),
              owner: user.id,
              quantity:
                  int.parse(sku.findElements("Quantity").single.innerText),
              price: double.parse(sku.findElements("Price").single.innerText),
            );
            await getItemLegacy(user, listing);
          }
          await models.user.updateListings(items);
        }
      }
    } else {
      return false;
    }
    return true;
  }

  Future<bool> getItemLegacy(UserProfile user, Listing listing) async {
    if (!await verifyToken(user)) return false;
    final uri = Uri.http(api, "/buy/browse/v1/item/get_item_by_legacy_id",
        {"legacy_item_id": listing.itemID});
    final Map<String, String> headers = {
      "Authorization": "Bearer ${user.ebayAPI!["access_token"]}",
    };
    try {
      final response = await client.get(uri, headers: headers);
      if (response.statusCode >= 400) {
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Exception(
            "Recieved error code from server: ${response.statusCode}");
      }
      final json = jsonDecode(response.body);
      listing.title = json["title"];
      listing.mainImage = json["image"]["imageUrl"];
      listing.sku = json["sku"];
      await services.database.saveListing(listing);
    } on Exception catch (e) {
      print("Couldn't get information for Item: ${listing.itemID}");
      print(e);
      return false;
    }
    return true;
  }

  Future<Listing> getItemLegacyNoDataBase(UserProfile user, ItemID itemID) async {
    if (!await verifyToken(user)) return Listing(itemID: itemID, price: -1.0, quantity: -1);
    final uri = Uri.http(api, "/buy/browse/v1/item/get_item_by_legacy_id",
        {"legacy_item_id": itemID});
    final Map<String, String> headers = {
      "Authorization": "Bearer ${user.ebayAPI!["access_token"]}",
    };
    try {
      final response = await client.get(uri, headers: headers);
      if (response.statusCode >= 400) {
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Exception(
            "Recieved error code from server: ${response.statusCode}");
      }
      final json = jsonDecode(response.body);
      final listing = Listing(
        itemID: itemID,
        price: double.parse(json["price"]["value"]),
        title: json["title"],
        quantity: json["estimatedAvailabilities"][0]
            ["estimatedAvailableQuantity"],
        mainImage: json["image"]["imageUrl"],
        sku: json["sku"],
      );
      return listing;
    } on Exception catch (e) {
      print("Couldn't get information for Item: $itemID");
      print(e);
      return Listing(itemID: itemID, price: -1.0, quantity: -1);
    }
  }
}

Future<bool> verifyToken(UserProfile user) async {
  if (!user.ebayTokenValid) {
    if (!user.ebayRefreshTokenValid) {
      print("User needs to reauthorize Ebay API");
      return false;
    }
    await models.user.refreshToken();
    user = models.user.userProfile!;
  }
  return true;
}
