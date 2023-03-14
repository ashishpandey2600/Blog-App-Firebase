import 'package:blogappflutternew/Components/roundbutton.dart';
import 'package:blogappflutternew/screens/login.dart';
import 'package:blogappflutternew/screens/signup.dart';
import 'package:flutter/material.dart';

import 'forgotpassword.dart';

class OptionScreen extends StatefulWidget {
  const OptionScreen({super.key});

  @override
  State<OptionScreen> createState() => _OptionScreenState();
}

class _OptionScreenState extends State<OptionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Sceen"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/f.jpg')),
            SizedBox(
              height: 100,
            ),
            RoundButton(
                title: "Login",
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LogIn()));
                }),
            SizedBox(
              height: 10,
            ),
            RoundButton(
                title: "Sign Up",
                onPress: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignUp()));
                }),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 30),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ForgotPassword()));
                },
                child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("forgot password")),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
