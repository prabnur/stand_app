import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class FCM {
  static void configure() {
    final FirebaseMessaging fcm = FirebaseMessaging();

    fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          Fluttertoast.showToast(
              msg: "Time to get up!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.black,
              textColor: Color(0xfffcec03),
              fontSize: 18);
        },
        onBackgroundMessage: myBackgroundMessageHandler,
        onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        });

    // TODO implement the handling of a token refresh
    fcm.onTokenRefresh.listen((newToken) {}, onError: () {}, onDone: () {});

    fcm.getToken().then((t) => {print("Token: $t")});
  }

  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    return Future<bool>.value(true);
  }
}
