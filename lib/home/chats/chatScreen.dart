import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

//PANTALLA DE LA SALA DE CHAT DE LA CATEGORÍA SELECCIONADA EN LA PANTALLA DE SELECCIÓN DE CHAT
class ChatScreen extends StatefulWidget {
  final User user;
  final String categoryName;

  const ChatScreen({Key? key, required this.user, required this.categoryName})
      : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();

  Future<void> addNewMessage() async {
    String minute = DateTime.now().minute.toString();
    var minuteLength = minute.length;
    var minuteString;
    if(minuteLength < 2) {
      minuteString = '0'+minute;
    } else {
      minuteString = minute;
    }

    if (messageController.text.length > 0) {
      await _fireStore
          .collection('chats')
          .doc(widget.categoryName)
          .collection('chat')
          .add({
        'hour': '${DateTime.now().hour}:$minuteString',
        'text': messageController.text,
        'from': widget.user.email,
        'date': DateTime.now().toIso8601String().toString(),
        'dateString': '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'
      });
      messageController.clear();
      scrollController.animateTo(scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(widget.categoryName,
              style: GoogleFonts.poiretOne(fontSize: 30)),
          centerTitle: true,
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(Colors.transparent.withOpacity(0.1), BlendMode.dstIn),
              image: AssetImage('assets/icon2.png')
            ),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [HexColor("#000000"), HexColor("#341654")])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                stream: _fireStore
                    .collection("chats")
                    .doc(widget.categoryName)
                    .collection('chat')
                    .orderBy('date', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  List<DocumentSnapshot> docs = snapshot.data!.docs;

                  if(docs.length == 0) {
                    return Container(
                      child: Text('¡Sé el primero en escribir!', style: TextStyle(color: Colors.white.withOpacity(0.2), fontStyle: FontStyle.italic),),
                    );
                  } else {
                    List<Widget> messages = docs.map((doc) {
                      return Message(
                        date: doc.get('dateString'),
                        hour: doc.get('hour'),
                        from: doc.get('from'),
                        text: doc.get('text'),
                        me: widget.user.email == doc.get('from'),
                      );
                    }).toList();
                    return ListView(
                      reverse: true,
                      controller: scrollController,
                      children: <Widget>[
                        ...messages],
                    );
                  }
                },
              )),
              Container(
                margin: EdgeInsets.only(left: 10.0, bottom: 10.0, right: 10.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        child: TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.deepPurple[200]!.withOpacity(0.7),
                          filled: true,
                          hintText: "Escribe tu mensaje",
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.deepPurple),
                              borderRadius: BorderRadius.circular(40))),
                      controller: messageController,
                    )),
                    SendButton(callback: addNewMessage)
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

class SendButton extends StatelessWidget {
  final callback;

  const SendButton({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade400.withOpacity(0.8),
        borderRadius: BorderRadius.circular(80)
      ),
        margin: EdgeInsets.only(left: 10.0),
        child: IconButton(
          icon: Icon(Icons.send),
          color: Colors.white,
          onPressed: callback,
          iconSize: 30,
        ));
  }
}

class Message extends StatelessWidget {
  final String from, text, hour, date;
  final bool me;

  const Message(
      {Key? key, required this.from, required this.text, required this.me, required this.hour, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usuarios')
              .doc(from)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
            return !snapshot.hasData
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment:
                        me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left:12, right: 15),
                        child: Container(
                          child: Text(snapshot.data!.get('nickname')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Container(
                              margin: EdgeInsets.only(
                                  top: 7.0, left: 10.0, right: 10.0),
                              child: Stack(
                                alignment: AlignmentDirectional.bottomEnd,
                                children: [
                                  Material(
                                    color: me ? Colors.deepPurple.shade200.withOpacity(0.6) : Colors.deepPurple[400]!.withOpacity(0.6),
                                    textStyle: TextStyle(color: Colors.white70),
                                    borderRadius: BorderRadius.circular(10),
                                    elevation: 6.0,
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                          minWidth: 60,
                                          minHeight: 40,
                                      maxWidth: 300),
                                     // padding: EdgeInsets.symmetric(
                                          //vertical: 13, horizontal: 15.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          text[0].toUpperCase() + text.substring(1),
                                          textAlign: TextAlign.start,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 10, 6, 0),
                                    child: Text(hour, style: TextStyle(color: Colors.white70, fontSize: 10), textAlign: TextAlign.end,),
                                  )
                                ],
                              ),
                            ),

                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12, top: 5, right: 15, bottom: 8),
                        child: Text(date, style: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 10),),
                      )

                    ],
                  );
          }),
    );
  }
}
