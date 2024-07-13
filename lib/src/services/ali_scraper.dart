// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

//import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:crypto/crypto.dart';

class AliScraper {
  final api = "https://api-sg.aliexpress.com/rest";
  const AliScraper();

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
  const callbackUrl = "https%3A%2F%2Fwebhook.site%2F492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  const baseUrl = "https://api-sg.aliexpress.com/rest";
  const createTokenApi = "/auth/token/create";
  final secrets = await File("C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json").readAsString();
  final data = await jsonDecode(secrets);
  final appSecret = data["appSecret"];
  print(appSecret);
  
  final currentTime = DateTime.now().millisecondsSinceEpoch;
  final params = {
    "app_key": "508156",
    "code": "3_508156_kRZ1x2UdXo7697q67eWOoyvo436",
    "sign_method": "sha256",
    "timestamp": currentTime.toString(),
  };

  final key = utf8.encode(appSecret); /// SECRET KEY
  // const testString = "/auth/token/createapp_key12345678code3_500102_JxZ05Ux3cnnSSUm6dCxYg6Q26sign_methodsha256timestamp1517820392000";
  final stringToHash = "${createTokenApi}app_key${params["app_key"]}code${params["code"]}sign_methodsha256timestamp${params["timestamp"]}";
  print(stringToHash);
  final bytes = utf8.encode(stringToHash);

  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(bytes);

  print("Digest as hex string: $digest");
  params["sign"] = digest.toString().toUpperCase();

  String url = "$baseUrl$createTokenApi?";

  print(url);
  print("\n\n\n");
  final response = await Requests.get(url, queryParameters: params, withCredentials: true);
  print(response.body);
  final json = jsonDecode(response.body);
  print(json.toString());
  print(DateTime.fromMicrosecondsSinceEpoch(1723490893000).toLocal());
}