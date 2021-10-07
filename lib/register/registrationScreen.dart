import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  late TextEditingController email, password, confirmPassword;
  bool seePassword = true;

  @override
  initState() {
    email = new TextEditingController();
    password = new TextEditingController();
    confirmPassword = new TextEditingController();
    super.initState();
  }

  String? emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value!)) {
      return 'Email incorrecto';
    } else if (value.isEmpty) {
      return 'Introduce el email';
    } else {
      return null;
    }
  }

  String? passwordValidator(String? value) {
    if (value!.length < 6) {
      return 'Mínimo 6 caracteres';
    } else if (value.isEmpty) {
      return 'Introduce la contraseña';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                child: Text("ÚNETE A STELLARY",
                    style: GoogleFonts.poiretOne(
                        fontSize: 35, fontWeight: FontWeight.bold)),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 20),
            child: Container(
                child: Text(
                    "Disfruta, comparte, chatea en tu diario de confianza",
                    style: GoogleFonts.varelaRound())),
          ),
          Container(
              height: MediaQuery.of(context).size.height / 1.7,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 30, right: 30, bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Form(
                      key: _registerFormKey,
                      child: Builder(builder: (_) {
                        return Container(
                            margin: EdgeInsets.only(top: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 25),
                                  child: TextFormField(
                                    controller: email,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: emailValidator,
                                    cursorColor: Colors.white38,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                                  .withOpacity(0.35)),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Colors.white,
                                        ),
                                        filled: true,
                                        hintText: "E-mail",
                                        fillColor:
                                            Colors.white70.withOpacity(0.35)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 25),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: password,
                                    validator: passwordValidator,
                                    cursorColor: Colors.white38,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                                  .withOpacity(0.35)),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        filled: true,
                                        hintText: "Contraseña",
                                        fillColor:
                                            Colors.white70.withOpacity(0.35)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 25),
                                  child: TextFormField(
                                    obscureText: true,
                                    controller: confirmPassword,
                                    validator: passwordValidator,
                                    cursorColor: Colors.white38,
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                            borderSide: BorderSide(
                                                color: Colors.black)),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white70
                                                  .withOpacity(0.35)),
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        prefixIcon: Icon(Icons.lock,
                                            color: Colors.white),
                                        filled: true,
                                        hintText: "Repite la contraseña",
                                        fillColor:
                                            Colors.white70.withOpacity(0.35)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding:
                                            EdgeInsets.fromLTRB(60, 20, 60, 20),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    10.0)),
                                        primary: Colors.deepPurple[800],
                                        onPrimary: Colors.white,
                                      ),
                                      onPressed: () async {
                                        if (_registerFormKey.currentState!.validate()) {
                                          if (password.text ==
                                              confirmPassword.text) {
                                            //await auth.newUser(email.text, password.text);
                                            FirebaseAuth.instance
                                                .createUserWithEmailAndPassword(
                                                    email: email.text,
                                                    password: password.text)
                                                .then(
                                                    (currentUser) =>
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "usuarios")
                                                            .add({
                                                          "e-mail": email,
                                                          "numberOfLogs": 0,
                                                          "registradoDia": DateTime.now().day,
                                                          "registradoMes": DateTime.now().month,
                                                          "registradoYear": DateTime.now().year,
                                                        }).catchError((err) {
                                                          print(err);
                                                          if (err ==
                                                              'email-already-in-use') {
                                                            showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title: Text(
                                                                        "Error"),
                                                                    content: Text(
                                                                        "Este e-mail ya está en uso"),
                                                                    actions: <
                                                                        Widget>[
                                                                      TextButton(
                                                                        child: Text(
                                                                            "Cerrar",
                                                                            style:
                                                                                TextStyle(color: Colors.deepPurple[500])),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      )
                                                                    ],
                                                                  );
                                                                });
                                                          } else {
                                                            //_registerFormKey.currentState.save();
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Login(),
                                                                ));
                                                            print(
                                                                'Usuario registrado');
                                                            Fluttertoast.showToast(
                                                                msg:
                                                                    'Usuario registrado');
                                                          }
                                                        }));
                                            createUserInCollection(email.text);
                                          } else {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text(
                                                        "Las contraseñas no coinciden"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text("Cerrar",
                                                            style: TextStyle(
                                                                color: Colors
                                                                        .deepPurple[
                                                                    500])),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                      )
                                                    ],
                                                  );
                                                });
                                          }
                                        }
                                      },
                                      child: Text('Registrarse',
                                          style: GoogleFonts.varelaRound())),
                                ),
                              ],
                            ));
                      }),
                    ),
                  ])),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¿Ya eres miembro?", style: GoogleFonts.varelaRound()),
              TextButton(
                child: Text(
                  "Inicia sesión",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      decoration: TextDecoration.underline),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          )
        ])));
  }
}

Future<void> createUserInCollection(String email) async {
  CollectionReference user = FirebaseFirestore.instance.collection('usuarios');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  user.doc(email).set({
    "e-mail": email,
    "uid": uid,
    "numberOfLogs": 0,
    "registradoDia": DateTime.now().day,
    "registradoMes": DateTime.now().month,
    "registradoYear": DateTime.now().year,});

  return;
}
