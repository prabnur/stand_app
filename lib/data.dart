import 'dart:io';
import 'dart:convert';
import 'dart:math';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import 'notifications.dart';

class Data {
  static List<String> keys = ["H", "M", "startHour", "startMin", "endHour", "endMin", "days"];

  Map<String, dynamic> map;
  int stepsTaken;
  int stepsToTake;

  FlutterLocalNotificationsPlugin notificationsPlugin;
  String msg;
  Function loadConfirm;

  Data() {
    msg = "";
  }

  void initState(FlutterLocalNotificationsPlugin nP) async {
    try {
      final File file = await _localTimeFile;
      String contents = await file.readAsString();
      map = jsonDecode(contents);
      
    } catch(e) {
      print("Could not read file");
      map = {
        "H": 1,
        "M": 0,
        "startHour": 9,
        "startMin": 0,
        "endHour": 17,
        "endMin": 0,
        "days": "1111100"
      };
      stepsTaken = 0;
      stepsToTake = 8;
    }
    setSteps();
    notificationsPlugin = nP;
    loadConfirm(true);
  }

  static Future updateSteps(String payload) async {
    final directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/tracker.txt');
    String contents = await file.readAsString();
    List<String> l = contents.split("/");
    int stepsTaken = int.parse(l[0]);
    int stepsToTake = int.parse(l[1]);
    stepsTaken++;
    if (stepsTaken > stepsToTake) {
      stepsTaken = 0;
    }
    file.writeAsString(stepsTaken.toString() + "/" + stepsToTake.toString());
  }

  void setSteps() async {
    try {
      final File file = await _localTrackFile;
      String contents = await file.readAsString();
      List<String> l = contents.split("/");
      stepsTaken = int.parse(l[0]);
      stepsToTake = int.parse(l[1]);
    } catch (e) {
      calculateSteps();
    }
  }

  void calculateSteps() {
    stepsTaken = 0;
    int intvl = (map["H"] * 60) + map["M"];
    stepsToTake = getMaxInterval() ~/ intvl;
  }

  void writeData() async {
    final File timekeeper = await _localTimeFile;
    timekeeper.writeAsString(jsonEncode(map));

    calculateSteps();
    final File trackkeeper = await _localTrackFile;
    trackkeeper.writeAsString(stepsTaken.toString() + "/" + stepsToTake.toString());

    List<int> timeStamps = calcTimeStamps();
    NotificationsManager.setNotifications(timeStamps, map["days"], notificationsPlugin);

    //scheduleNotification();
    //displayNotification();
    /*
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
      if (map["days"][i] == "1") {
        for(int j=0; j<timeStamps.length; j++) {
          try {
            await notificationsPlugin.showWeeklyAtDayAndTime(
              0,
              "test mfer",
              "knock knock bitch",
              daysOfWeek[i],
              new Time(timeStamps[j] ~/ 60, timeStamps[j] % 60, 0),
              platformChannelSpecifics
            );
            reply += "DAY $i H ${timeStamps[j] ~/ 60} M ${timeStamps[j] % 60} \n";
          } catch(e) {
             print("[Set Failed]: "+e.message);
          }
        }
      }
    }

    var reqs = await notificationsPlugin.pendingNotificationRequests();
    var req = reqs[0];
    */
  }

  void scheduleNotification() async {
    var time = DateTime.now().add(Duration(seconds: 20));
    var androidPlatformChannelSpecifics =  AndroidNotificationDetails('show weekly channel id',
            'show weekly channel name', 'show weekly description');
    var iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.showWeeklyAtDayAndTime(
        0,
        'Weekly',
        'fuck you. like I meanted it.',
        Day.Sunday,
        new Time(time.hour, time.minute, time.second),
        platformChannelSpecifics);
    print("Notification Set!");
  }

  void displayNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'id_1', 'test_channel', 'What is my purpose',
    importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await notificationsPlugin.show(
      0, 'YOLO', 'You will die a Genji main.', platformChannelSpecifics,
      payload: 'item x');
  }

  List<int> calcTimeStamps() {
    int intvl = (map['H'] * 60) + map['M'];
    int start = (map['startHour'] * 60) + map['startMin'];
    int end = (map['endHour'] * 60) + map['endMin'];

    List<int> timeStamps = new List();
    
    if (start < end) { // Day Shift
      while(start <= end) {
        timeStamps.add(start);
        start += intvl;
      }
    } else if (start > end) { // Night Shift
      while(start != end) {
        timeStamps.add(start);
        start += intvl;
        if (start >= 24*60) {
          start = 0;
        }
      }
    }

    return timeStamps;
  }

  bool isDataValid() {
    // Check if interval hour or minute are negative
    if (map["H"] < 0) {
      msg = "Interval Hour must be positive";
    }
    if (map["M"] < 0) {
      msg = "Interval Minute must be positive";
    }

    // Check if they are within their upper bound
    if (map["H"] > 23) {
      msg = "Interval Hour must be between 0 and 23";
    }
    if (map["M"] > 59) {
      msg = "Interval Minute must be between 0 and 59";
    }

    /* Check if end < start
    if ((map["startHour"] > map["endHour"]) || ((map["startHour"] == map["endHour"]) && (map["startMin"] > map["endMin"]))) {
      msg = "End time must be greater than start time";
      return false;
    }
    */

    // Check if there is enough room for an interval between start and end
    if (getMaxInterval() < ((map["H"] * 60) + map["M"])) {
      msg = "Interval too large for chosen start and end times";
      return false;
    }

    msg = "";
    return true;
  }

  String get getMsg {
    return msg;
  }
  
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localTimeFile async {
    final path = await _localPath;
    return File('$path/timekeeper.txt');
  }

  Future<File> get _localTrackFile async {
    final path = await _localPath;
    return File('$path/tracker.txt');
  }

  void setLoadConfirm(Function setLoaded) {
    loadConfirm = setLoaded;
    print("Set Load Confirmed");
  }

  int getVal(String key) {
    return map[key];
  }

  String getDays() {
    return map["days"];
  }

  void setDays(String val) {
    map["days"] = val;
  }

  void setVal(String key, int val) {
    map[key] = val;
  }
  
  int getMaxInterval() {
    return
    max(
      ((map['endHour'] * 60) + map['endMin'] - 
       (map['startHour'] * 60) + map['startMin']),
      ((map['startHour'] * 60) + map['startMin'] - 
       (map['endHour'] * 60) + map['endMin'])
    );
  }
}
