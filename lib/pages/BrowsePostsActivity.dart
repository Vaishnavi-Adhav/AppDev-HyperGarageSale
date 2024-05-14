import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hypergaragesale/pages/ItemDetails.dart';
import 'package:hypergaragesale/utilis/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../widgets/customsnackbar.dart';

class BrowsePostsActivity extends StatelessWidget {
  const BrowsePostsActivity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kSecondaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'Shopping Here',
                  style: TextStyle(color: kBlackColor, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  showSnackBar(context, 'Logout Successful');
                  Navigator.pushReplacementNamed(context, 'login');
                },
                icon: Icon(
                  Icons.logout,
                )),
          ],
        ),
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.menu,
              color: kBlackColor,
            )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, 'newpostactivity');
        },
        backgroundColor: kSecondaryColor,
        child: Icon(Icons.add, color: kBlackColor),
      ),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('items').orderBy('datetime').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(
                  color: kPrimeryColor,
                );
              } else if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text(
                      'Record not found',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                  );
                } else {

                  return SingleChildScrollView(
                    child: Wrap(
                      children: List.generate(snapshot.data!.docs.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemDetails(item: snapshot.data!.docs[index])));
                          },
                          child: Card(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: Image.network(snapshot.data?.docs[index].get('pictures')[0]),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 3,
                                          ),
                                          Text(
                                            '${snapshot.data?.docs[index].get('title')}',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    '\$${double.parse('${snapshot.data?.docs[index].get('price')}').toStringAsFixed(1)}',
                                    style: TextStyle(color: kPrimeryColor),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }
              } else {
                return Text(
                  'Record not found',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w600),
                );
              }
            }),
      ),
    );
  }
}
