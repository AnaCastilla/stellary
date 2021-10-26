import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/dialog/createDialog.dart';
import 'package:diaryly/register/registrationScreen.dart';
import 'package:diaryly/resetPassword/resetPasswordScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  CreateDialog dialog = CreateDialog();
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  late TextEditingController email;
  late TextEditingController password;
  String emailValue = "E-mail";
  bool seePassword = true, rememberMe = false;

  @override
  initState() {
    email = new TextEditingController();
    password = new TextEditingController();
    _loadUserEmailPassword();
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
              HexColor("#000000"),
              HexColor("#000000"),
              HexColor("#000000"),
              HexColor("#000000"),
              HexColor("#000000"),
              HexColor("#000000"),
              HexColor("#200A37")
            ])),
        child: WillPopScope(
          onWillPop: _onWillPopScope,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: SingleChildScrollView(
                child: Center(
                    child: Column(children: [
                  Image.asset(
                    "assets/starfall1.gif",
                  ),
                  Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 30, top: 78),
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
                              fontSize: 63,
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
                              height: MediaQuery.of(context).size.height / 1.9,
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
                                          left: 20, right: 20, top: 25),
                                      child: TextFormField(
                                        controller: password,
                                        obscureText: seePassword,
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
                                            suffixIcon: IconButton(
                                                icon: (!seePassword)
                                                    ? Icon(Icons.visibility_off)
                                                    : Icon(Icons.visibility),
                                                color: Colors.white,
                                                onPressed: () {
                                                  setState(() {
                                                    seePassword = !seePassword;
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
                                                  decoration:
                                                      TextDecoration.underline),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ResetPassword()));
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Row(children: [
                                        Checkbox(
                                            value: rememberMe,
                                            activeColor: Colors.deepPurple,
                                            onChanged: _handleRememberMe),
                                        Text("Recordar mis datos",
                                            style: GoogleFonts.varelaRound())
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
                                            primary: Colors.deepPurple[800],
                                            onPrimary: Colors.white,
                                          ),
                                          onPressed: () async {
                                            incrementLogs(email.text);
                                            if (_loginFormKey.currentState!
                                                .validate()) {
                                              FirebaseAuth.instance
                                                  .signInWithEmailAndPassword(
                                                      email: email.text,
                                                      password: password.text)
                                                  .then((currentUser) =>
                                                      FirebaseFirestore.instance
                                                          .collection(
                                                              "usuarios")
                                                          .doc(currentUser
                                                              .toString())
                                                          .get()
                                                          .then(
                                                            (DocumentSnapshot
                                                                    result) =>
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        'home',
                                                                        arguments:
                                                                            currentUser.user!),
                                                          ))
                                                  .catchError((err) {
                                                print(err);
                                                if (err.code ==
                                                    'user-not-found') {
                                                  dialog.createDialog(
                                                      "No existe cuenta asociada a ese e-mail",
                                                      context);
                                                } else if (err.code ==
                                                    'wrong-password') {
                                                  dialog.createDialog(
                                                      "Contraseña incorrecta",
                                                      context);
                                                }
                                              });
                                            }
                                          },
                                          child: Text('Iniciar sesión',
                                              style:
                                                  GoogleFonts.varelaRound())),
                                    ),
                                  ]));
                        },
                      ),
                    ),
                  ]),
                  Container(
                      margin: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("¿Aún no eres miembro?",
                              style: GoogleFonts.varelaRound()),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Registration()));
                              },
                              child: Text(
                                "Regístrate",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline),
                              ))
                        ],
                      ))
                ])),
              )),
        ));
  }

  Future<bool> _onWillPopScope() {
    CreateDialog dialog = CreateDialog();
    return dialog.createDialogCloseApp("¿Quieres salir de Stellary?", context);
  }

  void _handleRememberMe(bool? value) {
    rememberMe = value!;
    SharedPreferences.getInstance().then(
      (prefs) {
        prefs.setBool("remember_me", value);
        prefs.setString('email', email.text);
        prefs.setString('password', password.text);
      },
    );
    setState(() {
      rememberMe = value;
    });
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _rememberMe = _prefs.getBool("remember_me") ?? false;
      print(_rememberMe);
      print(_email);
      print(_password);
      if (_rememberMe) {
        setState(() {
          rememberMe = true;
        });
        email.text = _email;
        password.text = _password;
      }
    } catch (e) {
      print(e);
    }
  }

}

incrementLogs(String email) async {
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .update({"numberOfLogs": FieldValue.increment(1)});
  print("SE HA INCREMENTADO");
}
