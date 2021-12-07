import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

//PANTALLA EN SETTINGS DE SOBRE LA APLICACIÓN
class AboutApp extends StatelessWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#000000"), HexColor("#341654")])),
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            backgroundColor: Colors.transparent,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 80, 25, 0),
                        child: Center(
                          child: Container(
                            child: Text('STELLARY es una aplicación creada para los usuarios que '
                                'quieran tener un espacio cómodo y amigable donde escribir su día a día, anotar ideas o cosas cotidianas para recordarlas, '
                                'tener todas las noticias de actualidad sobre los temas que te interesan de forma rápida y fácil e '
                                'incluso chatear con personas que compartan las mismas aficiones que tú.', style: GoogleFonts.varelaRound(fontSize: 18),),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 283),
                        child: Container(
                          width: 100,
                          height: 100,
                          child: Image.asset('assets/icontitle.png'),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )));
  }
}
