import 'package:flutter/material.dart';

import 'DiaryPageModel.dart';

class DiaryPage extends ChangeNotifier {

  List<DiaryPageModel> pagesList = [];

  addDiaryPage(String author, String date, String mood, String title, String content, int score) {
    pagesList.add(new DiaryPageModel(author, date, mood, title, content, score));

    notifyListeners();
  }

}