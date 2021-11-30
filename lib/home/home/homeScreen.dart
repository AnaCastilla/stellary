import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/home/diary/page/PageDiaryDetail.dart';
import 'package:diaryly/home/diary/page/WritePageDiary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  void initState() {
    super.initState();
    setState(() {
      getProfilePic(widget.user.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
    int showTodayRegisters = 0;
    String date =
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}";

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FutureBuilder(
          future: getUserNickname(widget.user.email!),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return SingleChildScrollView(
                  child: Center(
                      child: Column(children: [
                Column(
                  children: [
                    FutureBuilder<Object>(
                        future: getProfilePic(widget.user.email!),
                        builder: (context, pic) {
                          if (!pic.hasData) {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          } else {
                            return CircleAvatar(
                                radius: 90,
                                backgroundColor: Colors.transparent,
                                child: ClipOval(
                                  child: SizedBox(
                                    height: 200,
                                    width: 200,
                                    child: (pic.data.toString() != "")
                                        ? Image.network(pic.data.toString(),
                                            fit: BoxFit.cover)
                                        : Image.asset(
                                            "assets/avatar.png",
                                            fit: BoxFit.cover,
                                            color: Colors.white,
                                          ),
                                  ),
                                ));
                          }
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                      child: Text(
                        (snapshot.data.toString() == "")
                            ? widget.user.email!
                            : snapshot.data.toString(),
                        style: GoogleFonts.poiretOne(
                            fontSize: 35, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('diary')
                              .doc(widget.user.email)
                              .collection(widget.user.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                  avg) {
                            List<int> avgSum = [];

                            if (avg.data == null || !avg.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return avg.data!.docs.length == 0
                                  ? Container(
                                      margin: EdgeInsets.only(top: 30),
                                      alignment: Alignment.center,
                                    )
                                  : Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
                                          child: Text(
                                            "Tu puntuación media es de:",
                                            style: GoogleFonts.lato(
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Stack(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20.0),
                                              child: Center(
                                                child: Container(
                                                  width: 130,
                                                  height: 110,
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .deepPurple.shade100
                                                          .withOpacity(0.2),
                                                      shape: BoxShape.circle),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(top: 45),
                                                child: SizedBox(
                                                  width: 100,
                                                    height: 65,
                                                    child: ListView.builder(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        reverse: true,
                                                        itemCount:
                                                            avg.data!.docs.length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          int sum = 0;

                                                          DocumentSnapshot avgData =
                                                              avg.data!.docs[index];
                                                          avgSum.add(
                                                              avgData.get('score'));

                                                          for (int i = 0; i < avgSum.length; i++) {
                                                            sum += avgSum[i];
                                                          }

                                                          return Center(
                                                              child: Text(
                                                            avg.data!.docs.length != avgSum.length ? ''
                                                                : (sum / avgSum.length).toString().contains('.0')
                                                                    ? (sum / avgSum.length).toString().replaceAll('.0', '')
                                                                    : ((sum / avgSum.length).toString().length > 4
                                                                        ? (sum / avgSum.length).toString().substring(0, 3)
                                                                        : (sum / avgSum.length).toString()),
                                                            style: TextStyle(
                                                                fontSize: avg.data!.docs.length != avgSum.length ? 0 : 60),
                                                          ));
                                                        })),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                            }
                          }),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 40, left: 25),
                          child: Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                'Hoy ${DateTime.now().day} de ${getMonth(DateTime.now().month)}...',
                                style: GoogleFonts.amaticSc(
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              )),
                        ),
                      ],
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('diary')
                            .doc(widget.user.email!)
                            .collection(widget.user.uid)
                            .orderBy('hour', descending: true)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                                snapshot) {
                          return !snapshot.hasData
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 50),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height / 3,
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple.shade100
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: snapshot.data!.docs.length == 0
                                        ? Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 70.0),
                                              child: Container(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    ':(\n\nAún no has escrito nada',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        GoogleFonts.varelaRound(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .white
                                                                .withOpacity(
                                                                    0.2)),
                                                  )),
                                            ),
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              WriteDiaryPage(
                                                                  date: date,
                                                                  day: DateTime.now().day,
                                                                  weekDay: DateTime.now().weekday,
                                                                  month: DateTime.now().month,
                                                                  year: DateTime.now().year,
                                                                  user: widget.user)));
                                                },
                                                child: Text(
                                                    'Pulsa aquí para crear una página'))
                                          ])
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: showTodayRegisters!=0? snapshot.data!.docs.length : 1,
                                            itemBuilder: (context, index) {
                                              DocumentSnapshot diaryData = snapshot.data!.docs[index];
                                              if(date == diaryData.get('date')) {
                                                showTodayRegisters += 1;
                                                print('TODAY REGISTERS: ' + showTodayRegisters.toString());
                                              }
                                              return (showTodayRegisters == 0)?
                                              Column(children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 70.0),
                                                  child: Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        ':(\n\nHoy no has escrito nada',
                                                        textAlign: TextAlign.center,
                                                        style:
                                                        GoogleFonts.varelaRound(
                                                            fontSize: 20,
                                                            color: Colors
                                                                .white
                                                                .withOpacity(
                                                                0.2)),
                                                      )),
                                                ),
                                                TextButton(
                                                    onPressed: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  WriteDiaryPage(
                                                                      date: date,
                                                                      day: DateTime.now().day,
                                                                      weekDay: DateTime.now().weekday,
                                                                      month: DateTime.now().month,
                                                                      year: DateTime.now().year,
                                                                      user: widget.user)));
                                                    },
                                                    child: Text(
                                                        'Pulsa aquí para crear una página'))
                                              ]) :
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                PageDiaryDetail(
                                                                    date: diaryData
                                                                        .get('date'),
                                                                    day: diaryData
                                                                        .get('day'),
                                                                    hour: diaryData
                                                                        .get('hour'),
                                                                    weekDay: diaryData
                                                                        .get('weekday'),
                                                                    month: diaryData
                                                                        .get('month'),
                                                                    year: diaryData
                                                                        .get('year'),
                                                                    mood: diaryData
                                                                        .get('mood'),
                                                                    moodString: diaryData.get(
                                                                        'moodString'),
                                                                    title: diaryData
                                                                        .get('title'),
                                                                    content: diaryData
                                                                        .get('content'),
                                                                    score: diaryData.get('score'),)));

                                                  },
                                                  child: Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                                                      child:
                                                      (DateTime.now().day == diaryData.get('day') && DateTime.now().month == diaryData.get('month') && DateTime.now().year == diaryData.get('year'))?
                                                      Row(
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 8.0, right: 15),
                                                            child: Container(
                                                              padding: EdgeInsets.fromLTRB(4,8,8,8),
                                                              decoration: BoxDecoration(
                                                                color: Colors.purple.shade50.withOpacity(0.3),
                                                                borderRadius: BorderRadius.circular(15)
                                                              ),
                                                                child: (DateTime.now().day == diaryData.get('day') && DateTime.now().month == diaryData.get('month') && DateTime.now().year == diaryData.get('year'))? Text(diaryData.get('hour').toString().substring(10, 16), style: GoogleFonts.encodeSans(fontSize: 25),) : Text('', style: TextStyle(fontSize:0))
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 8.0, right: 15),
                                                            child: Container(
                                                              child: (DateTime.now().day == diaryData.get('day') && DateTime.now().month == diaryData.get('month') && DateTime.now().year == diaryData.get('year'))?
                                                              diaryData.get('title').toString() == '' ? Text('Sin título', style: GoogleFonts.khand(fontSize: 25, color: Colors.white.withOpacity(0.3))) :
                                                              diaryData.get('title').toString().length > 20 ? Text(diaryData.get('title').toString().substring(0, 20) + '...', style: GoogleFonts.khand(fontSize: 25),) :
                                                              Text(diaryData.get('title'), style: GoogleFonts.khand(fontSize: 25)) : Text('', style: TextStyle(fontSize:0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ) : Container(),
                                                    ),
                                                  ],
                                              ),
                                                );
                                            },
                                          ),
                                  ));
                        }),
                  ],
                ),
              ])));
            }
          }),
    );
  }
}

Future<String> getUserNickname(String email) async {
  var name;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .get()
      .then((res) => {name = res.data()!['nickname'].toString()});

  return name;
}

Future<String> getProfilePic(String email) async {
  var pic;
  await FirebaseFirestore.instance
      .collection('usuarios')
      .doc(email)
      .get()
      .then((res) => {pic = res.data()!['profilePic'].toString()});

  return pic;
}

String? getMonth(int numMonth) {
  switch (numMonth) {
    case 1:
      return 'Enero';
    case 2:
      return 'Febrero';
    case 3:
      return 'Marzo';
    case 4:
      return 'Abril';
    case 5:
      return 'Mayo';
    case 6:
      return 'Junio';
    case 7:
      return 'Julio';
    case 8:
      return 'Agosto';
    case 9:
      return 'Septiembre';
    case 10:
      return 'Octubre';
    case 11:
      return 'Noviembre';
    case 12:
      return 'Diciembre';
  }
}
