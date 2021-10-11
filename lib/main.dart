import 'package:diaryly/home/home/Home.dart';
import 'package:diaryly/questionnaire/questionnaireScreen.dart';
import 'package:diaryly/register/registrationScreen.dart';
import 'package:diaryly/splash/splashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'login/loginScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      /*initialRoute: 'splash',
      routes: {
        'splash' : (context) => Splash(),
        'register' : (context) => Registration(),
        'login' : (context) => Login(),
        'question' : (context) => Questionnaire(),
        'home' : (context) => Home()

      },*/
      home: Splash(),
    );
  }
}
