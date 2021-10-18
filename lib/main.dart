import 'package:diaryly/home/HomeOrQuestionnaire.dart';
import 'package:diaryly/splash/splashScreenToHome.dart';
import 'package:diaryly/splash/splashScreenToLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login/loginScreen.dart';
import 'models/DatabaseService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  runApp(ChangeNotifierProvider(
    create: (context) => DatabaseService(),
    child: MaterialApp(
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
        'home': (context) => HomeOrQuestionnaire(),
        'login': (context) => Login(),
      },
      home: email == null ? SplashToLogin() : SplashToHome(),
    ),
  ));
}
