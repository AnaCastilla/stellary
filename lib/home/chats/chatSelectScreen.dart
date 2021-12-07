import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'chatScreen.dart';

//PANTALLA DONDE SELECCIONAS EL CHAT ENTRE TODAS LAS CATEGORÍAS DE INTERÉS DEL USUARIO
class ChatSelect extends StatefulWidget {
  final User user;
  const ChatSelect({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatSelect> createState() => _ChatSelectState();
}

class _ChatSelectState extends State<ChatSelect> {
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
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 32.0),
                        child: Text(':(\n\n No hay chats disponibles',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.varelaRound(
                                fontSize: 27,
                                color: Colors.white.withOpacity(0.5))),
                      )),
                      Container(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32.0),
                            child: Text('Dirígete a tu perfil para cambiar tus intereses y habilitar esta sección',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.varelaRound(
                                    fontSize: 15,
                                    color: Colors.white.withOpacity(0.5))),
                          )),
                    ],
                  )
                  : !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 30, bottom: 10),
                        child: Text('Chats', style: GoogleFonts.poiretOne(fontSize: 50, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                      ),
                      Container(
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: values.length,
                          itemBuilder: (context, index) {
                            return getCategoriesList(context, widget.user,
                            snapshot.data!.get('categories')[index]);
                          })),
                    ],
                  );
            }
          }),
    );
  }
}

Widget getCategoriesList(BuildContext context, User user, String categoryName) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(user: user, categoryName: categoryName),
          ));
    },
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.of(context).size.width/1.1,
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade200.withOpacity(0.4),
                borderRadius: BorderRadius.circular(20)
          ),
          child:  Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(categoryName,
                    style: GoogleFonts.bungeeHairline(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
        ),
      ),
    ),
  );
}
