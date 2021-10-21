import 'dart:io';

import 'package:diaryly/home/diary/page/WritePageDiary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DiaryScreen extends StatefulWidget {
  final User user;
  const DiaryScreen({Key? key, required this.user}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();
  final String defaultLocale = Platform.localeName;


  @override
  void initState() {
    super.initState();
    //initializeDateFormatting();
  }

  @override
  Widget build(BuildContext context) {
    String date = "${selectedDay.day.toString()}/${selectedDay.month.toString()}/${selectedDay.year.toString()}";
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => WriteDiaryPage(date: date, user: widget.user)));
        },
      ),
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              children: [
                TableCalendar(
                  //locale: defaultLocale,
                    focusedDay: selectedDay,
                    firstDay: DateTime(1990),
                    lastDay: DateTime(2050),
                  calendarFormat: format,
                  onFormatChanged: (CalendarFormat _format) {
                      setState(() {
                        format = _format;
                      });
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                  onDaySelected: (DateTime selectDay, DateTime focusDay) {
                      setState(() {
                        selectedDay = selectDay;
                        focusedDay = focusDay;
                      });
                  },
                  selectedDayPredicate: (DateTime date) {
                    return isSameDay(selectedDay, date);
                  },
                  calendarStyle: CalendarStyle(
                    isTodayHighlighted: true,
                    selectedDecoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle
                    ),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                    ),
                    todayDecoration: BoxDecoration(
                        color: Colors.deepPurple.shade200,
                        shape: BoxShape.circle
                    ),
                  ),
                  headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),

                ),

                /*Container(
                  child: Text(date),
                ),*/
            ]
          ),
        ),
      ),
    );
  }
}
