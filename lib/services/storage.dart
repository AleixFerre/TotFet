import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:totfet/services/auth.dart';
import 'package:totfet/services/database.dart';

class StorageService extends ChangeNotifier {
  // Lazy Singleton per l'acces a la BD
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getImageFromUser(String id) async {
    String url =
        await _storage.ref().child("imgs_perfil/$id.jpg").getDownloadURL();
    print(url);
    return url;
  }

  StorageUploadTask uploadImage(File image) {
    String filePath = "imgs_perfil/${AuthService().userId}.jpg";
    return _storage.ref().child(filePath).putFile(image);
  }

  Future deleteProfileImage() async {
    String filePath = "imgs_perfil/${AuthService().userId}.jpg";
    await DatabaseService().adjudicaTeFoto(AuthService().userId, false);
    return await _storage.ref().child(filePath).delete();
  }
}
