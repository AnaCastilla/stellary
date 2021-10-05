import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/register/registrationScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Login extends StatefulWidget {
  late String user, password;

  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  String emailValue = "Email";
  bool seePassword = true, rememberValue = false;

  @override
  initState() {
    email = new TextEditingController();
    password = new TextEditingController();
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
    if (value!.length < 5) {
      return 'Contraseña incorrecta';
    } else if (value.isEmpty) {
      return 'Introduce la contraseña';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
              HexColor("452777"),
              HexColor("5e4394"),
              HexColor("7a66aa")
            ])),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 30, top: 80),
                        child: Row(
                          children: [
                            Text("Bienvenido a",
                                style: GoogleFonts.poiretOne(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                )),
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.only(left: 30, top: 10, bottom: 30),
                      child: Row(
                        children: [
                          Text("STELLARY",
                              style: GoogleFonts.poiretOne(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ),
                    Stack(children: [
                      Form(
                        key: _loginFormKey,
                        child: Builder(
                          builder: (context) {
                            return Container(
                                height:
                                    MediaQuery.of(context).size.height / 1.6,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 40),
                                        child: TextFormField(
                                          controller: email,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          validator: emailValidator,
                                          cursorColor: Colors.white38,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white70
                                                        .withOpacity(0.35)),
                                                borderRadius:
                                                    BorderRadius.circular(20.0),
                                              ),
                                              prefixIcon: Icon(Icons.person,
                                                  color: Colors.white),
                                              filled: true,
                                              hintText: emailValue,
                                              fillColor: Colors.white70
                                                  .withOpacity(0.35)),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 40),
                                        child: TextFormField(
                                          controller: password,
                                          obscureText: seePassword,
                                          validator: passwordValidator,
                                          cursorColor: Colors.white38,
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
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
                                              suffixIcon: IconButton(
                                                  icon: Icon(Icons.visibility),
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    setState(() {
                                                      seePassword =
                                                          !seePassword;
                                                    });
                                                  }),
                                              filled: true,
                                              hintText: "Contraseña",
                                              fillColor: Colors.white70
                                                  .withOpacity(0.35)),
                                        ),
                                      ),
                                      InkWell(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 18),
                                            child: TextButton(
                                              child: Text(
                                                "¿Olvidaste la contraseña?",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Registration()));
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(left: 10),
                                        child: Row(children: [
                                          Checkbox(
                                              value: rememberValue,
                                              activeColor: Colors.deepPurple,
                                              onChanged: (newValue) {
                                                setState(() {
                                                  rememberValue = newValue!;
                                                });
                                              }),
                                          Text("Recordar mis datos")
                                        ]),
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(30, 10, 30, 10),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              padding: EdgeInsets.fromLTRB(
                                                  60, 20, 60, 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      new BorderRadius.circular(
                                                          10.0)),
                                              primary: Colors.deepPurple[100],
                                              onPrimary: Colors.white,
                                            ),
                                            onPressed: () async {
                                              if (_loginFormKey.currentState!
                                                  .validate()) {
                                                FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                                        email: email.text,
                                                        password: password.text)
                                                    .then((currentUser) =>
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                "usuarios")
                                                            .doc(currentUser
                                                                .toString())
                                                            .get()
                                                            .then(
                                                              (DocumentSnapshot
                                                                      result) =>
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => Registration()
                                                                          /* ChatRoom(
                                                                        user:
                                                                        currentUser.user),*/
                                                                          )),
                                                            ))
                                                    .catchError(
                                                        (err) => print(err));
                                              }
                                            },
                                            child: Text('Iniciar sesión')),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12),
                                        child: Divider(
                                          indent: 50,
                                          endIndent: 50,
                                          color: Colors.white,
                                          thickness: 1,
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 72),
                                            child: SizedBox(
                                              width: 60,
                                              height: 60,
                                              child: IconButton(
                                                icon: Image.asset("assets/redes/fb.png", fit: BoxFit.cover,),
                                                onPressed: () {
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 67,
                                            height: 70,
                                            child: IconButton(
                                              icon: Image.asset("assets/redes/google.png", fit: BoxFit.cover,),
                                              onPressed: () {
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            width: 64,
                                            height: 63,
                                            child: IconButton(
                                              icon: Image.asset("assets/redes/twitter.png", fit: BoxFit.cover,),
                                              onPressed: () {
                                              },
                                            ),
                                          ),
                                        ],
                                      )

                                    ]));
                          },
                        ),
                      ),
                    ])
                  ])),
            )));
  }
}
