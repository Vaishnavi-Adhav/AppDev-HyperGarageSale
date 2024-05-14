import 'package:flutter/material.dart';
import 'package:hypergaragesale/pages/BrowsePostsActivity.dart';
import 'package:hypergaragesale/utilis/constants.dart';
import 'package:hypergaragesale/widgets/customloginlogout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hypergaragesale/widgets/customsnackbar.dart';
import '../widgets/custombutton.dart';
import '../widgets/customtextfield.dart';
import 'package:email_validator/email_validator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return BrowsePostsActivity();
            } else {
              return Container(
                padding: EdgeInsets.all(width * 0.05),
                child: Center(
                  child: ListView(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: height * 0.1),
                      SizedBox(width: width * 0.7, child: Image.asset('assets/images/logo.PNG')),
                      SizedBox(height: height * 0.1),
                      CustomTextField(width: width, hint: 'Email', controller: emailController, icon: Icons.email),
                      SizedBox(height: 10),
                      CustomTextField(width: width, hint: 'Password', controller: passwordController, icon: Icons.lock),
                      SizedBox(height: height * 0.05),
                      CustomButton(
                          width: width,
                          text: 'Login',
                          onPress: () async {
                            if (emailController.text.trim() == '' || passwordController.text.trim() == '') {
                              showSnackBar(context, 'Please Enter Correct Email/Password');
                            } else if (!EmailValidator.validate(emailController.text)) {
                              showSnackBar(context, 'Email Format is not correct.');
                            } else if (passwordController.text.length < 6) {
                              showSnackBar(context, 'Password must have 6 characters.');
                            } else {
                              try {
                                UserCredential user = await FirebaseAuth.instance
                                    .signInWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
                                if (user.user!.email!.isNotEmpty) {
                                  showSnackBar(context, 'Login Successful');
                                  Navigator.pushNamed(context, 'browsepostactivity');
                                }
                              } catch (e) {
                                showSnackBar(context, e.toString());
                              }
                            }
                          }),
                      SizedBox(height: 10),
                      CustomLoginLogOut(
                          buttonTxt: 'SignUp',
                          msg: 'Don\'t have an account?',
                          onPress: () {
                            Navigator.pushReplacementNamed(context, 'signup');
                          })
                    ],
                  ),
                ),
              );
            }
          }),
    );
  }
}
