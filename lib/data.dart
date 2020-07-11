import 'dart:io';
import 'dart:convert';
import 'dart:math';

import 'package:path_provider/path_provider.dart';

import 'notifications.dart';

class Data {
  static List<String> keys = [
    "H",
    "M",
    "startHour",
    "startMin",
    "endHour",
    "endMin",
    "days"
  ];

  Map<String, dynamic> map;
  int stepsTaken;
  int stepsToTake;

  String msg;

  NotificationsManager nm;

  Data() {
    msg = "";
    nm = NotificationsManager();
  }

  void initState(Function onFinished) async {
    var first_time = false;
    try {
      final File file = await _localTimeFile;
      String contents = await file.readAsString();
      map = jsonDecode(contents);
    } catch (e) {
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
      first_time = true;
    }
    setSteps(() {
      nm.initState(first_time);
      onFinished();
    });
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

  Future<void> setSteps(Function onSetSteps) async {
    try {
      final File file = await _localTrackFile;
      String contents = await file.readAsString();
      List<String> l = contents.split("/");
      stepsTaken = int.parse(l[0]);
      stepsToTake = int.parse(l[1]);
    } catch (e) {
      calculateSteps();
    }
    onSetSteps();
    print("Steps to take (Data) $stepsToTake");
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
    trackkeeper
        .writeAsString(stepsTaken.toString() + "/" + stepsToTake.toString());
    scheduleNotifications();
  }

  void scheduleNotifications() {
    List<int> timeStamps = calcTimeStamps();
    nm.scheduleNotifications(timeStamps, map["days"]);
  }

  List<int> calcTimeStamps() {
    int intvl = (map['H'] * 60) + map['M'];
    int start = (map['startHour'] * 60) + map['startMin'];
    int end = (map['endHour'] * 60) + map['endMin'];

    List<int> timeStamps = new List();

    if (start < end) {
      // Day Shift
      while (start <= end) {
        timeStamps.add(start);
        start += intvl;
      }
    } else if (start > end) {
      // Night Shift
      while (start != end) {
        timeStamps.add(start);
        start += intvl;
        if (start >= 24 * 60) {
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

  /*
  String getShift() {
    return (((map['endHour'] * 60) + map['endMin'] - 
             (map['startHour'] * 60) + map['startMin']) >= 0 ?
            "day" : "night");
  }
  */

  int getMaxInterval() {
    return max(
        ((map['endHour'] * 60) +
            map['endMin'] -
            (map['startHour'] * 60) +
            map['startMin']),
        ((map['startHour'] * 60) +
            map['startMin'] -
            (map['endHour'] * 60) +
            map['endMin']));
  }
}
