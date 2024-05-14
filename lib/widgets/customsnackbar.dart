import 'package:flutter/material.dart';
import 'package:hypergaragesale/utilis/constants.dart';

void showSnackBar(BuildContext context, String text, [String buttonText = '']) {
  final snackBar = SnackBar(
    content: Text(text),
    backgroundColor: kSecondaryColor,
    behavior: SnackBarBehavior.floating,
    action: SnackBarAction(
      label: buttonText,
      disabledTextColor: Colors.white,
      textColor: Colors.yellow,
      onPressed: () {

      },
    ),
    onVisible: () {

    },
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
