import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/home/Home.dart';
import 'package:diaryly/questionnaire/questionnaireScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeOrQuestionnaire extends StatefulWidget {
  const HomeOrQuestionnaire({Key? key}) : super(key: key);

  @override
  _HomeOrQuestionnaireState createState() => _HomeOrQuestionnaireState();
}

class _HomeOrQuestionnaireState extends State<HomeOrQuestionnaire> {
  @override
  Widget build(BuildContext context) {
    User user = ModalRoute.of(context)!.settings.arguments as User;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: FutureBuilder<bool>(
          future: getNumberOfLogs(user.email!),
          builder: (context, snapshot) {
            return (snapshot.data == false)
                ? Home(user: user)
                : Questionnaire(
                    user: user,
                  );
          },
        ));
  }
}

//Función que obtiene de la base de datos el número de logeos que ha hecho el usuario en la app
//Si dicho número es 1, devuelve true, por lo que la app mostrará la pantalla del cuestionario, si no, la de home
Future<bool> getNumberOfLogs(String email) async {
  var numLogs;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .get()
      .then((res) => {numLogs = res.data()!['numberOfLogs'].toString()});

  print("NUMBEROFLOGS OBTENIDO");
  int num = int.parse(numLogs);
  print(num);

  return (num==1)?true:false;
}
