import 'package:diaryly/home/HomeOrQuestionnaire.dart';
import 'package:diaryly/splash/splashScreenToLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'login/loginScreen.dart';
import 'models/DatabaseService.dart';
import 'models/DiaryPage.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeDateFormatting('es_ES').then((_) =>runApp(ChangeNotifierProvider(
    create: (context) => DiaryPage(),
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
      home: SplashToLogin(),
    ),
  )));
}
