// ignore_for_file: avoid_print

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'utils.dart';

class EbayServer {
  final String appSecret;
  final String appId;
  late String auth;

  EbayServer({required this.appSecret, required this.appId}){
    auth = base64.encode(utf8.encode("$appId:$appSecret"));
  }

  Map<String, String> stringify(Map<String, dynamic> map){
    final Map<String, String> newMap = {};
    map.forEach((key, value) {
      newMap[key] = value.toString();
    });
    return newMap;
  }

  String paramQuery(Map<String, String> params){
    String result = "?";
    params.forEach((key, value) {
      result += "$key=$value&";
    });
    return result.substring(0, result.length - 1);
  }

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

  Handler myHandler(Object url, {http.Client? client, String? proxyName}) {
    Uri uri;
    if (url is String) {
      uri = Uri.parse(url);
    } else if (url is Uri) {
      uri = url;
    } else {
      throw ArgumentError.value(url, 'url', 'url must be a String or Uri.');
    }
    final nonNullClient = client ?? http.Client();
    proxyName ??= 'shelf_proxy';

    return (serverRequest) async {
      // http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.8
      final requestUrl = uri.resolve(serverRequest.url.toString());
      print(requestUrl);
      //final body = await serverRequest.readAsString();
      //print(body);
      print(serverRequest.headers);
      final headers = serverRequest.headers;
      try {
        if(serverRequest.headers['authorization'] == 'true'){
          print("need to add auth");
          serverRequest = serverRequest.change(headers: {'authorization': 'Basic $auth'});
          print("NEW HEADERS: ");
          print(serverRequest.headers);
        }
        print("Sending a post request to:\n$requestUrl");
        
        final clientRequest = http.StreamedRequest('POST', requestUrl)
          ..followRedirects = false
          ..headers.addAll(serverRequest.headers)
          ..headers['Host'] = uri.authority;

        addHeader(clientRequest.headers, 'via',
          '${serverRequest.protocolVersion} $proxyName');

        serverRequest
          .read()
          .forEach(clientRequest.sink.add)
          .catchError(clientRequest.sink.addError)
          .whenComplete(clientRequest.sink.close)
          .ignore();

        final clientResponse = await nonNullClient.send(clientRequest);
        addHeader(clientResponse.headers, 'via', '1.1 $proxyName');
        clientResponse.headers.remove('transfer-encoding');

        // If the original response was gzipped, it will be decoded by [client]
        // and we'll have no way of knowing its actual content-length.
        if (clientResponse.headers['content-encoding'] == 'gzip') {
          clientResponse.headers.remove('content-encoding');
          clientResponse.headers.remove('content-length');

          // Add a Warning header. See
          // http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.5.2
          addHeader(
              clientResponse.headers, 'warning', '214 $proxyName "GZIP decoded"');
        }
        addHeader(clientResponse.headers, "Access-Control-Allow-Origin", "*");
        return Response(clientResponse.statusCode,
        body: clientResponse.stream, headers: clientResponse.headers);
      } on Exception catch (e) {
        print(e);
        return Response.internalServerError(body: "Problem with server please check logs");
      }
    };
  }
}



void main() async {
  final secrets = await File('C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.env').readAsString();
  final data = await jsonDecode(secrets);
  final appSecret = data['ebayAppSecret'];
  final appKey = data['ebayAppId'];
  final serverFunctions = EbayServer(appSecret: appSecret, appId: appKey);
 
  print("Shhh the secret is $appSecret");
  final handler = const Pipeline()
    .addMiddleware(logRequests())
    .addHandler(serverFunctions.myHandler("https://api.ebay.com"));

  // params['sign'] = sign(appSecret, getProductApi, params);
  var server = await shelf_io.serve(handler, 'localhost', 8081);
  print('Proxying at http://${server.address.host}:${server.port}');
}
