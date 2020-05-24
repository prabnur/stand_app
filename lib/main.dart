// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'options.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: InitOptions()
    );
  }
}

class InitOptions extends StatefulWidget {
  final Data D = new Data();
  final FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  _InitOptions createState() => _InitOptions(D: this.D, notificationsPlugin: this.notificationsPlugin);
}

class _InitOptions extends State<InitOptions> {
  bool loaded;
  final Data D;
  final FlutterLocalNotificationsPlugin notificationsPlugin;

  _InitOptions({this.D, this.notificationsPlugin});

  @override
  void initState() {
    super.initState();
    loaded = false;
    D.setLoadConfirm(setLoaded);
    initNotificationsPlugin();
    D.initState(notificationsPlugin);
  }

  void initNotificationsPlugin() async {
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification
    ); // TO:DO when notification is requested while in app
    var initializationSettings = InitializationSettings(initializationSettingsAndroid, initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings, onSelectNotification: Data.updateSteps);
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    showDialog(
      context: context,
      builder: (BuildContext context) => 
        CupertinoAlertDialog(
            title: Text(Data.iOSInAppNotifTitle),
            content: Text(Data.iOSInAppNotifMsg),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("Dismiss"),
                onPressed: () {}
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("I'll Stand!"),
                onPressed: () {Data.updateSteps('');}
              )
            ],
        ),
    );
  }

  void setLoaded(bool b) {
    setState(() {
      loaded = b;
    });
    print("Ready to display");
  }

  @override
  Widget build(BuildContext context) {
    return (loaded ? Options(D: this.D) : Scaffold(body: Text('Loading'))); // TO:DO add a loading screen
  }
}
