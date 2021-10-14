import 'dart:io';

import 'package:diaryly/login/loginScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CreateDialog {
  createDialog(String msg, dynamic context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("$msg"),
            actions: <Widget>[
              TextButton(
                child: Text("Cerrar",
                    style: TextStyle(color: Colors.deepPurple[500])),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  createDialogToLogin(String msg, dynamic context) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("$msg"),
            actions: <Widget>[
              TextButton(
                child:
                    Text("Sí", style: TextStyle(color: Colors.deepPurple[500])),
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => Login()));
                },
              ),
              TextButton(
                child:
                    Text("No", style: TextStyle(color: Colors.deepPurple[500])),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  createDialogCloseApp(String msg, dynamic context) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("$msg"),
            actions: <Widget>[
              TextButton(
                child:
                Text("Sí", style: TextStyle(color: Colors.deepPurple[500])),
                onPressed: () {
                  SystemNavigator.pop();
                },
              ),
              TextButton(
                child:
                Text("No", style: TextStyle(color: Colors.deepPurple[500])),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}
