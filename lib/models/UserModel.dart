import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email, nickname;
  final String uid;
  final int numberOfLogs;
  final String profilePic;
  final int day, month, year;

  String get photo => this.photo;

  User(
      {required this.email, required this.uid, required this.numberOfLogs, required this.profilePic, required this.day, required this.month, required this.year, required this.nickname});

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map? data = doc.data() as Map?;

    return User(
      email: data!['email'],
      uid: data['uid'],
      numberOfLogs: data['numberOfLogs'],
      profilePic: data['profilePic'] ?? "",
      day: data['day'],
      month: data['month'],
      year: data['year'],
      nickname: data['nickname'] ?? "",
    );

  }

}