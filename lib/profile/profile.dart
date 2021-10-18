import 'dart:io';
import 'package:diaryly/home/Home.dart';
import 'package:diaryly/home/home/homeScreen.dart';
import 'package:diaryly/services/api/FirestoreApi.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class Profile extends StatefulWidget {
  final User user;

  Profile({Key? key, required this.user}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File? file;
  UploadTask? task;

  initState() {
    super.initState();
    getProfilePic(widget.user.email!);
  }

  getImage() async {
    try {
      final image =
          await ImagePicker.platform.pickImage(source: ImageSource.gallery);

      setState(() {
        print(image!.path);
        file = File(image.path);
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<String> uploadFile() async {
    TaskSnapshot taskSnapshot = await FirebaseStorage.instance
        .ref()
        .child("profile")
        .child(widget.user.email!)
        .putFile(file!);

    return taskSnapshot.ref.getDownloadURL();
  }

  updateProfile(BuildContext context) async {
    Map<String, dynamic> map = Map();
    if (file != null) {
      String url = await uploadFile();
      map['profilePic'] = url;
      setProfilePic(widget.user.email!, url);
    }

    //map['name'] = _name update nombre, nickname y toido eso
    //Navigator.pop(context);
    Navigator.push( context, MaterialPageRoute( builder: (context) => Home(user: widget.user)), ).then((value) => setState(() {}));

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
          body: SingleChildScrollView(
            child: Center(
                child: FutureBuilder(
                    future: getProfilePic(widget.user.email!),
                    builder: (context, snapshots) {
                      if (!snapshots.hasData) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: InkWell(
                                      onTap: () {
                                        getImage();
                                      },
                                      child: CircleAvatar(
                                          radius: 90,
                                          backgroundColor: Colors.transparent,
                                          child: ClipOval(
                                            child: SizedBox(
                                              width: 160,
                                              height: 160,
                                              child:
                                                  (snapshots.data.toString() !=
                                                          "")
                                                      ? (file != null)
                                                          ? Image.file(file!,
                                                              fit: BoxFit.cover)
                                                          : Image.network(
                                                              snapshots.data
                                                                  .toString(),
                                                              fit: BoxFit.cover)
                                                      : Image.asset(
                                                          "assets/avatar.png",
                                                          fit: BoxFit.cover,
                                                          color: Colors.white,
                                                        ),
                                            ),
                                          )),
                                    )),
                              ],
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  updateProfile(context);
                                },
                                child: Text("UPDATE PROFILE"))
                          ],
                        );
                      }
                    })),
          ),
        ));
  }
}

setProfilePic(String email, String path) async {
  CollectionReference user =
      await FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).update({'profilePic': path});
}
