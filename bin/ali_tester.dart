// ignore_for_file: avoid_print

import "dart:io";
import 'dart:convert';

//import 'package:flutter/services.dart';
import 'package:requests/requests.dart';
import 'package:crypto/crypto.dart';

main() async {
  //const callbackUrl = "https%3A%2F%2Fwebhook.site%2F492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  const baseUrl = "https://api-sg.aliexpress.com";
  const createTokenApi = "/auth/token/create";
  final json = await File("C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json").readAsString();
  
  const currentTime = "1517820392000";
  //DateTime.now().millisecondsSinceEpoch;
  final params = {
    "app_key": "12345678",
    "code": "3_500102_JxZ05Ux3cnnSSUm6dCxYg6Q26",
    "sign_method": "sha256",
    "timestamp": "1517820392000",
  };

  final data = await jsonDecode(json);
  final appSecret = data["appSecret"];
  print(appSecret);
  var key = utf8.encode(appSecret); /// SECRET KEY
  //const testString = "/auth/token/createapp_key12345678code3_500102_JxZ05Ux3cnnSSUm6dCxYg6Q26sign_methodsha256timestamp1517820392000";
  final testString = "${createTokenApi}app_key${params["app_key"]}code${params["code"]}sign_methodsha256timestamp${currentTime.toString()}";
  print(testString);
  final bytes = utf8.encode(testString);

  key = utf8.encode("helloworld");
  final hmacSha256 = Hmac(sha256, key);
  final digest = hmacSha256.convert(bytes);

  print("Digest as bytes: ${digest.bytes}");
  print("Digest as hex string: $digest");
  params["sign"] = digest.toString().toUpperCase();

  String url = "$baseUrl$createTokenApi?";
  
  print(url);
  final response = await Requests.get(url, queryParameters: params);
  print(response.body);
  print(response.url);

  // final bytes = utf8.encode(stringToHash);

  // final digest = sha256.convert(bytes);


  /// New ATTEMPT

}