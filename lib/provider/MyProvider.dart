import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProvider extends ChangeNotifier {

  bool notifications = false;

  bool vista = false;

  changeView() {
    vista = !vista;
    notifyListeners();
  }

  activateNotifications() {
    notifications = !notifications;
    notifyListeners();
  }

}