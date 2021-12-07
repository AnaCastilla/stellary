import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

//EN LA PANTALLA HOME, AL HACER CLICK SOBRE UN REGISTRO DE HOY, MUESTRA EL DETALLE DE DICHO REGISTRO
//Esta es la clase que muestra dicho detalle
class PageDiaryDetail extends StatefulWidget {
  final String date;
  final int day, weekDay, month, year;
  int? score;
  String? mood, moodString, title, content, hour;

  PageDiaryDetail({
    Key? key,
    required this.date,
    this.hour,
    required this.day,
    required this.weekDay,
    required this.month,
    required this.year,
    this.mood,
    this.moodString,
    this.title,
    this.content,
    this.score,
  }) : super(key: key);

  @override
  _PageDiaryDetail createState() => _PageDiaryDetail();
}

class _PageDiaryDetail extends State<PageDiaryDetail> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: MediaQuery.of(context).size.height,
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
                      child:
                      Text(widget.date,
                        style: GoogleFonts.cuprum(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ),
                  ),
                  widget.mood == '' ?
                      Text('') :
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Text('Me siento...',
                            style: GoogleFonts.varelaRound(fontSize: 20)),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Image.asset(widget.mood.toString(), color: Colors.white,),
                              ),
                              Text(widget.moodString.toString(), style: GoogleFonts.varelaRound(fontSize: 20))
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(children: [
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: TextField(
                        readOnly: true,
                        cursorColor: Colors.white38,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.white70.withOpacity(0.35)),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            filled: true,
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: (widget.title.toString() != "")
                                ? '${widget.title.toString()}'
                                : '',
                            fillColor: Colors.white70.withOpacity(0.35)),
                      ),
                    ),
                    Container(
                      height: 500,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                      child: TextField(
                        readOnly: true,
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
                            hintStyle: TextStyle(color: Colors.white),
                            hintText: widget.content,
                            fillColor: Colors.white70.withOpacity(0.35)),
                      ),
                    ),
                  ]),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 20, 0, 20),
                      child: Text('Puntuación:',
                          style: GoogleFonts.varelaRound(fontSize: 15)),
                    ),
                    Text(' ${widget.score.toString()}', style: GoogleFonts.varelaRound(fontSize: 20)),
                  ]),
                ],
              )),
        ),
      ),
    );
  }
}