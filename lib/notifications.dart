import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationsManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const NOTIFICATION_TITLE = 'Stand Up!';
  static const NOTIFICATION_MESSAGE = 'You got this! Reminder for ';
  static const IN_APP_NOTIFICATION_MESSAGE =
      'Rise and shine! Hit the Stand button.';

  static const ANDROID_CHANNEL_ID = 'channel1';
  static const ANDROID_CHANNEL_NAME = 'Basic';
  static const ANDROID_CHANNEL_DESCRIPTION = 'Does anyone even look at this?';

  Future<void> onDidReceiveLocalNotification(
      int id, String title, String body, String payload) {
    Fluttertoast.showToast(
        msg: IN_APP_NOTIFICATION_MESSAGE,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Color(0xfffcec03),
        fontSize: 18);
  }

  void initState(bool firstTime) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    var initializationSettingsIOS;
    if (firstTime) {
      initializationSettingsIOS = IOSInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    } else {
      initializationSettingsIOS = IOSInitializationSettings(
          requestSoundPermission: false,
          requestBadgePermission: false,
          requestAlertPermission: false,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    }
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  NotificationDetails getPlatformChannelSpecifics() {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        ANDROID_CHANNEL_ID, ANDROID_CHANNEL_NAME, ANDROID_CHANNEL_DESCRIPTION,
        importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    return platformChannelSpecifics;
  }

  void scheduleNotifications(List<int> timeStamps, String days) async {
    NotificationDetails platformChannelSpecifics =
        getPlatformChannelSpecifics();
    await flutterLocalNotificationsPlugin
        .cancelAll()
        .then((value) => print('Old Notifications cancelled.'));
    var allDays = [
      Day.Monday,
      Day.Tuesday,
      Day.Wednesday,
      Day.Thursday,
      Day.Friday,
      Day.Saturday,
      Day.Sunday
    ];
    var count = 0;
    for (int dayIndex = 0; dayIndex < allDays.length; dayIndex++) {
      if (days[dayIndex] == '0') continue;
      for (int tsIndex = 0; tsIndex < timeStamps.length; tsIndex++) {
        var h = timeStamps[tsIndex] ~/ 60;
        var m = timeStamps[tsIndex] % 60;
        var time = Time(h, m, 0);
        print('$h:$m');
        await flutterLocalNotificationsPlugin
            .showWeeklyAtDayAndTime(
                count,
                NOTIFICATION_TITLE,
                NOTIFICATION_MESSAGE + '$h:$m',
                allDays[dayIndex],
                time,
                platformChannelSpecifics)
            .then((value) =>
                print('Notification set for $h:$m'));
        count++;
      }
    }
  }

  void cancelAll() async {
    await flutterLocalNotificationsPlugin
        .cancelAll()
        .then((value) => print('Old Notifications cancelled.'));
  }
}
