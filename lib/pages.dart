/// Contains the high-level UI code that defines each page.
///
/// This library is organized by having a separate file for each page (or complex popup) in
/// the entire app.
///
/// This library may depend on the data, services, models, and widgets libraries.
library pages;

import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

//import "package:ebay/data.dart";
import "package:ebay/models.dart";

import "src/pages/home.dart";
import "src/pages/add_item.dart";
import "src/pages/login.dart";
import "src/pages/settings.dart";
import "src/pages/orders.dart";

/// All the routes in the app.
class Routes {
  /// The products route.
  static const home = "/home";

  /// The route for the login page.
  static const login = "/login";

  /// The route for the add item page
  static const addItem = "/add_item";

  /// The route for the settings page
  static const settings = "/settings";

  /// The route for the orders page
  static const orders = "/orders";

  /// All the routes on the bottom nav bar. Used in [ShellPage].
  static const branches = [home, login];
}

extension on Object? {
  T? safeCast<T>() => this is T ? (this as T) : null;
}

/// Redirects users to the login page if they are not signed in.
String? authRedirect(BuildContext context, GoRouterState state) =>
    (!models.user.isSignedIn && state.matchedLocation != Routes.login)
        ? "${Routes.login}?redirect=${state.matchedLocation}"
        : null;

/// The [GoRouter] that controls the routing logic for the app.
final GoRouter router = GoRouter(
  redirect: authRedirect,
  initialLocation: Routes.home,
  routes: [
    GoRoute(
      path: "/",
      redirect: (_, __) => Routes.home,
    ),
    GoRoute(
      path: Routes.login,
      name: "Login",
      builder: (context, state) =>
          LoginPage(redirect: state.uri.queryParameters["redirect"]),
    ),
    ShellRoute(
        pageBuilder: (context, state, child) => NoTransitionPage(
              child: Title(
                title: state.topRoute?.name ?? "Dropper",
                color: Colors.green,
                child: child,
              ),
            ),
        routes: [
          GoRoute(
            path: Routes.home,
            name: "Home",
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
            routes: [
              GoRoute(
                path: "add_item",
                name: "Add an item",
                builder: (context, state) => const AddItemPage(),
              ),
              GoRoute(
                path: "Settings",
                name: "Settings",
                builder: (context, state) => const SettingsPage(),
              ),
              GoRoute(
                path: "orders",
                name: "Orders",
                builder: (context, state) => const OrdersPage(),
              ),
            ],
          ),
        ]),
    //     // GoRoute(
    //     //   path: Routes.profile,
    //     //   name: "My profile",
    //     //   pageBuilder: (context, state) => const NoTransitionPage(
    //     //     child: UserProfilePage(),
    //     //   ),
    //     //   routes: [
    //     //     GoRoute(
    //     //       path: "edit",
    //     //       name: "Edit profile",
    //     //       builder: (context, state) => LoginPage(
    //     //         redirect: state.extra as String?,
    //     //         showSignUp: true,
    //     //       ),
    //     //     ),
    //     //   ],
    //     // ),
    //   ],
    // ),
  ],
);

// /// The names of all the pages available in the app.
// ///
// /// These names are used to jump from page to page. They are equivalent to a URL.
// class Routes {
//   /// The name of the home page.
//   static const String home = "home";

//   /// The name of the add product page
//   static const String addItem = "addItem";

//   /// The name of the login page
//   static const String login = "login";
// }
