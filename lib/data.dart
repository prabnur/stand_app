import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class Data {
  Map<String, dynamic> map;
  String msg;
  Function loadConfirm;
  List<String> keys = ["H", "M", "startHour", "startMin", "endHour", "endMin", "days"];

  Data() {
    msg = "";
  }

  void initState() async {
    try {
      final File file = await _localFile;
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
    }
    loadConfirm(true);
  }

  void setLoadConfirm(Function setLoaded) {
    loadConfirm = setLoaded;
    print("Set Load Confirmed");
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
    print("got local path");
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    print("got local file");
    return File('$path/timekeeper.txt');
  }

  void writeData() async {
    final File file = await _localFile;

    file.writeAsString(jsonEncode(map));
    print("file written");
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
