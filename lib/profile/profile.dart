import 'dart:io';
import 'package:diaryly/home/Home.dart';
import 'package:diaryly/home/home/homeScreen.dart';
import 'package:diaryly/questionnaire/questionnaireEdit.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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
  final GlobalKey<FormState> _profileFormKey = GlobalKey<FormState>();
  late TextEditingController nickController;
  File? file;
  UploadTask? task;

  initState() {
    super.initState();
    nickController = new TextEditingController();
    getProfilePic(widget.user.email!);
  }

  String? nicknameValidator(String? value) {
    if (value!.length < 3 && value.length != 0) {
      return 'Nickname demasiado corto';
    } else if (value.length > 15) {
      return 'Nickname demasiado largo';
    } else {
      return null;
    }
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
    if (file != null) {
      String url = await uploadFile();
      updateProfilePic(widget.user.email!, url);
    }

    if(nickController.text != "") {
      updateNickname(widget.user.email!, nickController.text);
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Home(user: widget.user)),
    ).then((value) => setState(() {}));
  }

  Future getProfilePic(String email) async {
    var pic;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(email)
        .get()
        .then((res) => {pic = res.data()!['profilePic'].toString()});

    return pic;
  }

  Future getNickname(String email) async {
    var nickname;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(email)
        .get()
        .then((res) => {nickname = res.data()!['nickname'].toString()});

    return nickname;
  }

  Future getRegisterDate(String email) async {
    var day, month, year, date;
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(email)
        .get()
        .then((res) => {day = res.data()!['registradoDia'].toString()});
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(email)
        .get()
        .then((res) => {month = res.data()!['registradoMes'].toString()});
    await FirebaseFirestore.instance
        .collection('usuarios')
        .doc(email)
        .get()
        .then((res) => {year = res.data()!['registradoYear'].toString()});

    date = day + "/" + month + "/" + year;

    return date;
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
                    child: Column(
              children: [
                FutureBuilder(
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
                                                child: (snapshots.data
                                                            .toString() !=
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
                            ]);
                      }
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "E-mail",
                        style: GoogleFonts.varelaRound(fontSize: 20),
                      )),
                ),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: TextField(
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: Colors.white38,
                    enabled: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20.0),
                            borderSide: BorderSide(color: Colors.black)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white70.withOpacity(0.35)),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        filled: true,
                        hintText: widget.user.email,
                        fillColor: Colors.white70.withOpacity(0.35)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Nickname",
                        style: GoogleFonts.varelaRound(fontSize: 20),
                      )),
                ),
                FutureBuilder(
                    future: getUserNickname(widget.user.email!),
                    builder: (context, nick) {
                      return Container(
                        margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                        child: Form(
                          key: _profileFormKey,
                          child: TextFormField(
                            controller: nickController,
                            validator: nicknameValidator,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.text,
                            cursorColor: Colors.white38,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70.withOpacity(0.35)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintText: nick.data.toString(),
                                hintStyle: TextStyle(color: Colors.white),
                                fillColor: Colors.white70.withOpacity(0.35)),
                          ),
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 30),
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Intereses",
                        style: GoogleFonts.varelaRound(fontSize: 20),
                      )),
                ),
                FutureBuilder(
                  future: getCategories(widget.user.email!),
                  builder: (context, cat) {
                    return Container(
                      height: 160,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                      child: TextField(
                        cursorColor: Colors.white38,
                        enabled: false,
                        keyboardType: TextInputType.multiline,
                        maxLines: 10,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.black.withOpacity(0.1))),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white70.withOpacity(0.1)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            hintText: cat.data.toString().replaceAll("[", "").replaceAll("]", ""),
                            hintStyle: TextStyle(color: Colors.white),
                            fillColor: Colors.white70.withOpacity(0.35)),
                      ),
                    );
                  }
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    child: TextButton(
                      child: Text("Cambiar intereses"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                  QuestionnaireEdit(user: widget.user,),
                            ));

                      },
                    ),
                  ),
                ),
                FutureBuilder(
                    future: getRegisterDate(widget.user.email!),
                    builder: (context, date) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 10),
                          child: Text("Cuenta registrada el ${date.data.toString()}", style: GoogleFonts.varelaRound())
                        ),
                      );
                    }),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 40),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(10.0)),
                        primary: Colors.deepPurple[800],
                        onPrimary: Colors.white,
                      ),
                      onPressed: () {
                        if (_profileFormKey.currentState!.validate()) {
                          updateProfile(context);
                          Fluttertoast.showToast(msg: 'Perfil actualizado');
                        }

                      },
                      child: Text("Actualizar perfil",
                          style: GoogleFonts.varelaRound())),
                )
              ],
            )))));
  }
}

Future<void> getCategories(String email) async {
  var list;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .get()
      .then((res) => {list = res.data()!['categories'].toString()});

  return list;
}

updateProfilePic(String email, String path) async {
  CollectionReference user =
      await FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).update({'profilePic': path});
}

updateNickname(String email, String newNickname) async {
  CollectionReference user =
      await FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).update({'nickname': newNickname});
}
