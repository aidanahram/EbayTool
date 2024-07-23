// ignore_for_file: avoid_print

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class ServerFunctions {
  final String appSecret;

  static const baseParams = {
    'app_key': '508156',
    'sign_method': 'sha256',
  };

  const ServerFunctions({required this.appSecret});

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
      final body = await serverRequest.readAsString();
      try {
        final params = await jsonDecode(body);
        if(!params.containsKey("method")){
          print("Request is missing method key in body");
          return Response.badRequest(body: "Request is missing method key");
        }
        final Map<String, String> newParams = stringify(params);
        newParams.addAll(baseParams);
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        newParams['timestamp'] = currentTime.toString();
        final api = newParams['method'];
        if(api!.contains('/')){
          newParams.remove('method');
          newParams['sign'] = sign(appSecret, api, newParams);
        } else {
          newParams['sign'] = sign(appSecret, api, newParams);
        }
        final newUri = Uri.parse("$requestUrl${paramQuery(newParams)}");
        print("Sending a get request to:\n$newUri");
        final newRequest = Request('GET', newUri);
        final clientRequest = http.StreamedRequest('GET', newUri)
          ..followRedirects = false
          ..headers.addAll(newRequest.headers)
          ..headers['Host'] = uri.authority;

        _addHeader(clientRequest.headers, 'via',
          '${newRequest.protocolVersion} $proxyName');

        newRequest
          .read()
          .forEach(clientRequest.sink.add)
          .catchError(clientRequest.sink.addError)
          .whenComplete(clientRequest.sink.close)
          .ignore();

        final clientResponse = await nonNullClient.send(clientRequest);
        _addHeader(clientResponse.headers, 'via', '1.1 $proxyName');
        clientResponse.headers.remove('transfer-encoding');

        // If the original response was gzipped, it will be decoded by [client]
        // and we'll have no way of knowing its actual content-length.
        if (clientResponse.headers['content-encoding'] == 'gzip') {
          clientResponse.headers.remove('content-encoding');
          clientResponse.headers.remove('content-length');

          // Add a Warning header. See
          // http://www.w3.org/Protocols/rfc2616/rfc2616-sec13.html#sec13.5.2
          _addHeader(
              clientResponse.headers, 'warning', '214 $proxyName "GZIP decoded"');
        }
        _addHeader(clientResponse.headers, "Access-Control-Allow-Origin", "*");
        return Response(clientResponse.statusCode,
        body: clientResponse.stream, headers: clientResponse.headers);
      } on Exception catch (e) {
        print(e);
        return Response.internalServerError(body: "Problem with server please check logs");
      }
    };
  }

  void _addHeader(Map<String, String> headers, String name, String value) {
    final existing = headers[name];
    headers[name] = existing == null ? value : '$existing, $value';
  }    
}



void main() async {
  final secrets = await File('C:\\Scripts\\Flutter\\Ebay\\ebay\\secrets.json').readAsString();
  final data = await jsonDecode(secrets);
  final appSecret = data['appSecret'];
  final serverFunctions = ServerFunctions(appSecret: appSecret);
 
  print("Shhh the secret is $appSecret");
  final handler = Pipeline()
    .addMiddleware(logRequests())
    .addHandler(serverFunctions.myHandler("https://api-sg.aliexpress.com"));

  // params['sign'] = sign(appSecret, getProductApi, params);
  var server = await shelf_io.serve(handler, 'localhost', 8080);
  print('Proxying at http://${server.address.host}:${server.port}');
}
