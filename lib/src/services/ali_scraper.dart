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

void main() async{
  const callbackUrl = "https%3A%2F%2Fwebhook.site%2F492b6fc0-eb70-4d3e-bfb4-a9c23409f82e";
  const appKey = "508156";
  const baseUrl = "https://api-sg.aliexpress.com";
  const createTokenApi = "/auth/token/create";
  const code = "";
  

  // final response = await Requests.post("${env["baseUrl"]}/oauth/authorize?response_type=code&force_auth=true&redirect_uri${env["callbackUrl"]}&client_id=${env["appKey"]}");
  // response.throwForStatus();

  final currentTime = DateTime.now().millisecondsSinceEpoch;
  print(currentTime);

  final stringToHash = "${createTokenApi}app_key${appKey}code${code}sign_methodsha256timestamp${currentTime.toString()}";
  print(stringToHash);



}