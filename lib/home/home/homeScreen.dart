import 'package:cloud_firestore/cloud_firestore.dart';
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
  void initState() {
    super.initState();
    setState(() {
      getProfilePic(widget.user.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
          future: getUserNickname(widget.user.email!),
          builder: (context, snapshot) {
            return SingleChildScrollView(
                child: Center(
                    child: Column(children: [
              Column(
                children: [
                  FutureBuilder<Object>(
                    future: getProfilePic(widget.user.email!),
                    builder: (context, pic) {
                      if (!pic.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return CircleAvatar(
                            radius: 90,
                            backgroundColor: Colors.transparent,
                            child: ClipOval(
                              child: SizedBox(
                                height: 200,
                                width: 200,
                                child: (pic.data
                                    .toString() != "") ? Image
                                    .network(pic.data.toString(),
                                    fit: BoxFit.cover) :
                                Image.asset("assets/avatar.png",
                                  fit: BoxFit.cover,
                                  color: Colors.white,),
                              ),
                            ));
                      }
                    }
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                    child: Text((snapshot.data.toString() == "")
                        ? widget.user.email!
                        : snapshot.data.toString(), style: GoogleFonts.poiretOne(fontSize: 35, fontWeight: FontWeight.bold),),
                  ),
                ],
              )
            ])));
          }),
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

Future<String> getProfilePic(String email) async {
  var pic;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .get()
      .then((res) => {pic = res.data()!['profilePic'].toString()});

  return pic;
}
