import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

//PANTALLA EN SETTINGS DE SOBRE MÍ
class AboutMe extends StatelessWidget {
  const AboutMe({Key? key}) : super(key: key);

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
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: [
                                Text('Este proyecto ha sido desarrollado por:  ', style: GoogleFonts.varelaRound(fontSize: 18),),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                                  child: Text('Ana Castilla Fernández ', style: GoogleFonts.lato(fontSize: 26, fontStyle: FontStyle.italic,),),
                                ),
                                Text('como Trabajo de Fin de Grado de los estudios de Grado Superior de Desarrollo de Aplicaciones Multiplataforma'
                                    ' en el instituto I.E.S Saladillo en Algeciras (Cádiz).', style: GoogleFonts.varelaRound(fontSize: 18))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, top: 310),
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