// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

//import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:crypto/crypto.dart';

class AliScraper {
  final api = "https://api-sg.aliexpress.com/rest";
  const AliScraper();

  Future<bool> authenticate(String code) async {
    const createTokenApi = "/auth/token/create";
    print("where is my problem1?");
    //final secrets = await File("C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json").readAsString();
    //final data = await jsonDecode(secrets);
    //final appSecret = data["appSecret"];
    const appSecret = "Z3AkHoDLoTsK34fu8txgwtnC8vQyMC4j";
    print("where is my problem2? $appSecret");

    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final params = {
      "app_key": "508156",
      "code": code,
      "sign_method": "sha256",
      "timestamp": currentTime.toString(),
    };

    final key = utf8.encode(appSecret); /// SECRET KEY
    final stringToHash = "${createTokenApi}app_key${params["app_key"]}code${params["code"]}sign_methodsha256timestamp${params["timestamp"]}";

    final bytes = utf8.encode(stringToHash);

    final hmacSha256 = Hmac(sha256, key);
    final digest = hmacSha256.convert(bytes);

    params["sign"] = digest.toString().toUpperCase();

    String url = "$api$createTokenApi?";

    print("before response");
    final response = await Requests.get(url, queryParameters: params, withCredentials: true);
    try {
      print(response.body);
      //final json = jsonDecode(response.body);
      //print(json.toString());
    } on Exception catch (e) {

      print(e);
    }
    return true;
  }

  /// Function to initialize the scraper
  Future<void> init() async{
    
  }

  /// Function to dispose of the scraper
  Future<void> dispose() async{

  }

  void scrapePage(String endpoint){
    print("Scraping page $endpoint");
  }
}

void main() async {
  const scrape = AliScraper();
  scrape.authenticate("3_508156_44yZLeLa3lae4UAmOQ8VulD5457");


  // const baseUrl = "https://api-sg.aliexpress.com/rest";
  // const createTokenApi = "/auth/token/create";
  // //final secrets = await File("C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json").readAsString();
  // //final data = await jsonDecode(secrets);
  // //final appSecret = data["appSecret"];
  // const appSecret = "Z3AkHoDLoTsK34fu8txgwtnC8vQyMC4j";
  // print(appSecret);
  
  // final currentTime = DateTime.now().millisecondsSinceEpoch;
  // final params = {
  //   "app_key": "508156",
  //   "code": "3_508156_0nKbu8XD6bSyG95ybveg849A471",
  //   "sign_method": "sha256",
  //   "timestamp": currentTime.toString(),
  // };

  // final key = utf8.encode(appSecret); /// SECRET KEY
  // // const testString = "/auth/token/createapp_key12345678code3_500102_JxZ05Ux3cnnSSUm6dCxYg6Q26sign_methodsha256timestamp1517820392000";
  // final stringToHash = "${createTokenApi}app_key${params["app_key"]}code${params["code"]}sign_methodsha256timestamp${params["timestamp"]}";
  // print(stringToHash);
  // final bytes = utf8.encode(stringToHash);

  // final hmacSha256 = Hmac(sha256, key);
  // final digest = hmacSha256.convert(bytes);

  // print("Digest as hex string: $digest");
  // params["sign"] = digest.toString().toUpperCase();

  // String url = "$baseUrl$createTokenApi?";

  // print(url);
  // print("\n\n\n");
  // final response = await Requests.get(url, queryParameters: params, withCredentials: true);
  // print(response.body);
  // final json = jsonDecode(response.body);
  // print(json.toString());
}