import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationsManager {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static final NOTIFICATION_TITLE = "Stand Up!";
  static final NOTIFICATION_MESSAGE = "You got this!!";
  static final IN_APP_NOTIFICATION_MESSAGE =
      "Rise and shine! Hit the Stand button.";

  static final ANDROID_CHANNEL_ID = 'channel1';
  static final ANDROID_CHANNEL_NAME = 'Basic';
  static final ANDROID_CHANNEL_DESCRIPTION = 'Does anyone even look at this?';

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

  void initState(bool first_time) async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var initializationSettingsIOS;
    if (first_time) {
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
    weeklyInAMinute();
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
        .then((value) => print("Old Notifications cancelled."));
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
        print("${(time.hour)}:${(time.minute)}");
        await flutterLocalNotificationsPlugin
            .showWeeklyAtDayAndTime(
                count,
                'scheduled title',
                'Weekly notification shown on Monday at approximately ${(time.hour)}:${(time.minute)}',
                Day.Saturday,
                time,
                platformChannelSpecifics)
            .then((value) =>
                print("Notification set for ${(time.hour)}:${(time.minute)}"));

        count++;
      }
    }
  }

  void weeklyInAMinute() async {
    var scheduledNotificationDateTime =
        DateTime.now().add(Duration(minutes: 1));
    var time = Time(3, 12, 0);
    NotificationDetails platformChannelSpecifics =
        getPlatformChannelSpecifics();
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        0,
        NOTIFICATION_TITLE,
        NOTIFICATION_MESSAGE + ' ${(time.hour)}:${(time.minute)}',
        Day.Saturday,
        time,
        platformChannelSpecifics);
  }
}