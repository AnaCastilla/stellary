import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:diaryly/dialog/createDialog.dart';
import 'package:diaryly/home/diary/diaryScreen.dart';
import 'package:diaryly/home/news/newsScreen.dart';
import 'package:diaryly/login/loginScreen.dart';
import 'package:diaryly/profile/profile.dart';
import 'package:diaryly/settings/settings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';

import 'chats/chatSelectScreen.dart';
import 'home/homeScreen.dart';

class Home extends StatefulWidget {
  final User user;

  Home({Key? key, required this.user}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _page = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  signOut() async {
    await _auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final screen = [
      HomeScreen(user: widget.user),
      DiaryScreen(user: widget.user),
      NewsScreen(user: widget.user),
      ChatSelect(user: widget.user)
    ];
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#000000"), HexColor("#200A37")])),
        child: WillPopScope(
            onWillPop: _onWillPopScope,
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                ),
                backgroundColor: Colors.transparent,
                drawer: Drawer(
                    child: ListView(children: [
                  SizedBox(
                    height: 200,
                    width: 300,
                    child: UserAccountsDrawerHeader(
                      decoration: BoxDecoration(color: Colors.transparent),
                      accountName: Text("STELLARY",
                          style: GoogleFonts.poiretOne(
                              fontSize: 30,
                              color: Colors.white,
                              letterSpacing: 8)),
                      accountEmail: Text(""),
                      currentAccountPicture: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Image.asset('assets/icon.png')),
                    ),
                  ),
                  ListTile(
                    title: Text("Perfil"),
                    leading: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(user: widget.user),
                          ));
                    },
                  ),
                  ListTile(
                    title: Text("Ajustes"),
                    leading: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Settings(),
                          ));
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Cerrar sesión"),
                    leading: Icon(Icons.logout, color: Colors.white),
                    onTap: ()  {
                      //signOut();
                      //Navigator.pushNamedAndRemoveUntil(context, 'login', (route) => false);
                      Fluttertoast.showToast(msg: 'Sesión cerrada');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ));
                    },
                  ),
                ])),
                bottomNavigationBar: CurvedNavigationBar(
                  key: _bottomNavigationKey,
                  index: 0,
                  height: 50.0,
                  items: <Widget>[
                    Icon(
                      Icons.home_outlined,
                      size: 30,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 3.0),
                      child: SizedBox(
                        width: 30,
                        height: 26,
                        child: Image.asset(
                          'assets/diary.png',
                          color: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 25,
                      child: Image.asset(
                        'assets/interest.png',
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: 30,
                      height: 25,
                      child: Image.asset(
                        'assets/chat.png',
                        color: Colors.white,
                      ),
                    ),
                  ],
                  color: Colors.black,
                  buttonBackgroundColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  animationCurve: Curves.easeInOut,
                  animationDuration: Duration(milliseconds: 200),
                  onTap: (index) {
                    setState(() {
                      print(_page);
                      _page = index;
                    });
                  },
                  letIndexChange: (index) => true,
                ),
                body: screen[_page])));
  }

  Future<bool> _onWillPopScope() {
    CreateDialog dialog = CreateDialog();
    return dialog.createDialogToLogin(
        "¿Seguro que quieres cerrar sesión?", context);
  }
}
