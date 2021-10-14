import 'package:diaryly/home/HomeOrQuestionnaire.dart';
import 'package:diaryly/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class SplashToHome extends StatefulWidget {
  const SplashToHome({Key? key}) : super(key: key);

  @override
  State<SplashToHome> createState() => _SplashState();
}

class _SplashState extends State<SplashToHome> {
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    await Future.delayed(Duration(milliseconds: 3000), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => HomeOrQuestionnaire()));
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