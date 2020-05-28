import 'dart:isolate';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

//TO:DO  Add Send and Recieve Ports


class NotificationsManager {
  static final String notificationTitle = "Stand Up!"; 
  static final String notificationMsg = "Tap if you stand. Swipe to dismiss.";

  static final String iOSInAppNotifTitle = "Stand Up!";
  static final String iOSInAppNotifMsg = "Do it for the Motherland!";

  Isolate isolate;
  ReceivePort rp;
  bool spawnedIsolate;

  NotificationsManager() {
    spawnedIsolate = false;
    rp = new ReceivePort();
    rp.listen((message) {print(message);});
  }

  static void setNotifications(Map<String,dynamic> message) async {
    List<int> timeStamps = message["timeStamps"];
    String days = message["days"];
    FlutterLocalNotificationsPlugin notificationsPlugin = message["notificationsPlugin"];

    // Cancel all previous notifications  
    await notificationsPlugin.cancelAll();

    // Setup configurations                                             id      name       description
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('alpha', 'Stand Up', 'Plus Ultra!');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    List<Day> daysOfWeek = [Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday];
    String reply = "";
    // Set the notifications
    for(int i=0; i<daysOfWeek.length; i++) {
      if (days[i] == "1") {
        for(int j=0; j<timeStamps.length; j++) {
          try {
            await notificationsPlugin.showWeeklyAtDayAndTime(
              0,
              notificationTitle,
              notificationMsg,
              daysOfWeek[i],
              new Time(timeStamps[j] ~/ 60, timeStamps[j] % 60, 0),
              platformChannelSpecifics
            );
            reply += "DAY $i H ${timeStamps[j] ~/ 60} M ${timeStamps[j] % 60} \n";
          } catch(e) {
            message["sendPort"].send("[Set Failed]: "+e.message);
          }
        }
      }
    }

    message["sendPort"].send(reply);
  }

  void spawnIsolate(List<int> timeStamps, String days, FlutterLocalNotificationsPlugin nP) async {
    //if (spawnedIsolate) terminateIsolate();

    Map<String,dynamic> message = {
      "timeStamps": timeStamps,
      "days": days,
      "notificationsPlugin": nP,
      "sendPort": rp.sendPort
    };

    try {
      isolate = await Isolate.spawn(setNotifications, message);
      spawnedIsolate = true;
    } catch (e) {
      print("[Isolate Spawn failed]: "+e.message);
    }
  }

  void terminateIsolate() {
    if (isolate != null) {
      isolate.kill(priority: Isolate.immediate);
    }
  }
}
