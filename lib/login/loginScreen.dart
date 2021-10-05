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
  bool seePassword = true;

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
                      margin: EdgeInsets.only(left: 30, top: 10, bottom: 50),
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
                                height: MediaQuery.of(context).size.height / 1.8,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 30, right: 30, bottom: 40),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                                        child: TextFormField(
                                          controller: email,
                                          keyboardType: TextInputType.emailAddress,
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
                                              hintText: "Email",
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
                                                      seePassword = !seePassword;
                                                    });
                                                  }),
                                              filled: true,
                                              hintText: "Contraseña",
                                              fillColor: Colors.white70
                                                  .withOpacity(0.35)),
                                        ),
                                      ),
                                    ]));
                          },
                        ),
                      ),
                    ])
                  ])),
            )));
  }
}
