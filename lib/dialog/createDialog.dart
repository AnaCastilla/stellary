import 'package:flutter/material.dart';

class CreateDialog {
  createDialog(String msg, dynamic context) {
    showDialog(
        context: context,
        builder:
            (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "$msg"),
            actions: <Widget>[
              TextButton(
                child: Text(
                    "Cerrar",
                    style: TextStyle(
                        color: Colors
                            .deepPurple[
                        500])),
                onPressed: () {
                  Navigator.of(
                      context)
                      .pop();
                },
              )
            ],
          );
        });
  }
}

