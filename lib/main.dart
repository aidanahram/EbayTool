/// The entrypoint of the app.
///
/// These `library` declarations are not needed, the default name for a Dart library is simply the
/// name of the file. However, DartDoc comments placed above a library declaration will show up on
/// the libraries page in the generated documentation.
///
/// This library's main purpose is to execute the app defined in the app library and is designed to
/// be as simple as possible.
library main;

import "package:flutter/material.dart";
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import "package:ebay/app.dart";
// import "package:ebay/models.dart";
// import "package:ebay/services.dart";

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EbayDashboard());
}
