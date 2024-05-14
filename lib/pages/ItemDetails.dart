import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hypergaragesale/pages/FullScreenImage.dart';
import '../utilis/constants.dart';

class ItemDetails extends StatefulWidget {
  const ItemDetails({
    Key? key,
    required this.item,
  }) : super(key: key);
  final DocumentSnapshot item;

  @override
  State<ItemDetails> createState() => _ItemDetailsState();
}

class _ItemDetailsState extends State<ItemDetails> {
  int imageIndex = 0;
  CarouselController buttonCarouselController = new CarouselController();
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
          title: Text('${widget.item.get('title')}'),
          titleTextStyle: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        body: ListView(
          children: [
            Center(
              child: SizedBox(
                width: 200,
                height: 400,
                child: Column(
                  children: [
                    CarouselSlider(
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                          height: 390,
                          viewportFraction: 1,
                          onPageChanged: (a, b) {
                            imageIndex = a;
                            setState(() {});
                          }),
                      items: List.generate(
                        widget.item.get('pictures').length,
                        (index) => GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => FullScreenImage(image: widget.item.get('pictures')[index])));
                          },
                          child: SizedBox(
                              height: 300,
                              width: 200,
                              child: Image.network(
                                widget.item.get('pictures')[index],
                              )),
                        ),
                      ),
                    ),
                    CarouselIndicator(
                      cornerRadius: 10,
                      activeColor: kPrimeryColor,
                      color: Colors.grey,
                      count: widget.item.get('pictures').length,
                      index: imageIndex,
                    ),
                    SizedBox(
                      height: 2,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(
                    '\$${double.parse('${widget.item.get('price')}').toStringAsFixed(1)}',
                    style: TextStyle(
                      color: kPrimeryColor,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Posted Just Now',
                    style: TextStyle(color: kGreyColor),
                  ),
                ]),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.item.get('title'),
                          style: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.item.get('condition'),
                          style: TextStyle(color: kGreyColor),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(children: [
                      Icon(
                        Icons.location_on_sharp,
                        color: kPrimeryColor,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.item.get('location'),
                        style: TextStyle(
                          color: kSecondaryColor,
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discription:',
                      style: TextStyle(color: kBlackColor, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      widget.item.get('dec'),
                      style: TextStyle(color: kGreyColor),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Contact:',
                      style: TextStyle(color: kBlackColor, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.item.get('contact'),
                      style: TextStyle(color: kGreyColor),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
