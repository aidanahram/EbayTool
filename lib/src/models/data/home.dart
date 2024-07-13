import "dart:async";

import "package:ebay/data.dart";
import "package:ebay/models.dart";
import "package:ebay/services.dart";

/// The view model for the main page. 
class HomeModel extends Model {
	/// The dashboard's version from the `pubspec.yaml`. 
	String? version;

  String? code;

	@override
	Future<void> init() async { 
    models.settings.addListener(notifyListeners);
	}

  @override
  void dispose() {
    models.settings.removeListener(notifyListeners);
    super.dispose();
  }
}