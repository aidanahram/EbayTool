import "package:flutter/material.dart";

import "package:ebay/widgets.dart";


/// A name and widget in a row, on opposite sides of each other,
class FilterOption extends StatelessWidget {
  /// The name of the option.
  final String name;
  /// The option to show.
  final Widget child;
  /// Creates a filter option widget.
  const FilterOption({super.key, 
    required this.name,
    required this.child,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      const SizedBox(width: 16),
      Text(
        name,
        style: context.textTheme.titleMedium,
      ),
      const Spacer(),
      Expanded(
        flex: 3, 
        child: Align(
          alignment: Alignment.centerRight,
          child: child,
        ),
      ),
      const SizedBox(width: 16),
    ],
  );
}