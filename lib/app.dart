/// Defines any global app configuration.
///
/// Usually this page is reserved for theming, navigation, and startup logic.
///
/// This library is the final touch that ties the app together, so it may depend on any other
/// library (except for main.dart).
library app;

import "package:flutter/material.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/widgets.dart";

/// The classic Binghamton green.
const ebayYellow = Color.fromARGB(255, 255, 238, 0);

/// The main class for the app.
class AppDashboard extends ReusableReactiveWidget<AppModel> {
  /// Creates the main app.
  const AppDashboard(super.model);

  @override
  Widget build(BuildContext context, AppModel model) => MaterialApp.router(
        title: "Ebay Drop Shipping Tool",
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        themeMode: ThemeMode.system,
        theme: ThemeData(
          useMaterial3: false,
          colorScheme: const ColorScheme.light(
            primary: ebayYellow,
            secondary: ebayYellow,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: ebayYellow,
            foregroundColor: ebayYellow,
          ),
        ),
        darkTheme: ThemeData.from(
          colorScheme: const ColorScheme.dark(
            primary: ebayYellow,
            secondary: ebayYellow,
          ),
        ),
      );
}