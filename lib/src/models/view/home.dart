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

  HomeViewModel();

  @override
  Future<void> init() async {
    isLoading = true;
    await refreshListings();
    isLoading = false;
  }

  Future<void> refreshListings() async {
    listings = await models.user.getListingsInformation();
  }
}