import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class CategoryDetail extends StatelessWidget {
  final String categoryName;

  const CategoryDetail({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [HexColor("#000000"), HexColor("#200A37")])),
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('pages')
                  .doc(categoryName)
                  .collection('pages')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                return !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : Column(children: [
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              DocumentSnapshot pageData =
                                  snapshot.data!.docs[index];
                              print(snapshot.data!.docs.length);
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(10,10,10,0),
                                child: GestureDetector(
                                  onTap: () => launchURL(pageData.get('page1')),
                                  child: Container(
                                    width: 100,
                                    height: 120,
                                    child: Card(
                                      elevation: 10,
                                      color: Colors.deepPurple.shade100.withOpacity(0.4),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8, left: 8),
                                            child: SizedBox(
                                                width: 100,
                                                height: 100,
                                                child: Image.asset('assets/pages/${pageData.get('image')}')),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(15,5,0,0),
                                                child: Text(pageData.get('title'), style: GoogleFonts.varelaRound(fontSize: 17, fontWeight: FontWeight.bold)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(15,5,0,0),
                                                child: SizedBox(
                                                  width: 200,
                                                    height: 50,
                                                    child: Text(pageData.get('description'), style: GoogleFonts.varelaRound()))
                                              )
                                            ],
                                          ),

                                        ],
                                      ),

                                    )
                                  ),
                                ),
                              );
                            })
                      ]);
              })),
    );
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
