import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'categoryDetail/categoryDetail.dart';

//PANTALLA DE NOTICIAS, es donde se muestra todas las categorías de interés con una imagen asignada
//a cada una y puedes hacer click para acceder a su detalle (categoryDetail.dart)
class NewsScreen extends StatefulWidget {
  final User user;

  const NewsScreen({Key? key, required this.user}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usuarios')
              .doc(widget.user.email!)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            List<dynamic> values;
            if (snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            } else {
              values = snapshot.data!.get('categories');
              return values.length == 0
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          alignment: Alignment.center,
                          child: Text(':(\n\n No hay categorías para mostrar',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.varelaRound(
                                  fontSize: 27,
                                  color: Colors.white.withOpacity(0.5)))
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 21),
                        child: Container(
                            alignment: Alignment.center,
                            child: Text('Dirígete a tu perfil para cambiar tus intereses y habilitar esta sección',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.varelaRound(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.5)))
                        ),
                      ),
                    ],
                  )
                  : !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                          child: ListView.builder(
                              itemCount: values.length,
                              itemBuilder: (context, index) {
                                return getCategoriesList(context,
                                    snapshot.data!.get('categories')[index]);
                              }));
            }
          }),
    );
  }
}

//Widget que devuelve la lista de las categorías que el usuario tenga,
//con la imagen representativa y el nombre, y se puede hacer click para acceder con detalle a dicha categoría
Widget getCategoriesList(BuildContext context, String categoryName) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetail(categoryName: categoryName),
          ));
    },
    child: Container(
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Image.asset('assets/categories/${categoryPhoto(categoryName)}',
              fit: BoxFit.cover,
              height: 150,
              width: MediaQuery.of(context).size.width),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(categoryName,
                style: GoogleFonts.bungeeHairline(
                    fontSize: 25, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    ),
  );
}

//Función que devuelve el nombre de la imagen dependiendo del nombre de cada categoría
categoryPhoto(String categoryName) {
  switch (categoryName) {
    case 'Música':
      return 'music.jpg';
    case 'Deporte':
      return 'sports.jpg';
    case 'Actividades al aire libre':
      return 'activities.jpg';
    case 'Tecnología':
      return 'tech.jpg';
    case 'E-Sports y gaming':
      return 'esports.jpg';
    case 'Actualidad':
      return 'actuality.jpg';
    case 'Política':
      return 'politics.jpg';
    case 'Cine':
      return 'cinema2.jpg';
    case 'Alimentación':
      return 'alimentacion.jpg';
    case 'Fitness':
      return 'fitness.jpg';
    case 'Ciencia':
      return 'science.jpg';
    case 'Salud':
      return 'health.jpg';
    case 'Moda y belleza':
      return 'fashionbeauty.jpg';
    case 'Eventos':
      return 'events.jpg';
    case 'Animales':
      return 'animals.jpg';
    case 'Arte y cultura':
      return 'artculture.jpg';
    case 'Libros y literatura':
      return 'books.jpg';
    case 'Astrología':
      return 'astrology.jpg';
    case 'Anime y manga':
      return 'animemanga.jpg';
    case 'Profesiones':
      return 'professions.jpg';
    case 'Programación':
      return 'programming.jpg';
    case 'Viajes':
      return 'travels.jpg';
    case 'Universo':
      return 'universe.jpg';
  }
}
