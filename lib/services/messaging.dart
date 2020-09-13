import 'package:firebase_messaging/firebase_messaging.dart';

class MessagingService {
  // Stands for Firebase Cloud Messaging
  final FirebaseMessaging _fcm = FirebaseMessaging();

  void initialize() async {
    _fcm.configure(
      // Called when the app is in the foreground and we recive a push notification
      onMessage: (Map<String, dynamic> message) async {
        // print("on Message: $message");
      },
      // Called when the app has been closed completely and it's opened
      // from the push notification directly
      onLaunch: (Map<String, dynamic> message) async {
        // print("on Launch: $message");
        _serializeAndNavigate(message);
      },
      // Called when the app is in the background and it's opened
      // from the push notification
      onResume: (Map<String, dynamic> message) async {
        // print("on Resume: $message");
        _serializeAndNavigate(message);
      },
    );
  }

  void _serializeAndNavigate(Map<String, dynamic> message) {
    dynamic notificationData = message['data'];
    dynamic view = notificationData['view'];

    if (view != null) {
      // Navigate to the view
      if (view == 'detalls_compra') {
        // Fer que vagi cap a la pestanya que toca.
        // String compraID = notificationData['compraID'];
        // print(compraID);

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CompraDetails(
        //       id: compraID,
        //       tipus: null,
        //     ),
        //   ),
        // );
      }
    }
  }

  Future getToken() async {
    return await _fcm.getToken();
  }
}
