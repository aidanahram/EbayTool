/// Contains the high-level UI code that defines each page.
///
/// This library is organized by having a separate file for each page (or complex popup) in
/// the entire app.
///
/// This library may depend on the data, services, models, and widgets libraries.
library pages;

import "package:flutter/material.dart";
import "package:go_router/go_router.dart";

import "package:ebay/data.dart";
import "package:ebay/models.dart";

import "src/pages/home.dart";
import "src/pages/add_item.dart";
import "src/pages/login.dart";

/// The names of all the pages available in the app.
///
/// These names are used to jump from page to page. They are equivalent to a URL.
class Routes {
  /// The name of the home page.
  static const String home = "/home";

  /// The name of the add product page
  static const String addItem = "/addItem";

  /// The name of the login page
  static const String login = "/login";
}

extension on Object? {
  T? safeCast<T>() => this is T ? (this as T) : null;
}

/// Redirects users to the login page if they are not signed in.
String? authRedirect(BuildContext context, GoRouterState state) =>  
  (!models.user.isSignedIn && state.matchedLocation != Routes.login) 
    ? "${Routes.login}?redirect=${state.matchedLocation}" : null;

/// The [GoRouter] that controls the routing logic for the app.
final GoRouter router = GoRouter(
  redirect: authRedirect,
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: "/login",
      builder: (context, state) => LoginPage(redirect: state.uri.queryParameters["redirect"]),
    ),
    GoRoute(
      path: "/home",
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: "/add_item",
      builder: (context, state) => const AddItemPage(),
    ),
  ]
);