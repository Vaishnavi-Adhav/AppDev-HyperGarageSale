import 'package:flutter/material.dart';
import 'package:hypergaragesale/utilis/constants.dart';

class FullScreenImage extends StatelessWidget {
  const FullScreenImage({
    Key? key,
    required this.image,
  }) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back,
              color: kBlackColor,
            )),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Image.network(image, fit: BoxFit.fill),
      ),
    );
  }
}
