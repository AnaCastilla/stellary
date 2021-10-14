import 'package:diaryly/home/HomeOrQuestionnaire.dart';
import 'package:diaryly/questionnaire/questionnaireScreen.dart';
import 'package:diaryly/register/registrationScreen.dart';
import 'package:diaryly/splash/splashScreenToHome.dart';
import 'package:diaryly/splash/splashScreenToLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login/loginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.deepPurple[500]),
      brightness: Brightness.light,
    ),
    darkTheme: ThemeData(
      primaryColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.deepPurple[500]),
      brightness: Brightness.dark,
    ),
    routes: {
      'home': (context) => HomeOrQuestionnaire()
    },
    home: email == null ? SplashToLogin() : SplashToHome(),
  ));
}
