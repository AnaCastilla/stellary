import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/dialog/createDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
        future: getUserNickname(widget.user.email!),
        builder: (context, snapshot) {
          return SingleChildScrollView(
              child: Center(
                  child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 30, top: 40),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 100,
                                width: 100,
                                child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Image.asset('assets/avatar.png',
                                      color: Colors.deepPurple,)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text((snapshot.data.toString()=="")? widget.user.email! : snapshot.data.toString()),
                              )
                            ],
                          ),
                        )
                      ])));
        }
      ),
    );
  }
}

Future<String> getUserNickname(String email) async {
  var name;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .get()
      .then((res) => {name = res.data()!['nickname'].toString()});

  return name;
}
