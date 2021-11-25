import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class WriteDiaryPage extends StatefulWidget {
  final String date;
  final User user;
  final int day, weekDay, month, year;

  WriteDiaryPage(
      {Key? key,
      required this.date,
      required this.user,
      required this.day,
      required this.weekDay,
      required this.month,
      required this.year})
      : super(key: key);

  @override
  _WriteDiaryPageState createState() => _WriteDiaryPageState();
}

class _WriteDiaryPageState extends State<WriteDiaryPage> {
  DateTime selectedDate = DateTime.now();

  bool changeDate = false;
  String moodSelected = "", moodImagePath = "";
  int score = 0;
  final GlobalKey<FormState> _writePageFormKey = GlobalKey<FormState>();
  TextEditingController titleController = new TextEditingController();
  TextEditingController contentController = new TextEditingController();

  void _incrementScore() {
    setState(() {
      if (score != 10) {
        score++;
      }
    });
  }

  void _decrementScore() {
    setState(() {
      if (score <= 0) {
        score = 0;
      } else {
        score--;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print('CHANGE DATE $changeDate');
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String date = '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';

    _selectDate(BuildContext context) async {
      final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2010),
        lastDate: DateTime(2050),

      );
      if (selected != null && selected != selectedDate)
        setState(() {
          selectedDate = selected;
        });
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#000000"), HexColor("#341654")])),
        child: SingleChildScrollView(
          child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, top: 70.0),
                      child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              changeDate = true;
                              print('CHANGE DATE $changeDate');
                              _selectDate(context);
                              print(date);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent
                          ),
                          child: changeDate==false?
                          Text(widget.date,
                            style: GoogleFonts.cuprum(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ): selectedDate == DateTime.now()?
                          Text(widget.date,
                            style: GoogleFonts.cuprum(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            ),
                          ):
                          Text(date,
                            style: GoogleFonts.cuprum(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Text('¿Cómo te sientes?',
                        style: GoogleFonts.varelaRound(fontSize: 20)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Image.asset(
                              'assets/faces/superfeliz.png',
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                moodImagePath = 'assets/faces/superfeliz.png';
                                moodSelected = 'Súperfeliz';
                              });

                              print('superfeliz');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Image.asset(
                              'assets/faces/feliz.png',
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                moodImagePath = 'assets/faces/feliz.png';
                                moodSelected = 'Feliz';
                              });

                              print('feliz');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Image.asset(
                              'assets/faces/aburrido.png',
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                moodImagePath = 'assets/faces/aburrido.png';
                                moodSelected = 'Rar@';
                              });

                              print('raro');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Image.asset(
                              'assets/faces/neutral.png',
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                moodImagePath = 'assets/faces/neutral.png';
                                moodSelected = 'Neutral';
                              });

                              print('neutral');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Image.asset(
                              'assets/faces/triste.png',
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                moodImagePath = 'assets/faces/triste.png';
                                moodSelected = 'Triste';
                              });

                              print('triste');
                            },
                          ),
                        ),
                        SizedBox(
                          height: 50,
                          width: 50,
                          child: InkWell(
                            child: Image.asset(
                              'assets/faces/llorando.png',
                              color: Colors.white,
                            ),
                            onTap: () {
                              setState(() {
                                moodImagePath = 'assets/faces/llorando.png';
                                moodSelected = 'Horrible';
                              });
                              print('llorando');
                              print('FECHA WIDGET: ${widget.date} //// FECHA AHORA: ${date}');
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Center(
                    child: Container(
                      child: (moodSelected == "")
                          ? Text("")
                          : Text(
                        moodSelected,
                        style: GoogleFonts.varelaRound(fontSize: 20),
                      ),
                    ),
                  ),
                  Form(
                      key: _writePageFormKey,
                      child: Column(children: [
                        Container(
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                            controller: titleController,
                            cursorColor: Colors.white38,
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                        color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70.withOpacity(0.35)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintText: 'Título',
                                fillColor: Colors.white70.withOpacity(0.35)),
                          ),
                        ),
                        Container(
                          height: 500,
                          margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                          child: TextFormField(
                            controller: contentController,
                            cursorColor: Colors.white38,
                            keyboardType: TextInputType.multiline,
                            maxLines: 100,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                    borderSide: BorderSide(
                                        color: Colors.black.withOpacity(0.1))),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white70.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                filled: true,
                                hintText: '¿Cómo fue tu día?',
                                fillColor: Colors.white70.withOpacity(0.35)),
                          ),
                        ),
                      ])),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 20, 0, 20),
                      child: Text('Puntuación:',
                          style: GoogleFonts.varelaRound(fontSize: 15)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10, bottom: 10),
                      child: Column(children: [
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: TextButton(
                            child: Icon(
                              Icons.arrow_drop_up,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _incrementScore();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                          width: 30,
                          child: TextButton(
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              _decrementScore();
                            },
                          ),
                        ),
                      ]),
                    ),
                    Text('$score ',
                        style: GoogleFonts.varelaRound(fontSize: 20)),
                    Text('/ 10', style: GoogleFonts.varelaRound(fontSize: 20)),
                  ]),
                  Padding(
                      padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                          shape: RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          primary: Colors.purple.shade900,
                          onPrimary: Colors.white,
                        ),
                        onPressed: () async {
                          changeDate == false? createDiaryPageCollection(
                              widget.user.uid,
                              widget.user.email!,
                              widget.date,
                              widget.day,
                              widget.weekDay,
                              widget.month,
                              widget.year,
                              selectedDate,
                              moodSelected,
                              moodImagePath,
                              titleController.text,
                              contentController.text,
                              score) :
                          createDiaryPageCollection(
                              widget.user.uid,
                              widget.user.email!,
                              date,
                              selectedDate.day,
                              selectedDate.weekday,
                              selectedDate.month,
                              selectedDate.year,
                              selectedDate,
                              moodSelected,
                              moodImagePath,
                              titleController.text,
                              contentController.text,
                              score);

                          Navigator.of(context).pop();
                        },
                        child: Text(
                            'Guardar', style: GoogleFonts.varelaRound()),
                      ))
                ],
              )),
        ),
      ),
    );
  }
}

Future<void> createDiaryPageCollection(
    String uid,
    String email,
    String date,
    int day,
    int weekday,
    int month,
    int year,
    DateTime selectedDate,
    String moodString,
    String mood,
    String title,
    String content,
    int score) async {
  DateFormat formatter = new DateFormat("yyyy-MM-dd HH:mm:ss");

  CollectionReference diary = FirebaseFirestore.instance.collection('diary');
  diary.doc(email).collection(uid).doc().set({
    "author": email,
    "hour": formatter.format(selectedDate),
    "date": date,
    "moodString": moodString,
    "mood": mood,
    "weekday": weekday,
    "day": day,
    "month": month,
    "year": year,
    "title": title,
    "content": content,
    "score": score
  });

  return;
}


