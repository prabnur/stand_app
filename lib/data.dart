import 'dart:io';
import 'dart:convert';

import 'package:path_provider/path_provider.dart';

import 'notifications.dart';
import 'proprtions.dart';

class Data {
  // Stuff to Read/Write
  int h;
  int m;
  int startHour;
  int startMin;
  int endHour;
  int endMin;
  String days;
  bool notifyMe;

  int stepsTaken;
  int stepsToTake;

  // Error Reporting
  String msg;

  // Functional
  NotificationsManager nm;
  Proportions P;

  Function resetTrackerAnimation;
  Function updateIntervalState;

  Data() {
    msg = '';
    nm = NotificationsManager();
  }

  void initState(Function onFinished) async {
    var firstTime = false;
    resetTrackerAnimation = onFinished;
    try {
      final File file = await getFile('config');
      String contents = await file.readAsString();
      deserialize = jsonDecode(contents);
    } catch (e) {
      print('Could not read file');
      deserialize = {
        'H': 1,
        'M': 0,
        'startHour': 9,
        'startMin': 0,
        'endHour': 17,
        'endMin': 0,
        'days': '1111100',
        'notifyMe': true
      };
      stepsTaken = 0;
      stepsToTake = 8;
      firstTime = true;
      writeData();
    }
    setSteps(() {
      nm.initState(firstTime);
      onFinished();
    });
  }

  void updateSteps(int sT, int sTT) async {
    stepsTaken = sT;
    stepsToTake = sTT;
    final File file = await getFile('tracker');
    file.writeAsString(stepsTaken.toString() + '/' + stepsToTake.toString());
  }

  Future<void> setSteps(Function onSetSteps) async {
    try {
      final File file = await getFile('tracker');
      String contents = await file.readAsString();
      List<String> l = contents.split('/');
      stepsTaken = int.parse(l[0]);
      stepsToTake = int.parse(l[1]);
    } catch (e) {
      calculateSteps();
    }
    onSetSteps();
  }

  void calculateSteps() {
    stepsTaken = 0;
    int intvl = (h * 60) + m;
    stepsToTake = (getMaxInterval() ~/ intvl) + 1;
    print('Max Interval: ${getMaxInterval()}');
    print('New steps to take $stepsToTake');
    resetTrackerAnimation();
  }

  void writeData() async {
    // Write Config
    final File timekeeper = await getFile('config');
    timekeeper.writeAsString(jsonEncode(serialize));
    updateIntervalState();

    // Write Tracker
    calculateSteps();
    final File trackkeeper = await getFile('tracker');
    trackkeeper
        .writeAsString(stepsTaken.toString() + '/' + stepsToTake.toString());

    // Schedule Notifications
    if (notifyMe) nm.scheduleNotifications(calcTimeStamps(), days);
  }

  List<int> calcTimeStamps() {
    int intvl = (h * 60) + m;
    int start = (startHour * 60) + startMin;
    int end = (endHour * 60) + endMin;

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

  bool isIntervalValid(hour, min) {
    msg = '';
    // Check if interval hour or minute are negative
    if (hour < 0) msg = 'Interval Hour must be positive';
    if (min < 0) msg = 'Interval Minute must be positive';

    // Check if they are within their upper bound
    if (hour > 23) msg = 'Interval Hour must be between 0 and 23';
    if (min > 59) msg = 'Interval Minute must be between 0 and 59';

    // Check if there is enough room for an interval between start and end
    if (getMaxInterval() < ((hour * 60) + min))
      msg = 'Interval too large for chosen start and end times';

    if (msg != '') return false;

    msg = '';
    return true;
  }

  void initialiseProportion(h, w) {
    P = Proportions.construct(h, w);
  }

  Future<File> getFile(type) async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$type.txt');
  }

  int getMaxInterval() {
    print('Start Hour: $startHour Min $startMin');
    print('End Hour: $endHour Min $endMin');
    if ((startHour < endHour) || (startHour == endHour && startMin < endMin))
      return ((endHour * 60) + endMin) - ((startHour * 60) + startMin);
    else
      return (24 * 60) -
          ((startHour * 60) + startMin) +
          ((endHour * 60) + endMin);
  }

  String getDayStatus(String dayAcronym) {
    switch (dayAcronym) {
      case 'M':
        return days[0];
        break;
      case 'T':
        return days[1];
        break;
      case 'W':
        return days[2];
        break;
      case 'Th':
        return days[3];
        break;
      case 'F':
        return days[4];
        break;
      case 'Sa':
        return days[5];
        break;
      case 'Su':
        return days[6];
        break;
      default:
        return '0';
        break;
    }
  }

  Map<String, dynamic> get serialize {
    return {
      'H': h,
      'M': m,
      'startHour': startHour,
      'startMin': startMin,
      'endHour': endHour,
      'endMin': endMin,
      'days': days,
      'notifyMe': notifyMe
    };
  }

  set deserialize(Map<String, dynamic> map) {
    h = map['H'];
    m = map['M'];
    startHour = map['startHour'];
    startMin = map['startMin'];
    endHour = map['endHour'];
    endMin = map['endMin'];
    days = map['days'];
    notifyMe = map['notifyMe'];
  }

  set notify(bool newNotifyMe) {
    if (notifyMe)
      nm.cancelAll();
    else
      nm.scheduleNotifications(calcTimeStamps(), days);
    notifyMe = newNotifyMe;
  }
}
