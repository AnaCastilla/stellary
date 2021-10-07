import 'package:diaryly/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(Duration(milliseconds: 4000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [HexColor("#000000"), HexColor("#432762")])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
          body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
           ////////LOGO
          Container(
            height: 120,
            width: 120,
            child: Image.asset('assets/icon.png'),
          ),
        ]),
      )),
    );
  }
}
