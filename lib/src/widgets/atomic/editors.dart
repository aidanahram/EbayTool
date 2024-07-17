import "package:flutter/material.dart";

import "package:ebay/models.dart";
import "package:ebay/services.dart";
import "package:ebay/widgets.dart";

/// A widget to edit a color, backed by [APIBuilder].
class APIEditor extends ReactiveWidget<APIBuilder> {
  @override
  APIBuilder createModel() => APIBuilder();

  @override
  Widget build(BuildContext context, APIBuilder model) => AlertDialog(
        title: const Text("Authenticate AliExpress API"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 50,
              width: double.infinity,
              child: TextField(
                controller: model.code,
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
