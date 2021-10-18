import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi {
  static UploadTask? uploadImage(String destination, File file) {
    final ref = FirebaseStorage.instance.ref(destination);

    return ref.putFile(file);
  }
}