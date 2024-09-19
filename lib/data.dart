// ignore_for_file: directives_ordering

/// The data library.
///
/// This library defines any data types needed by the rest of the app. While the data classes may
/// have methods, the logic within should be simple, and any broad logic that changes state should
/// happen in the models library.
///
/// This library should be the bottom of the dependency graph, meaning that no file included in this
///  library should import any other library.
library data;

export "src/data/listing.dart";
export "src/data/order.dart";
export "src/data/user_profile.dart";
export "src/data/types.dart";
