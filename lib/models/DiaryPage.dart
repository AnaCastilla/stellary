import 'package:flutter/material.dart';

class DiaryPage extends ChangeNotifier {

  bool vista = false;


  changeView() {
    vista = !vista;
    notifyListeners();
  }

}