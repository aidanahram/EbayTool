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
