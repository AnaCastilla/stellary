import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/categories/categories.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Questionnaire extends StatefulWidget {
  late User user;

  Questionnaire({Key? key, User? user}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late TextEditingController nickname;
  late String email;
  List<Category> category = [
    Category("Música", false),
    Category("Deportes", false),
    Category("Actividades al aire libre", false),
    Category("Tecnología", false),
    Category("E-Sports", false),
    Category("Gaming", false),
    Category("Actualidad", false),
    Category("K-Pop", false),
    Category("Política", false),
    Category("Cine", false),
    Category("Alimentación", false),
    Category("Fitness", false),
    Category("Ciencia", false),
    Category("Salud", false),
    Category("Moda y belleza", false),
    Category("Eventos", false),
    Category("Animales", false),
    Category("Arte y cultura", false),
    Category("Libros y literatura", false),
    Category("Astrología", false),
    Category("Anime y manga", false),
    Category("Profesiones", false),
    Category("Programación", false),
    Category("Viajes", false),
  ];

  initState() {
    nickname = new TextEditingController();
    email = auth.currentUser!.email.toString();
    super.initState();
  }

  String? nicknameValidator(String? value) {
    if (value!.length < 3) {
      return 'Nickname demasiado corto';
    } else if (value.length > 15) {
      return 'Nickname demasiado largo';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? args = ModalRoute.of(context)!.settings.arguments as String?;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 70, bottom: 15),
                      child: Text("Cuéntanos sobre tus gustos...",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.badScript(
                              fontSize: 35, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...category
                                .map((category) => CategoryWidget(
                                    category: category,
                                    onSelected: (value) {
                                      setState(() {
                                        category.selected = value!;
                                      });
                                    }))
                                .toList()
                          ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("¿Quieres ponerte un nickname?",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.badScript(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                            child: TextFormField(
                              controller: nickname,
                              validator: nicknameValidator,
                              cursorColor: Colors.white38,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color:
                                            Colors.white70.withOpacity(0.35)),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  prefixIcon: Icon(Icons.tag_faces_outlined,
                                      color: Colors.white),
                                  filled: true,
                                  hintText: "Nickname",
                                  fillColor: Colors.white70.withOpacity(0.35)),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(10.0)),
                                  primary: Colors.deepPurple[800],
                                  onPrimary: Colors.white,
                                ),
                                onPressed: () async {
                                  print(args);
                                  if (nickname.text.isNotEmpty) {
                                    createNickname(args![1], nickname.text);
                                  } else {
                                    createNickname(args![1], "");
                                  }

                                },
                                child: Text("Continuar"),
                              ))
                        ],
                      ),
                    ),
                  )
                ]),
          ),
        ));
  }
}

Future<void> createNickname(String email, String nickname) async {
  CollectionReference user = FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).set({"nickname": nickname});

  return;
}
