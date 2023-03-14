import 'package:blogappflutternew/Components/roundbutton.dart';
import 'package:blogappflutternew/screens/addpost.dart';
import 'package:blogappflutternew/screens/optionscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeSreen extends StatefulWidget {
  const HomeSreen({super.key});

  @override
  State<HomeSreen> createState() => _HomeSreenState();
}

class _HomeSreenState extends State<HomeSreen> {
  TextEditingController searchController = TextEditingController();
  String search = "";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
          automaticallyImplyLeading: false,
          actions: [
            InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddPost()));
                },
                child: Icon(Icons.add))
          ],
        ),
        body: Column(children: [
          TextFormField(
            controller: searchController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: 'Search',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
            onChanged: (String value) {
              search = value;
            },
          ),
          Text("New vlog"),
          RoundButton(title: "logout", onPress: logout)
        ]),
      ),
    );
  }

  void logout() {
    FirebaseAuth.instance.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => OptionScreen()));
  }
}
