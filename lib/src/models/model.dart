import "package:flutter/foundation.dart";

import "package:ebay/data.dart";

/// A data model that handles data from services.
abstract class Model with ChangeNotifier {
  /// Initializes any data needed by this model.
  Future<void> init();
}

/// A model containing data needed throughout the app.
/// 
/// This model may need to be initialized, so [init] should be called before using it. This model
/// should also be held as a singleton in some global scope. [dispose] can be overriden to clean up
/// any resources used by this model.
abstract class DataModel extends Model {
  /// A callback to run when the user signs in.
  Future<void> onSignIn(UserProfile profile);
  /// A callback to run when the user signs out.
  Future<void> onSignOut();
}

/// A model to load and manage state needed by any piece of UI.
/// 
/// [init] is called right away but unlike [DataModel]s, it is *not* awaited. Use [isLoading] and 
/// [errorText] to convey progress to the user. This allows the UI to load immediately.
abstract class ViewModel extends Model {
	/// Calls [init] right away but does not await it.
	ViewModel() { init(); }
}