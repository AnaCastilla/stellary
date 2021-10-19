import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final List<String> categories;
  final String email, nickname;
  final String uid;
  final int numberOfLogs;
  final String profilePic;
  final int day, month, year;

  String get photo => this.photo;

  UserModel(
      {required this.categories, required this.email, required this.nickname, required this.numberOfLogs, required this.profilePic, required this.day, required this.month, required this.year, required this.uid});

  factory UserModel.fromFirestore(Map<String, dynamic>? data) {
    return UserModel(
      categories: data!['categories'],
      email: data['email'],
      nickname: data['nickname'] ?? "",
      numberOfLogs: data['numberOfLogs'],
      profilePic: data['profilePic'] ?? "",
      day: data['day'],
      month: data['month'],
      year: data['year'],
      uid: data['uid'],
    );

  }

}