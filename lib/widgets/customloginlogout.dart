import 'package:flutter/material.dart';
import 'package:hypergaragesale/utilis/constants.dart';

class CustomLoginLogOut extends StatelessWidget {
  const CustomLoginLogOut({
    required this.buttonTxt,
    required this.msg,
    required this.onPress,
    super.key,
  });
  final String msg;
  final String buttonTxt;
  final VoidCallback onPress;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$msg', style: TextStyle(color: kGreyColor)),
        TextButton(
          onPressed: onPress,
          child: Text('$buttonTxt', style: TextStyle(color: kPrimeryColor)),
        ),
      ],
    );
  }
}
