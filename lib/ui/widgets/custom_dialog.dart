import 'package:flutter/material.dart';
import 'package:restaurant_app/common/theme/theme.dart';

Future<dynamic> showComingsoonFeature(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Coming Soon!', style: logoTextStyle),
        content: Text(
          'This feature will be coming soon!',
          style: greyTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Ok', style: yellowTextStyle),
          ),
        ],
      );
    },
  );
}
