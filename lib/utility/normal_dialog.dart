import 'dart:ui';

import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      title: Text(message),
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.red),
                )),
          ],
        )
      ],
    ),
  );
}
