import "package:flutter/material.dart";

import "package:ebay/models.dart";
// import "package:ebay/services.dart";
import "package:ebay/widgets.dart";

/// A widget to edit a color, backed by [APIBuilder].
class APIEditor extends ReactiveWidget<APIBuilder> {
  final String website;
  const APIEditor({super.key, required this.website});

  @override
  APIBuilder createModel() => APIBuilder(website: website);

  @override
  Widget build(BuildContext context, APIBuilder model) => AlertDialog(
        title: Text("Authenticate $website API"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextField(
                controller: model.url,
                onChanged: model.update,
                decoration: const InputDecoration(hintText: "Code From Url"),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop()),
          ElevatedButton(
            onPressed: model.isValid
                ? () {
                    model.save();
                    Navigator.of(context).pop();
                  }
                : null,
            child: const Text("Save"),
          ),
        ],
      );
}
