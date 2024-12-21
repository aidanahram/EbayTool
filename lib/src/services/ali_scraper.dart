// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'service.dart';

/// Class to send requests to the aliexpress api
class AliScraper extends Service {
  final api = 'localhost:8080';
  AliScraper();

  /// Function to initialize the scraper
  @override
  Future<void> init() async {}

  /// Function to dispose of the scraper
  @override
  Future<void> dispose() async {}

  Future<Map<String, dynamic>?> generateToken(String code) async {
    const createTokenApi = '/auth/token/create';
    final params = {'code': code, 'method': createTokenApi};

    final uri = Uri.http(api, "/rest$createTokenApi");
    try {
      final response = await http.post(uri, body: jsonEncode(params));
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
      print('There was an error generating aliexpress token');
      print(e);
      return null;
    }
  }

  Future<bool> refreshToken(String refreshToken) async {
    const refreshTokenApi = '/auth/token/refresh';
    final params = {'refresh_token': refreshToken};

    final uri = Uri.http(api, "/rest$refreshTokenApi");
    try {
      final response = await http.post(uri, body: jsonEncode(params));
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      final json = jsonDecode(response.body);
      print(json);
      if (json["refresh_token"] == null) {
        print("missing refresh token");
      }
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
      print(e);
      return false;
    }
    return true;
  }

  /// Get a product from the aliexpress api
  /// [productID] is the id to get found in the url of the product
  Future<String> getProduct(String productID) async {
    const getProductApi = 'aliexpress.ds.product.get';
    final params = {
      'method': getProductApi,
      'product_id': productID,
      'ship_to_country': 'US',
      'target_currency': 'USD',
      'target_language': 'en'
    };

    final uri = Uri.http(api, "/sync");
    try {
      final response = await http.post(uri, body: jsonEncode(params));
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      return response.body;
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
      print(e);
      return "";
    }
  }

  void scrapePage(String endpoint) {
    print('Scraping page $endpoint');
  }
}

// void main() async {
//   final scrape = AliScraper();
//   await scrape.generateToken('3_508156_WnQxbFRHZukqRTcF9kWKW3D51617');
//   await scrape.getProduct('3256802200866156');
// }
