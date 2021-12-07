import 'package:diaryly/about/aboutApp.dart';
import 'package:diaryly/about/aboutMe.dart';
import 'package:diaryly/home/Home.dart';
import 'package:diaryly/notifications/notification_api.dart';
import 'package:diaryly/provider/MyProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:hexcolor/hexcolor.dart';

//PANTALLA DE AJUSTES
class Settings extends StatefulWidget {
  final User user;

  const Settings({Key? key, required this.user}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  @override
  void initState() {
    super.initState();
    listenNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    stopListenNotifications();
  }

  void listenNotifications() => NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void stopListenNotifications() => NotificationApi.onNotifications.stream.listen(onClickedNotification).cancel();

  //POR ALGUNA RAZÓN CUANDO SALE LA NOTIFICACIÓN Y LE DOY CLICK, ME LLEVA A HOME PERO NO PUEDO VOLVER A ENTRAR EN SETTINGS
  //LAS NOTIFICACIONES ESTÁN PROGRAMADAS PARA LAS 21:30 DE CADA DÍA, VER MÁS EN notification_api.dart
  void onClickedNotification(String? payload) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Home(user: widget.user),
      ));

  @override
  Widget build(BuildContext context) {
    return Consumer<MyProvider>(builder: (context, prov, child) {
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
                    ListView(
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: ListTile.divideTiles(
                          color: Colors.white,
                          context: context,
                          tiles: [
                            ExpansionTile(
                                leading: Padding(
                                  padding: const EdgeInsets.only(top: 3, left: 1),
                                  child: Image.asset('assets/notification.png',
                                    height: 26, color: Colors.white,),
                                ),
                                title: Text('Notificaciones',
                                    style: TextStyle(
                                      fontFamily: 'SourceSansPro',
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.white)
                                ),
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 70),
                                        child: Text(prov.notifications
                                            ? "Activadas"
                                            : "Desactivadas", style: TextStyle(
                                            fontFamily: 'SourceSansPro',
                                            fontSize: 17,
                                            fontWeight: FontWeight.normal,
                                            color: Colors.white)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Switch(
                                            value: prov.notifications,
                                            onChanged: (bool onChanged) {
                                              setState(() {
                                                print('activadas');
                                                prov.activateNotifications();
                                                NotificationApi
                                                    .showScheduledNotification(
                                                    title: '¿Qué tal?',
                                                    body: 'Relájate un poco y escribe cómo te ha ido hoy',
                                                    scheduledDate: DateTime.now().add(Duration(seconds: 3)));
                                              });
                                            }),
                                      )
                                    ],
                                  )
                                ]

                            ),
                            ListTile(
                                leading: Icon(Icons.share),
                                title: Text(
                                    'Recomendar a un amigo', style: TextStyle(
                                    fontFamily: 'SourceSansPro',
                                    fontSize: 20,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.white)),
                                onTap: () {
                                  Share.share(
                                      '¡Escribe, infórmate y chatea con Stellary! Muy pronto gratis en Play Store https://acasfer106.wixsite.com/stellary',
                                      subject: 'Stellary');
                                }
                            ),
                            ListTile(
                              leading: Icon(Icons.info_outline),
                              title: Text(
                                  'Sobre la aplicación', style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AboutApp(),
                                    ));
                              },
                            ),
                            ListTile(
                              leading: Icon(Icons.person),
                              title: Text('Sobre mí', style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AboutMe(),
                                    ));
                              },
                            ),
                          ],
                        ).toList()
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 150, top: 585),
                      child: Container(
                        width: 100,
                        height: 100,
                        child: Image.asset('assets/icontitle.png'),
                      ),
                    )
                  ],
                ),
              )));
    });
  }
}


