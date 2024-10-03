import "package:ebay/data.dart";
import "package:ebay/models.dart";

/// A view model to show the home page.
class HomeViewModel extends ViewModel {
  /// Whether the model is loading
  bool isLoading = false;
  /// List of [Listing] to be displayed in the UI
  List<Listing> listings = [];

  String query = "";

  List<Listing> get filteredListing =>
    listings.where(filter).toList();

  bool filter(Listing l) => l.title!.toLowerCase().contains(query) || l.itemID.id.contains(query);

  HomeViewModel();

  @override
  Future<void> init() async {
    isLoading = true;
    if(models.user.isSignedIn){
      listings = await models.user.getListingsInformationFromDatabase();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshListings() async {
    isLoading = true;
    notifyListeners();
    if(! await models.user.refreshListingsInformation()){
      print("cant refresh listing");
    }
    listings = await models.user.getListingsInformationFromDatabase();
    isLoading = false;
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  void search(String input){
    query = input.toLowerCase();
    notifyListeners();
  }
}