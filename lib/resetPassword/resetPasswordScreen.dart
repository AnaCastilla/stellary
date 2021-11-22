import 'package:diaryly/login/loginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class ResetPassword extends StatefulWidget {

  ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController email;
  final _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _resetFormKey = GlobalKey<FormState>();

  initState() {
    email = new TextEditingController();
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
                HexColor("#341654")
              ])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
              child: Column(children: [
                Padding(
                    padding: const EdgeInsets.only(left: 10, top: 220, right: 10),
                    child: Container(
                      child: Text("¿Has olvidado tu contraseña?",
                          style: GoogleFonts.poiretOne(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 20, 30, 20),
                  child: Container(
                      child: Text(
                          "No te preocupes, introduce tu e-mail para poder crear una nueva",
                          style: GoogleFonts.varelaRound())),
                ),
                Container(
                    height: MediaQuery.of(context).size.height / 3.5,
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
                            key: _resetFormKey,
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
                                                Icons.email,
                                                color: Colors.white,
                                              ),
                                              filled: true,
                                              hintText: "E-mail",
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
                                              primary: Colors.purple.shade900,
                                              onPrimary: Colors.white,
                                            ),
                                            onPressed: () async {
                                              if (_resetFormKey.currentState!
                                                  .validate()) {
                                                _auth.sendPasswordResetEmail(email: email.text);
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder:
                                                          (context) =>
                                                          Login(),
                                                    ));
                                                print(
                                                    'Contraseña restaurada');
                                                Fluttertoast.showToast(
                                                    msg:
                                                    'E-mail de recuperación enviado a ${email.text}');
                                              }
                                            },
                                            child: Text('Recuperar',
                                                style: GoogleFonts.varelaRound())),
                                      ),
                                    ],
                                  ));
                            }),
                          ),
                        ])),
              ]))),
    );
  }

}