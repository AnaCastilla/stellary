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
                            radius: 80,
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
                        : snapshot.data.toString(), style: GoogleFonts.theGirlNextDoor(fontSize: 35, fontWeight: FontWeight.bold),),
                  ),
                Container(
                    height: MediaQuery.of(context).size.height / 1.9,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(
                        left: 30, right: 30, bottom: 40),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80.0),
                    child: Column(
                        children: [
                          Text("BUILDING...", style: GoogleFonts.bungeeShade(fontSize: 40)),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Icon(Icons.tag_faces_rounded, size: 50,),
                          )
                        ],
                      ),
                    ),
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
