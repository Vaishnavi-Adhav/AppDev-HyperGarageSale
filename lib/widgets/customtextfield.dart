import 'package:flutter/material.dart';

import '../utilis/constants.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.width,
    required this.controller,
    required this.icon,
    required this.hint,
  });

  final double width;
  final TextEditingController controller;
  final IconData icon;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: kPrimeryColor,
        ),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: width * 0.8,
          child: TextField(
            controller: controller,
            obscureText: hint == 'Password' ? true : false,
            decoration: InputDecoration(hintText: hint, focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: kPrimeryColor, width: 2))),
          ),
        ),
      ],
    );
  }
}
