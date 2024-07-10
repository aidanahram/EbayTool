import 'dart:convert';
import 'dart:io';

//import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:crypto/crypto.dart';

class AliScraper {
  const AliScraper();

  /// Function to initialize the scraper
  Future<void> init() async{
    
  }

  /// Function to dispose of the scraper
  Future<void> dispose() async{

  }

  void scrapePage(String endpoint){
    print("Scraping page ${endpoint}");
  }
}

void main() async {
  const callbackUrl = "https%3A%2F%2Fwebhook.site%2F492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  const appKey = "508156";
  const baseUrl = "https://api-sg.aliexpress.com";
  const createTokenApi = "/auth/token/create";
  const code = "3_508156_8VbpoXsK6RfiPK3MCSmP2GpZ32376";
  final response = await File("C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json").readAsString();
  final data = await jsonDecode(response);
  final appSecret = data["appSecret"];
  print(appSecret);
  

  // final response = await Requests.post("${env["baseUrl"]}/oauth/authorize?response_type=code&force_auth=true&redirect_uri${env["callbackUrl"]}&client_id=${env["appKey"]}");
  // response.throwForStatus();

  final currentTime = DateTime.now().millisecondsSinceEpoch;
  print(currentTime);

  final key = utf8.encode(appSecret); /// SECRET KEY
  // const testString = "/auth/token/createapp_key12345678code3_500102_JxZ05Ux3cnnSSUm6dCxYg6Q26sign_methodsha256timestamp1517820392000";
  final stringToHash = "${createTokenApi}app_key${appKey}code${code}sign_methodsha256timestamp${currentTime.toString()}";
  print(stringToHash);
  final bytes = utf8.encode(stringToHash);

  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(bytes);

  print("Digest as bytes: ${digest.bytes}");
  print("Digest as hex string: $digest");

  // final bytes = utf8.encode(stringToHash);

  // final digest = sha256.convert(bytes);

  // print("Digest as bytes: ${digest.bytes}");
  // print("Digest as hex string: $digest");

}