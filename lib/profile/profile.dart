import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  final User user;
  Profile({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [HexColor("#000000"), HexColor("#200A37")])),
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
          ),
          backgroundColor: Colors.transparent,
          body: FutureBuilder<String>(
            future: getProfilePic(widget.user.email!),
            builder: (context, snapshot) {
              return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            filePicker();
                          },
                          iconSize: 120,
                          icon: SizedBox(
                            width: 120,
                            height: 120,
                            child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: (snapshot.data == null)? Image.asset('assets/avatar.png',
                                  color: Colors.deepPurple) : Image.file(File(image!.path))
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
            }
          ),
          )
    );
  }

  void filePicker() async {
    final XFile? selectImage = await _picker.pickImage(source: ImageSource.gallery);
    print(selectImage!.path);
    setState(() {
      image = selectImage;
    });
  }
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

