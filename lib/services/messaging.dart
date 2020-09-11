import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  // Stands for Firebase Cloud Messaging
  FirebaseMessaging _fcm = FirebaseMessaging();

  Future initialize() async {
    if (Platform.isIOS) {
      await _fcm.requestNotificationPermissions(IosNotificationSettings());
    }

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("on Message: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("on Launch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("on Resume: $message");
      },
    );
  }
}
