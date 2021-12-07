import 'package:flutter/material.dart';

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