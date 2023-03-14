import 'dart:io';

import 'package:blogappflutternew/Components/roundbutton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  bool showSpinner = false;

  final postRef = FirebaseDatabase.instance.ref().child('Posts');
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  File? image;

  final picker = ImagePicker();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future getImageGallery() async {
    final PickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (PickedFile != null) {
        image = File(PickedFile.path);
      } else {
        print("No image selected");
        
      }
    });
  }

  Future getImageCamera() async {
    final PickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (PickedFile != null) {
        image = File(PickedFile.path);
      } else {
        print("No image selected");
      }
    });
  }

  void dialog(context) {
    showDialog(
        context: this.context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Container(
              height: 120,
              child: Column(children: [
                InkWell(
                  onTap: () {
                    getImageCamera();
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera),
                    title: Text('Camera'),
                  ),
                ),
                InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Gallery'),
                    )),
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          title: Text('upload blog'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
              children: [
                Center(
                  child: InkWell(
                    onTap: () {
                      dialog(context);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * .2,
                      width: MediaQuery.of(context).size.width * 1,
                      child: image != null
                          ? ClipRRect(
                              child: Image.file(
                                image!.absolute,
                                width: 100,
                                height: 100,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: Colors.blueGrey,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: 100,
                              height: 100,
                              child: Icon(Icons.camera_alt),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                    child: Column(
                  children: [
                    TextFormField(
                      controller: titleController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 40,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter post title',
                        border: OutlineInputBorder(),
                        hintStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      keyboardType: TextInputType.text,
                      minLines: 1,
                      maxLines: 100,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter Descritption',
                        hintStyle: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.normal),
                        labelStyle: TextStyle(
                            color: Colors.teal, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    RoundButton(
                        title: 'Upload',
                        onPress: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            int date = DateTime.now().millisecondsSinceEpoch;
                            firebase_storage.Reference ref = firebase_storage
                                .FirebaseStorage.instance
                                .ref('/BlogApp$date');
                            UploadTask uploadTask =
                                ref.putFile(image!.absolute);
                            await Future.value(uploadTask);
                            var newUrl = await ref.getDownloadURL();

                            final User? user = auth.currentUser;
                            postRef
                                .child('Post List')
                                .child(date.toString())
                                .set({
                              'pId': date.toString(),
                              'pImage': newUrl.toString(),
                              'pTime': date.toString(),
                              'pTitle': titleController.text.toString(),
                              'pDescritption':
                                  descriptionController.text.toString(),
                              'UEmail': user!.email.toString(),
                              'Uid': user.uid.toString(),
                            }).then((value) {
                              toastMessage("Post published");
                              setState(() {
                                showSpinner = false;
                              });
                            }).onError((error, stackTrace) {
                              toastMessage(error.toString());
                              setState(() {
                                showSpinner = false;
                              });
                            });
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            toastMessage(e.toString());
                          }
                        }),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
      msg: message.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.SNACKBAR,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.white,
      textColor: Colors.black,
      fontSize: 16.0,
    );
  }
}
