import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:totfet/services/database.dart';
import 'package:totfet/shared/constants.dart';

class VersionControlService {
  Future<Map<String, dynamic>> checkUpdates() async {
    DocumentSnapshot version = await DatabaseService().getCurrentVersion();

    Map<String, dynamic> data = version.data();

    if (data['index'] > versionIndex) {
      // Hi ha una versió nova
      return data;
    } else {
      // No hi ha cap versió nova
      return null;
    }
  }
}
