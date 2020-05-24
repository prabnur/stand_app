import 'dart:io';
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

class Data {
  static List<String> keys = ["H", "M", "startHour", "startMin", "endHour", "endMin", "days"];

  static String notificationTitle = "Stand Up!"; 
  static String notificationMsg = "Tap if you stand. Swipe to dismiss.";

  static final String iOSInAppNotifTitle = "Stand Up!";
  static final String iOSInAppNotifMsg = "Do it for the Motherland!";

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

  void setNotifications() async {
    // Cancel all previous notifications
    await notificationsPlugin.cancelAll();
    print(" PRINT Cancelled all notificaitons");

    // Setup configurations                                             id      name       description
    var androidPlatformChannelSpecifics = AndroidNotificationDetails('alpha', 'Stand Up', 'Plus Ultra!');
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);

    List<Day> daysOfWeek = [Day.Monday, Day.Tuesday, Day.Wednesday, Day.Thursday, Day.Friday, Day.Saturday, Day.Sunday];
    List<Time> timeStamps = new List();

    // Calculate time stamps
    int start = (map['startHour'] * 60) + map['startMin'];
    int end = (map['endHour'] * 60) + map['endMin'];
    int intvl = (map['H'] * 60) + map['M'];
    while(start <= end) {
      start += intvl;
      print("H ${start ~/ 60} M ${start%60} S 0");
      timeStamps.add(new Time(start ~/ 60, start%60, 0));
    }

    // Set the notifications
    for(int i=0; i<daysOfWeek.length; i++) {
      if (map["days"][i] == 1) {
        for(int j=0; j<timeStamps.length; j++) {
          await notificationsPlugin.showWeeklyAtDayAndTime(
            0,
            notificationTitle,
            notificationMsg,
            daysOfWeek[i],
            timeStamps[j],
            platformChannelSpecifics
          );
        }
      }
    }
    print(" PRINT ${timeStamps.length} Notifications set");
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

    // Check if end < start
    if ((map["startHour"] > map["endHour"]) || ((map["startHour"] == map["endHour"]) && (map["startMin"] > map["endMin"]))) {
      msg = "End time must be greater than start time";
      return false;
    }

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

  void writeData() async {
    final File timekeeper = await _localTimeFile;
    timekeeper.writeAsString(jsonEncode(map));

    calculateSteps();
    final File trackkeeper = await _localTrackFile;
    trackkeeper.writeAsString(stepsTaken.toString() + "/" + stepsToTake.toString());

    setNotifications();
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
    return ((map['endHour'] * 60) + map['endMin']) - 
           ((map['startHour'] * 60) + map['startMin']);
  }
}
