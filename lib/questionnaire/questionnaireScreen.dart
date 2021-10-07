import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Questionnaire extends StatefulWidget {
  late User user;

  Questionnaire({Key? key, User? user}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {


  Future<void> incrementLogs(String email, int logs) async {
    //await FirebaseFirestore.instance.collection('collection').doc(user).set({logs.toString(): logs++});
    //await FirebaseFirestore.instance.collection('collection').where('email', isEqualTo: email).s
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('cuestionario'),
    );
  }
}
