import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:diaryly/splash/splashScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'login/loginScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.orange),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primaryColor: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal).copyWith(secondary: Colors.orange),
        brightness: Brightness.dark,
      ),
      home: Splash()
    );
  }
}
