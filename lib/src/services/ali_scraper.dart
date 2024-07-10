import 'package:requests/requests.dart';

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
  final env = {
    "callbackUrl": "https%3A%2F%2Fwebhook.site%2F492b6fc0-eb70-4d3e-bfb4-a9c23409f82e",
    "appKey": "508156",
    "baseUrl": "https://api-sg.aliexpress.com",
  };

  final response = await Requests.post("${env["baseUrl"]}/oauth/authorize?response_type=code&force_auth=true&redirect_uri${env["callbackUrl"]}&client_id=${env["appKey"]}");
  response.throwForStatus();


}