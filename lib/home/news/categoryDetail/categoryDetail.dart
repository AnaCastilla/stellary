import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryDetail extends StatelessWidget {
  final String categoryName;

  const CategoryDetail({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#000000"), HexColor("#200A37")])),
        child: Container(
          child: Column(children: [
            TextButton(
              onPressed: () => launchURL('https://jenesaispop.com'),
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text('sadasdasdasfasf'),
              ),
            )
          ]),
        ));
  }
}

getNewsFromCategory(String categoryName) async {
  switch (categoryName) {
    case 'Música':
      return Container(
        child: Column(children: [
          TextButton(
            onPressed: launchURL('https://jenesaispop.com'),
            child: Text('1'),
          )
        ]),
      );
    case 'Deportes':
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

launchURL(url) async {
  print(url);
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
