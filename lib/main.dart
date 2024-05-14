import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hypergaragesale/firebase_options.dart';
import 'package:hypergaragesale/pages/BrowsePostsActivity.dart';
import 'package:hypergaragesale/pages/ItemDetails.dart';
import 'package:hypergaragesale/pages/NewPostActivity.dart';
import 'package:hypergaragesale/pages/login.dart';
import 'package:hypergaragesale/pages/signup.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Garage Sale',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        'login': (context) => LoginPage(),
        'signup': (context) => SignUP(),
        'browsepostactivity': (context) => BrowsePostsActivity(),
        'newpostactivity': (context) => NewPostActivity(),
      },
    );
  }
}
