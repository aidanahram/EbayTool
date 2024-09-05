import "package:ebay/data.dart";
import "package:ebay/models.dart";
// import "package:ebay/pages.dart";
// import "package:ebay/services.dart";
// import "package:ebay/src/data/user_profile.dart";
// import "package:flutter/material.dart";

/// A view model to show the home page.
class HomeViewModel extends ViewModel {
  /// Whether the model is loading
  bool isLoading = false;
  /// List of [Listing] to be displayed in the UI
  List<Listing> listings = [];

  String query = "";

  List<Listing> get filteredListing =>
    listings.where(filter).toList();

  bool filter(Listing l) => l.title!.toLowerCase().contains(query);

  HomeViewModel();

  @override
  Future<void> init() async {
    isLoading = true;
    await refreshListings();
    notifyListeners();
    isLoading = false;
  }

  Future<void> refreshListings() async {
    listings = await models.user.getListingsInformation();
  }

  void search(String input){
    query = input.toLowerCase();
    notifyListeners();
  }
}