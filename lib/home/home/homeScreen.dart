import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/home/diary/page/PageDiaryDetail.dart';
import 'package:diaryly/home/diary/page/WritePageDiary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//PANTALLA DE HOME, LA QUE SE VE NADA MÁS INICIAR SESIÓN EN LA APP
//MUESTRA LA FOTO DE PERFIL, EL NOMBRE DE USUARIO, LA PUNTUACIÓN MEDIA QUE SE HAYA REGISTRADO
//DE TODAS LAS PÁGINAS DE DIARIO (si aún no ha escrito ninguna no aparece) Y LOS REGISTROS
//QUE SE HAYAN CREADO EL DÍA DE HOY
class HomeScreen extends StatefulWidget {
  final User user;

  HomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List todayRegisters = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      getProfilePic(widget.user.email!);
    });
  }

  @override
  Widget build(BuildContext context) {
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
                            return Stack(
                              children: [
                                Padding(
                                  padding: pic.data.toString() != ""? EdgeInsets.only(left: 9, top: 20) : EdgeInsets.only(left: 25, top: 55),
                                  child: CircleAvatar(
                                      radius: pic.data.toString() != ""? 90 : 72,
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
                                                ),
                                        ),
                                      )),
                                ),
                                Container(
                                  width: 200,
                                  height:200,
                                  child: Image.asset(
                                    "assets/400.png",
                                    fit: BoxFit.cover,),
                                ),
                              ],
                            );
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
                          builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> avg) {
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
                                                padding: const EdgeInsets.only(top: 47),
                                                child: SizedBox(
                                                  width: 200,
                                                    height: 63,
                                                    child: ListView.builder(
                                                        physics: NeverScrollableScrollPhysics(),
                                                        reverse: true,
                                                        itemCount: avg.data!.docs.length,
                                                        itemBuilder: (context, index) {
                                                          int sum = 0;

                                                          DocumentSnapshot avgData = avg.data!.docs[index];
                                                          avgSum.add(avgData.get('score'));

                                                          for (int i = 0; i < avgSum.length; i++) {
                                                            sum += avgSum[i];
                                                          }

                                                          return avg.data!.docs.length != avgSum.length ? Container() :
                                                           Padding(
                                                            padding: sum / avgSum.length == 10? EdgeInsets.only(left:65) :
                                                            !(sum / avgSum.length).toString().contains('.0')? EdgeInsets.only(left:58): EdgeInsets.only(left:83.5),
                                                            child: Text(
                                                              (sum / avgSum.length).toString().contains('.0') ?
                                                              (sum / avgSum.length).toString().replaceAll('.0', '') :
                                                              (sum / avgSum.length).toString().length > 3?
                                                              (sum / avgSum.length).toStringAsFixed(1) :
                                                              (sum / avgSum.length).toString(),
                                                              style: TextStyle(
                                                              fontSize: avg.data!.docs.length != avgSum.length ? 0 : 60),
                                                            ),
                                                          );
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
                        builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                          return !snapshot.hasData
                              ? CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25, right: 25, bottom: 50),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /  4,
                                    decoration: BoxDecoration(
                                        color: Colors.deepPurple.shade100
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(5)),
                                    child: snapshot.data!.docs.length == 0
                                        ? Column(children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 40.0),
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
                                                    'Pulsa aquí para crear tu primera página'))
                                          ])
                                        : ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: todayRegisters.length == 0? 1 : snapshot.data!.docs.length,
                                            itemBuilder: (context, index) {

                                              DocumentSnapshot diaryData = snapshot.data!.docs[index];
                                              if(diaryData.get('date') == date) {
                                                todayRegisters.add(1);
                                              }

                                              return todayRegisters.length == 0?
                                              Column(children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(
                                                      top: 40.0),
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
                                                      (diaryData.get('date') == date)?
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
                                                                child: (diaryData.get('date') == date)? Text(diaryData.get('hour').toString().substring(10, 16), style: GoogleFonts.encodeSans(fontSize: 25),) : Text('', style: TextStyle(fontSize:0))
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.only(top: 8.0, right: 15),
                                                            child: Container(
                                                              child: (diaryData.get('date') == date)?
                                                              diaryData.get('title').toString() == '' ? Text('Sin título', style: GoogleFonts.khand(fontSize: 25, color: Colors.white.withOpacity(0.3))) :
                                                              diaryData.get('title').toString().length > 20 ? Text(diaryData.get('title').toString().substring(0, 20) + '...', style: GoogleFonts.khand(fontSize: 25),) :
                                                              Text(diaryData.get('title'), style: GoogleFonts.khand(fontSize: 25)) : Text('', style: TextStyle(fontSize:0)),
                                                            ),
                                                          ),
                                                        ],
                                                      ) : Container()
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

//Retorna el String del mes del número introducido por parámetro
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
