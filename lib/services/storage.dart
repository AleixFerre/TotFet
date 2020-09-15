import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class StorageService extends ChangeNotifier {
  // Lazy Singleton per l'acces a la BD
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getImageFromUser(String id) async {
    String url =
        await _storage.ref().child("imgs_perfil/$id.jpg").getDownloadURL();
    print(url);
    return url;
  }
}
