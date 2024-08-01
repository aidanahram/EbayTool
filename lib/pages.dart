/// Contains the high-level UI code that defines each page.
///
/// This library is organized by having a separate file for each page (or complex popup) in
/// the entire app.
///
/// This library may depend on the data, services, models, and widgets libraries.
library pages;

export "src/pages/home.dart";
export "src/pages/add_item.dart";

/// The names of all the pages available in the app.
///
/// These names are used to jump from page to page. They are equivalent to a URL.
class Routes {
  /// The name of the home page.
  static const String home = "home";

  /// The name of the add product page
  static const String addItem = "addItem";

  /// The name of the login page
  static const String login = "login";
}
