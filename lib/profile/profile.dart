import 'dart:io';
import 'package:diaryly/api/FirestoreApi.dart';
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
  File? image;
  UploadTask? task;

  initState() {
    super.initState();

  }

  Future getImage() async {
    try {
      final image = await ImagePicker.platform.pickImage(
          source: ImageSource.gallery);
      if (image == null) return;
      print(image.path);
      String path = image.path;

      final imagePermanent = await saveImagePermanently(image.path);

      setState(() => this.image = imagePermanent);
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  Future<String> uploadFile() async {
    final fileName = basename(image!.path);
    final destination = '$fileName';

    task = FirebaseApi.uploadImage(destination, image!);

    final snapshot = await task!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print(urlDownload);
    setState(() {
      setProfilePic(widget.user.email!, urlDownload);
    });


    return urlDownload;
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
                                    child: CircleAvatar(
                                            radius: 90,
                                            backgroundColor: Colors.transparent,
                                            child: ClipOval(
                                              child: SizedBox(
                                                width: 160,
                                                height: 160,
                                                child: (snapshots.data
                                                    .toString() != "") ? Image
                                                    .network(snapshots.data.toString(),
                                                    fit: BoxFit.cover) :
                                                Image.asset("assets/avatar.png",
                                                  fit: BoxFit.cover,
                                                  color: Colors.white,),
                                              ),

                                            )
                                    )
                                ),

                              ],
                            ),

                            TextButton(
                              child: Text("Cambiar imagen de perfil"),
                              onPressed: () {
                                setState(() {
                                  getImage();

                                });
                                uploadFile();
                              },
                            )
                          ],
                        );
                      }
                    }
                )
            ),
          ),


        )
    );
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

setProfilePic(String email, String path) async {
  CollectionReference user = FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).set({"profilePic": path}, SetOptions(merge:true));
}

