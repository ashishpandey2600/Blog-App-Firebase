import 'package:blogappflutternew/Components/roundbutton.dart';
import 'package:blogappflutternew/screens/homescreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();

  final _fromkey = GlobalKey<FormState>();
  String email = "";
  bool showspinner = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showspinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Reset your Password'),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _fromkey,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              hintText: 'email',
                              prefixIcon: Icon(Icons.email)),
                          onChanged: (String value) {
                            email = value;
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'Enter Email' : null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40),
                          child: RoundButton(
                              title: 'Reset Password',
                              onPress: () async {
                                if (_fromkey.currentState!.validate()) {
                                  setState(() {
                                    showspinner = true;
                                  });
                                  try {
                                    _auth
                                        .sendPasswordResetEmail(
                                            email:
                                                emailController.text.toString())
                                        .then((value) {
                                      setState(() {
                                        showspinner = false;
                                      });
                                      toastMessage(
                                          'Please check your email, a reset link has been sent to your email');
                                    }).onError((e, StackTrace) {
                                      toastMessage(e.toString());
                                      setState(() {
                                        showspinner = false;
                                      });
                                    });
                                  } catch (e) {
                                    print(e.toString());
                                    toastMessage(e.toString());
                                    setState(() {
                                      showspinner = false;
                                    });
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  ))
            ]),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 5,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 18,
    );
  }
}
