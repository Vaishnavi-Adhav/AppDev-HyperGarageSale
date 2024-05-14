import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hypergaragesale/utilis/constants.dart';
import 'package:hypergaragesale/widgets/custombutton.dart';
import 'package:hypergaragesale/widgets/customtextfield.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hypergaragesale/widgets/customsnackbar.dart';

class NewPostActivity extends StatefulWidget {
  const NewPostActivity({Key? key}) : super(key: key);

  @override
  State<NewPostActivity> createState() => _NewPostActivityState();
}

class _NewPostActivityState extends State<NewPostActivity> {
  TextEditingController itemTitle = TextEditingController();
  TextEditingController itemDescription = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController customLocationController = TextEditingController();
  PickedFile? itemPicturePicket;
  String currentAddress = '';
  List<String> picturesLocation = [];
  List<String> pictureLocationUrl = [];
  double itemPrice = 0.0;
  List<String> dropDownListItem = ['Like New', 'New', 'Old', 'Very Old'];
  int _selectedDropDown = 0;
  RegExp numericRegex = RegExp(r'^-?[0-9]+$');
  Reference storageRef = FirebaseStorage.instance.ref();
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          backgroundColor: kSecondaryColor,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back, color: kBlackColor)),
          title: Text('Add New Item'),
          titleTextStyle: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.bold)),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
        child: ListView(
          children: [
            /// Item Title
            CustomTextFieldItem(controller: itemTitle, hint: 'item'),
            SizedBox(height: height * 0.03),

            /// Item Condition DropDown
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Condition', style: TextStyle(color: kGreyColor)),
                DropdownButton(
                    items: List.generate(
                        dropDownListItem.length,
                        (index) => DropdownMenuItem(
                            child: Text(
                              dropDownListItem[index],
                              style: TextStyle(color: kPrimeryColor),
                            ),
                            value: index)),
                    value: _selectedDropDown,
                    onChanged: (a) {
                      _selectedDropDown = a ?? 0;
                      setState(() {});
                    })
              ],
            ),
            SizedBox(height: height * 0.03),

            /// Item Description Field
            CustomDescriptionTextField(itemDescription: itemDescription),
            SizedBox(height: height * 0.03),

            /// Item Estimated Value
            Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: kPrimeryColor)),
                      child: Icon(Icons.attach_money_rounded, color: kPrimeryColor),
                    ),
                    SizedBox(width: 10),
                    Text('Estimated Value')
                  ],
                ),
                SizedBox(height: height * 0.02),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text('\$${(itemPrice * 500).toStringAsFixed(2)}')],
                    ),

                    /// Item Estimated value Slider
                    Slider(
                      value: itemPrice,
                      onChanged: (a) {
                        itemPrice = a;
                        setState(() {});
                      },
                      thumbColor: kSecondaryColor,
                      inactiveColor: kSecondaryColor.withOpacity(0.3),
                      overlayColor: MaterialStateProperty.all(kPrimeryColor),
                      activeColor: kSecondaryColor,
                    ),
                  ],
                ),
                SizedBox(height: height * 0.03),
              ],
            ),

            /// Add Pictures of Item
            Column(
              children: [
                Row(children: [Icon(Icons.camera_enhance_outlined, color: kPrimeryColor), SizedBox(width: 5), Text('Picture')]),
                SizedBox(height: height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      4,
                      (index) => GestureDetector(
                            onTap: () async {
                              if (picturesLocation.length < index + 1) {
                                await _settingModalBottomSheet(context);
                                if (itemPicturePicket?.path != null) {
                                  picturesLocation.add(itemPicturePicket?.path.toString() ?? '');
                                  itemPicturePicket = null;
                                  setState(() {});
                                }
                              } else {
                                picturesLocation.removeAt(index);
                                setState(() {});
                              }
                            },
                            child: picturesLocation.length < index + 1
                                ? Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    color: kGreyColor.withOpacity(0.3),
                                    width: 60,
                                    height: 80,
                                    child: Center(
                                      child: Icon(Icons.add, color: kPrimeryColor),
                                    ),
                                  )
                                : Container(
                                    margin: EdgeInsets.symmetric(horizontal: 5),
                                    width: 60,
                                    height: 80,
                                    child: Image.file(File(picturesLocation[index])),
                                  ),
                          )),
                ),
              ],
            ),
            SizedBox(height: height * 0.03),

            /// Contact info
            Column(children: [
              Row(children: const [Text('Contact Info', style: TextStyle(color: kGreyColor))]),
              CustomTextFieldItem(controller: contactController, hint: ''),
            ]),
            SizedBox(height: height * 0.03),

            /// Get Location
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          //  decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), border: Border.all(color: kPrimeryColor)),
                          child: Icon(Icons.my_location, color: kPrimeryColor),
                        ),
                        SizedBox(width: 10),
                        Text('Loaction :'),
                      ],
                    ),
                    currentAddress != ''
                        ? IconButton(
                            onPressed: () async {
                              await _determinePosition();
                            },
                            icon: Icon(
                              Icons.refresh,
                              color: kPrimeryColor,
                            ))
                        : CustomButton(
                            width: width * 0.6,
                            text: 'Get Current Location',
                            onPress: () async {
                              showSnackBar(context, 'Please Wait Loading Location...');
                              await _determinePosition();
                            },
                            height: 30,
                            txtFontSize: 14,
                            btnColor: kSecondaryColor,
                          ),
                  ],
                ),
                SizedBox(
                  width: 3,
                ),
                CustomTextFieldItem(controller: customLocationController, hint: 'Enter location')
              ],
            ),
            SizedBox(height: height * 0.03),

            /// Save product
            CustomButton(
              width: width,
              text: 'Save',
              onPress: () {
                if (itemTitle.text.trim() != '' &&
                    itemDescription.text.trim() != '' &&
                    itemPrice != 0.0 &&
                    picturesLocation.length > 0 &&
                    contactController.text.trim() != '' &&
                    customLocationController.text.trim() != '') {
                  if (contactController.text.trim().length == 10) {
                    if (numericRegex.hasMatch(contactController.text.trim())) {
                      try {
                        showSnackBar(context, 'Please Wait Uploading the Item...');
                        uploadPic().then((value) {
                          FirebaseFirestore.instance.collection('items').doc().set({
                            'title': itemTitle.text,
                            'condition': dropDownListItem[_selectedDropDown],
                            'dec': itemDescription.text,
                            'price': (itemPrice * 500).toStringAsFixed(2),
                            'pictures': pictureLocationUrl,
                            'contact': contactController.text,
                            'location': customLocationController.text.trim(),
                            'datetime': DateTime.now(),
                          }).then((value) {
                            showSnackBar(context, '${itemTitle.text} Added');
                            Navigator.pop(context);
                          });
                        });
                      } catch (e) {
                        showSnackBar(context, '${e.toString()}');
                      }
                    } else {
                      showSnackBar(context, 'Only Digits are allowed in Contacts');
                    }
                  } else {
                    showSnackBar(context, 'Please Enter 10 Digit number');
                  }
                } else {
                  showSnackBar(context, 'Please Enter ALL the details');
                }
              },
              btnColor: kSecondaryColor,
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    ));
  }

  _settingModalBottomSheet(context) async {
    await showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icons.photo_size_select_actual),
                  title: new Text('Photo Library'),
                  onTap: () async {
                    itemPicturePicket = (await ImagePicker.platform.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 10,
                      maxHeight: 600,
                      maxWidth: 400,
                    ));
                    Navigator.pop(context);
                  },
                ),
                new ListTile(
                  leading: new Icon(Icons.camera_enhance),
                  title: new Text('Camera'),
                  onTap: () async {
                    itemPicturePicket = (await ImagePicker.platform.pickImage(
                      source: ImageSource.camera,
                      imageQuality: 10,
                      maxHeight: 600,
                      maxWidth: 400,
                    ));
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    final currentLocation = await Geolocator.getCurrentPosition();
    List<Placemark> addresses = await placemarkFromCoordinates(currentLocation.latitude, currentLocation.longitude);

    Placemark first = addresses.first;
    //print("${first.name} : ${first..administrativeArea}");
    currentAddress = '${first.name},${first.street},${first.administrativeArea},${first.country}';
    if (currentAddress != '') {
      customLocationController.text = currentAddress;
      setState(() {});
    }
  }

  Future<List<String>> uploadPic() async {
    for (int i = 0; i < picturesLocation.length; i++) {
      //Create a reference to the location you want to upload to in firebase
      final itemImageRef = storageRef.child("items/images/${itemTitle.text.trim()}_${i}_${DateTime.now()}");

      //Upload the file to firebase
      final TaskSnapshot snapshot = await itemImageRef.putFile(File(picturesLocation[i]));

      // Waits till the file is uploaded then stores the download url
      String url = await snapshot.ref.getDownloadURL();
      pictureLocationUrl.add(url);
    }

    return pictureLocationUrl;
  }
}

class CustomDescriptionTextField extends StatelessWidget {
  const CustomDescriptionTextField({
    super.key,
    required this.itemDescription,
  });

  final TextEditingController itemDescription;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: itemDescription,
      decoration: InputDecoration(
        hintText: 'Description',
        hintStyle: TextStyle(color: kGreyColor),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimeryColor, width: 2),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: kGreyColor, width: 2),
        ),
      ),
      maxLines: 5,
    );
  }
}

class CustomTextFieldItem extends StatelessWidget {
  const CustomTextFieldItem({
    super.key,
    required this.controller,
    required this.hint,
  });
  final TextEditingController controller;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,

      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: kGreyColor),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kPrimeryColor, width: 2),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: kGreyColor, width: 2),
        ),
      ),
    );
  }
}
