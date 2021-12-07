import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/home/diary/page/EditDiaryPage.dart';
import 'package:diaryly/home/diary/page/WritePageDiary.dart';
import 'package:diaryly/provider/MyProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

//PANTALLA DE DIARIO, SE MUESTRA TODAS LAS PÁGINAS QUE EL USUARIO HA CREADO
//Y UN CALENDARIO CON LOS REGISTROS DE LAS PÁGINAS SI EL USUARIO REGISTRÓ CÓMO SE SENTÍA (LAS CARITAS)
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

  @override
  Widget build(BuildContext context) {
    String date =
        "${selectedDay.day.toString()}/${selectedDay.month.toString()}/${selectedDay.year.toString()}";
    return Consumer<MyProvider>(builder: (context, prov, child) {
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple.shade400,
          child: Icon(Icons.add_outlined, color: Colors.white,),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => WriteDiaryPage(
                    date: date,
                    day: selectedDay.day,
                    weekDay: selectedDay.weekday,
                    month: selectedDay.month,
                    year: selectedDay.year,
                    user: widget.user)));
          },
        ),
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Center(
            child: Column(children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    prov.changeView();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: prov.vista
                        ? Icon(
                            Icons.list,
                            color: Colors.white,
                          )
                        : Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.white,
                          ),
                  ),
                ),
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
                    if (!prov.vista) {
                      return !snapshot.hasData
                          ? CircularProgressIndicator()
                          : snapshot.data!.docs.length == 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 229),
                                  alignment: Alignment.center,
                                  child: Text(':(\n\nAún no hay registros',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.varelaRound(
                                          fontSize: 27,
                                          color: Colors.white.withOpacity(0.5))))
                              : Column(children: [
                                  ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: snapshot.data!.docs.length,
                                    itemBuilder: (context, index) {
                                      DocumentSnapshot diaryData =
                                          snapshot.data!.docs[index];
                                      print(snapshot.data!.docs.length);
                                      return Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
                                              child: Dismissible(
                                                key: UniqueKey(),
                                                direction: DismissDirection.startToEnd,
                                                background: Container(
                                                    alignment: Alignment.centerLeft,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red.withOpacity(0.6),
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(left: 15.0),
                                                      child: Icon(
                                                          Icons.delete_forever),
                                                    )),
                                                onDismissed: (DismissDirection
                                                    direction) {
                                                  if (direction == DismissDirection.startToEnd) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            'Página eliminada');
                                                  }

                                                  setState(() async {
                                                    CollectionReference
                                                        collection =
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection('diary')
                                                            .doc(widget
                                                                .user.email!)
                                                            .collection(widget
                                                                .user.uid);
                                                    var snapshots = await collection
                                                        .where('title',
                                                            isEqualTo: diaryData
                                                                .get('title'))
                                                        .where('content',
                                                            isEqualTo: diaryData
                                                                .get('content'))
                                                        .where('date',
                                                            isEqualTo: diaryData
                                                                .get('date'))
                                                        .where('hour',
                                                            isEqualTo: diaryData
                                                                .get('hour'))
                                                        .get();
                                                    for (var doc
                                                        in snapshots.docs) {
                                                      await doc.reference
                                                          .delete();
                                                    }
                                                  });
                                                },
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Navigator.of(context).push(MaterialPageRoute(
                                                        builder: (context) => EditDiaryPage(
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
                                                            mood: diaryData.get(
                                                                'moodString'),
                                                            title: diaryData
                                                                .get('title'),
                                                            content: diaryData
                                                                .get('content'),
                                                            score: diaryData.get('score'),
                                                            user: widget.user)));
                                                  },
                                                  child: Container(
                                                    height: 100,
                                                    width: MediaQuery.of(context).size.width,
                                                    decoration: BoxDecoration(
                                                        color: Colors.purple[50]!.withOpacity(0.4)),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 10.0, top: 18),
                                                              child: Text(diaryData.get('day').toString(), style: GoogleFonts.varelaRound(fontSize: 25),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only( left: 17.0,top: 5),
                                                              child: Text(
                                                                getDayOfWeek(
                                                                    diaryData.get(
                                                                        'weekday')),
                                                                style: GoogleFonts
                                                                    .varelaRound(
                                                                        fontSize:
                                                                            13),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 18, top: 5),
                                                              child: Text(diaryData.get('year').toString(), style: GoogleFonts.varelaRound(fontSize: 10),
                                                              ),
                                                            )

                                                          ],
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 22.0),
                                                          child: Align(
                                                              alignment: Alignment.topLeft,
                                                              child: diaryData.get('month').toString().length < 2?
                                                              Text(
                                                                '/0${diaryData.get('month')}',
                                                                style: GoogleFonts.varelaRound(fontSize: 8),
                                                              ) :
                                                              Text(
                                                                '/${diaryData.get('month')}',
                                                                style: GoogleFonts.varelaRound(fontSize: 8),
                                                              )),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                                          child:
                                                              VerticalDivider(),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(top: 15.0, left: 8),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              diaryData.get('title').toString().length > 24 ?
                                                              Text(
                                                                  diaryData.get('title').toString().substring(0, 24) + "...",
                                                                      textAlign: TextAlign.left,
                                                                      style: GoogleFonts.quicksand(fontSize: 19, fontWeight: FontWeight.bold))
                                                                  : Text(
                                                                      diaryData.get('title'), style: GoogleFonts.quicksand(fontSize: 19, fontWeight: FontWeight.bold)),

                                                              diaryData.get('content').toString().length > 63
                                                                  ? Padding(
                                                                      padding: const EdgeInsets.only(top: 6.0),
                                                                      child: SizedBox(
                                                                          width: 230,
                                                                          height: 34,
                                                                          child: Text(diaryData.get('content').substring(0, 63) + "...",)
                                                                      ),
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets.only(top: 6.0),
                                                                      child: SizedBox(
                                                                          width: 230,
                                                                          height: 34,
                                                                          child: Text(diaryData.get('content'))),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]);
                                    },
                                  )
                                ]);
                    } else {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      } else {
                        return Column(children: [
                          TableCalendar(
                            locale: 'es_ES',
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
                            onDaySelected:
                                (DateTime selectDay, DateTime focusDay) {
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
                                  shape: BoxShape.circle),
                              selectedTextStyle: TextStyle(
                                color: Colors.white,
                              ),
                              todayDecoration: BoxDecoration(
                                  color: Colors.deepPurple.shade200,
                                  shape: BoxShape.circle),
                            ),
                            headerStyle: HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true),
                          ),
                          snapshot.data!.docs.length == 0
                              ? Container(
                                  margin: EdgeInsets.only(top: 60),
                                  alignment: Alignment.center,
                                  child: Text(':(\n\nAún no hay registros',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.varelaRound(
                                          fontSize: 27,
                                          color: Colors.white.withOpacity(0.5))))
                              : Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 260,
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(
                                          parent: AlwaysScrollableScrollPhysics()),
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot diaryData =
                                            snapshot.data!.docs[index];

                                        return (diaryData.get('mood') == "")
                                            ? Container()
                                            : Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10.0),
                                                    color: Colors.white.withOpacity(0.2),
                                                  ),
                                                  child: Row(children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Container(
                                                        alignment: Alignment.centerLeft,
                                                        child: SizedBox(
                                                          width: 30,
                                                          height: 30,
                                                          child: (diaryData.get('mood') == "")
                                                              ? Container()
                                                              : Image.asset(
                                                                  diaryData.get('mood'), color: Colors.white,
                                                                ),
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 15.0),
                                                      child: Container(
                                                          alignment: Alignment.center,
                                                          child: Text(diaryData.get('date'),
                                                              style: GoogleFonts.varelaRound(fontSize: 15))),
                                                    ),
                                                    //la fecha, al no tener ceros si el día o el mes es menor de 10,
                                                    // le añado más padding para que quede alineado con los que sí son >10
                                                    diaryData.get('date').toString().length < 9?
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 125.0),
                                                      child: Container(
                                                          child: Text('Puntuación: ', style: GoogleFonts.varelaRound(fontSize: 15))),
                                                    ) : Padding(
                                                      padding: const EdgeInsets.only(left: 105.0),
                                                      child: Container(
                                                          child: Text(
                                                              'Puntuación: ',
                                                              style: GoogleFonts.varelaRound(fontSize: 15))),
                                                    ),
                                                    Container(
                                                        child: Text(
                                                            diaryData.get('score').toString(),
                                                            style: GoogleFonts.varelaRound(fontSize: 15)))
                                                  ]),
                                                ),
                                              );
                                      }),
                                ),
                        ]);
                      }
                    }
                  }),
            ]),
          ),
        ),
      );
    });
  }
}

//Retorna el String del día de la semana que se introduzca por parámetro
getDayOfWeek(int day) {
  switch (day) {
    case 1:
      return 'lun.';
    case 2:
      return 'mar.';
    case 3:
      return 'mié.';
    case 4:
      return 'jue.';
    case 5:
      return 'vie.';
    case 6:
      return 'sáb.';
    case 7:
      return 'dom.';
  }
}
