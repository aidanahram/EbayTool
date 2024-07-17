import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_proxy/shelf_proxy.dart';

Future<void> p() async {
  return;
}

Future<void> Function() _echoRequest() {
  return p;
}

Response addCors(Response response) {
  final Map<String, String> newHeaders = {};
  newHeaders["Access-Control-Allow-Origin"] = "*";
  print("recieved message with code ${response.statusCode}");
  return response.change(headers: newHeaders);
}

final corsHandler = createMiddleware(responseHandler: addCors);
var handler = const Pipeline()
    .addMiddleware(corsHandler)
    .addHandler(proxyHandler("https://api-sg.aliexpress.com"));

void main() async {
  var server = await shelf_io.serve(handler, 'localhost', 8080);
}
