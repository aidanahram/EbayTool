/// Defines any global app configuration.
///
/// Usually this page is reserved for theming, navigation, and startup logic.
///
/// This library is the final touch that ties the app together, so it may depend on any other
/// library (except for main.dart).
library app;

import "package:flutter/material.dart";
import "package:ebay/models.dart";
import "package:ebay/pages.dart";
import "package:ebay/widgets.dart";

/// The classic Binghamton green.
const ebayYellow = Color.fromARGB(255, 255, 238, 0);

/// The main class for the app.
class EbayDashboard extends ReusableReactiveWidget<SettingsModel> {
  /// Creates the main app.
  EbayDashboard() : super(models.settings);

  @override
  Widget build(BuildContext context, SettingsModel model) => MaterialApp(
        title: "Ebay Drop Shipping Tool",
        home: const HomePage(),
        debugShowCheckedModeBanner: false,
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
        routes: {
          Routes.home: (_) => const HomePage(),
          Routes.addItem: (_) => const AddItemPage(),
        },
      );
}
