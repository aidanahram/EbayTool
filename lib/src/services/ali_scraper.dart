// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

/// Class to send requests to the aliexpress api
class AliScraper {
  final api = 'localhost:8080';
  final baseParams = {
    'app_key': '508156',
    'sign_method': 'sha256',
  };
  AliScraper();

  /// Function to generate hash based on [parameters]
  String sign(String secret, String api, Map<String, String> parameters) {
    final sortedByKeyMap = Map.fromEntries(parameters.entries.toList()
      ..sort((e1, e2) => e1.key.compareTo(e2.key)));
    utf8.encode(secret);
    String paramStr = '';
    if (api.contains('/')) {
      paramStr += api;
    }
    sortedByKeyMap.forEach((key, value) {
      paramStr += '$key${sortedByKeyMap[key]}';
    });
    final hmacSha256 = Hmac(sha256, utf8.encode(secret));
    final digest = hmacSha256.convert(utf8.encode(paramStr));
    return digest.toString().toUpperCase();
  }

  Future<bool> generateToken(String code) async {
    print("code: $code");
    const createTokenApi = '/auth/token/create';
    final params = {...baseParams};

    params['code'] = code;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    params['timestamp'] = currentTime.toString();

    //final secrets = await File('C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json').readAsString();
    //final data = await jsonDecode(secrets);
    //final appSecret = data['appSecret'];
    const appSecret = 'Z3AkHoDLoTsK34fu8txgwtnC8vQyMC4j';
    params['sign'] = sign(appSecret, createTokenApi, params);
    final uri = Uri.http(api, "/rest$createTokenApi", params);
    try {
      final response = await http.get(uri);
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      final json = jsonDecode(response.body);
      print(json);
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> refreshToken(String refreshToken) async {
    const refreshTokenApi = '/auth/token/refresh';
    final params = {...baseParams};

    params['refresh_token'] = refreshToken;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    params['timestamp'] = currentTime.toString();

    final secrets = await File('C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json')
        .readAsString();
    final data = await jsonDecode(secrets);
    final appSecret = data['appSecret'];
    params['sign'] = sign(appSecret, refreshTokenApi, params);

    final uri = Uri.http(api, "/rest$refreshTokenApi", params);
    print(uri);
    try {
      final response = await http.get(uri);
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

  Future<String> getProduct(String productID) async {
    const getProductApi = 'aliexpress.ds.product.get';
    final params = {...baseParams};

    params['ship_to_country'] = 'US';
    params['product_id'] = productID;
    params['target_currency'] = 'USD';
    params['target_language'] = 'en';
    params['method'] = getProductApi;

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    params['timestamp'] = currentTime.toString();

    final secrets = await File('C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json')
        .readAsString();
    final data = await jsonDecode(secrets);
    final appSecret = data['appSecret'];
    params['sign'] = sign(appSecret, getProductApi, params);

    final uri = Uri.http(api, "/sync", params);
    print(uri);
    try {
      final response = await http.get(uri);
      print(response.body);
      if (response.statusCode >= 400) {
        print('Recieved error code from server');
        print(response.headers);
        print(response.statusCode);
        print(response.body);
        throw Error();
      }
      final json = jsonDecode(response.body);
      return response.body;
      //print(json);
    } on Exception catch (e) {
      print('THERE WAS AN ERROR AND LOGGING IS TOO DIFFICULT');
      print(e);
      return "";
    }
    return "";
  }

  /// Function to initialize the scraper
  Future<void> init() async {}

  /// Function to dispose of the scraper
  Future<void> dispose() async {}

  void scrapePage(String endpoint) {
    print('Scraping page $endpoint');
  }
}

void main() async {
  final scrape = AliScraper();
  //await scrape.generateToken('3_508156_WnQxbFRHZukqRTcF9kWKW3D51617');
  print("refresh");
  await scrape.refreshToken('50001601001rl13c4a29aapYZ0mxiqpiyse7bBqeqT2FgjtG2fuVnC2mOTwi4LPYEAfB');
  await scrape.getProduct('3256802200866156');
  // const baseUrl = 'https://api-sg.aliexpress.com/rest';
  // const createTokenApi = '/auth/token/create';
  // //final secrets = await File('C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json').readAsString();
  // //final data = await jsonDecode(secrets);
  // //final appSecret = data['appSecret'];
  // const appSecret = 'Z3AkHoDLoTsK34fu8txgwtnC8vQyMC4j';
  // print(appSecret);

  // final currentTime = DateTime.now().millisecondsSinceEpoch;
  // final params = {
  //   'app_key': '508156',
  //   'code': '3_508156_0nKbu8XD6bSyG95ybveg849A471',
  //   'sign_method': 'sha256',
  //   'timestamp': currentTime.toString(),
  // };

  // final key = utf8.encode(appSecret); /// SECRET KEY
  // // const testString = '/auth/token/createapp_key12345678code3_500102_JxZ05Ux3cnnSSUm6dCxYg6Q26sign_methodsha256timestamp1517820392000';
  // final stringToHash = '${createTokenApi}app_key${params['app_key']}code${params['code']}sign_methodsha256timestamp${params['timestamp']}';
  // print(stringToHash);
  // final bytes = utf8.encode(stringToHash);

  // final hmacSha256 = Hmac(sha256, key);
  // final digest = hmacSha256.convert(bytes);

  // print('Digest as hex string: $digest');
  // params['sign'] = digest.toString().toUpperCase();

  // String url = '$baseUrl$createTokenApi?';

  // print(url);
  // print('\n\n\n');
  // final response = await Requests.get(url, queryParameters: params, withCredentials: true);
  // print(response.body);
  // final json = jsonDecode(response.body);
  // print(json.toString());
}
