import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diaryly/categories/categories.dart';
import 'package:diaryly/profile/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


//CUESTIONARIO EDITABLE, ESTÁ EN LA PANTALLA DE PERFIL HACIENDO CLICK EN "Cambiar intereses"
class QuestionnaireEdit extends StatefulWidget {
  final User user;

  const QuestionnaireEdit({Key? key, required this.user}) : super(key: key);

  @override
  _QuestionnaireEditState createState() => _QuestionnaireEditState();
}

class _QuestionnaireEditState extends State<QuestionnaireEdit> {
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
    super.initState();
  }

  //Actualiza las nuevas categorías elegidas en la base de datos
  Future<void> updateCategoriesInFirestore(
      String email, List categoriesList, BuildContext context) async {
    CollectionReference user = FirebaseFirestore.instance.collection('usuarios');
    user.doc(email).update({"categories": categoriesList});

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Profile(user: widget.user)),
    ).then((value) => setState(() {}));
  }

  //Cuando se selecciona una categoría, la mete en la lista de las categorías seleccionadas,
  // y cuando la deselecciona, la elimina
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
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Center(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
              SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 50),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...categories
                                .map((category) => CategoryWidget(
                                    category: category,
                                    onSelected: (selected) {
                                      setState(() {
                                        _onCategorySelected(
                                            selected!, category.name);
                                        category.selected = selected;
                                        print(selectedCategories);
                                      });
                                    }))
                                .toList(),
                          ]))),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                              updateCategoriesInFirestore(
                                  widget.user.email!, selectedCategories, context);
                              //Navigator.of(context).pop();
                            },
                            child: Text("Continuar",
                                style: GoogleFonts.varelaRound())),
                      )
                    ],
                  ),
                ),
              )
            ]))));
  }
}


