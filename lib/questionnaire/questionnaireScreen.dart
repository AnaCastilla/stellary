import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/categories/categories.dart';
import 'package:diaryly/dialog/createDialog.dart';
import 'package:diaryly/home/Home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Questionnaire extends StatefulWidget {
  final User user;

  Questionnaire({Key? key, required this.user}) : super(key: key);

  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  late TextEditingController nickname;
  final GlobalKey<FormState> _nicknameFormKey = GlobalKey<FormState>();
  List<String> selectedCategories = [];
  List<Category> categories = [
    Category("Música", false),
    Category("Deporte", false),
    Category("Actividades al aire libre", false),
    Category("Tecnología", false),
    Category("E-Sports y gaming", false),
    Category("Actualidad", false),
    Category("Política", false),
    Category("Cine", false),
    Category("Alimentación", false),
    Category("Fitness", false),
    Category("Ciencia", false),
    Category("Salud", false),
    Category("Moda y belleza", false),
    Category("Animales", false),
    Category("Arte y cultura", false),
    Category("Libros y literatura", false),
    Category("Astrología", false),
    Category("Anime y manga", false),
    Category("Profesiones", false),
    Category("Programación", false),
    Category("Viajes", false),
    Category("Universo", false),
  ];

  initState() {
    nickname = new TextEditingController();
    super.initState();
  }

  String? nicknameValidator(String? value) {
    if (value!.length < 3 && value.length != 0) {
      return 'Nickname demasiado corto';
    } else if (value.length > 15) {
      return 'Nickname demasiado largo';
    } else if(value.length == 0 || value.isEmpty) {
      return 'Introduce un nickname';
    } else {
      return null;
    }
  }

  void _onCategorySelected(bool selected, categoryName) {
    if (selected == true) {
      setState(() {
        selectedCategories.add(categoryName);
      });
    } else {
      setState(() {
        selectedCategories.remove(categoryName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPopScope,
      child: Scaffold(
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
                              ...categories
                                  .map((category) => CategoryWidget(
                                      category: category,
                                      onSelected: (selected) {
                                        setState(() {
                                          _onCategorySelected(selected!, category.name);
                                          category.selected = selected;
                                          print(selectedCategories);
                                        });
                                      }))
                                  .toList(),
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
                                Text("¡Ponte un nickname!",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.badScript(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                              child: Form(
                                key: _nicknameFormKey,
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
                            ),
                            Padding(
                                padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.fromLTRB(60, 20, 60, 20),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(10.0)),
                                    primary: Colors.purple.shade900,
                                    onPrimary: Colors.white,
                                  ),
                                  onPressed: () async {
                                    if (_nicknameFormKey.currentState!.validate()) {
                                      createNickname(widget.user.email!, nickname.text);
                                      saveCategoriesInFirestore(widget.user.email!, selectedCategories);
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  Home(user: widget.user)));
                                    }
                                  },
                                  child: Text("Continuar",
                                      style: GoogleFonts.varelaRound())),
                                )
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          )),
    );
  }

  Future<bool> _onWillPopScope() {
    CreateDialog dialog = CreateDialog();
    return dialog.createDialogToLogin("¿Seguro que quieres ir hacia atrás?", context);
  }
}

Future<void> createNickname(String email, String nickname) async {
  CollectionReference user = FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).set({"nickname": nickname}, SetOptions(merge:true));

  return;
}

Future<void> saveCategoriesInFirestore(String email, List categoriesList) async {
  CollectionReference user = FirebaseFirestore.instance.collection('usuarios');
  user.doc(email).set({"categories":categoriesList}, SetOptions(merge:true));

  return;
}




