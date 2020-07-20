import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'timepicker.dart';
import 'toggleoptions.dart';
import 'intervalpicker.dart';
import 'dayspicker.dart';

// ignore: must_be_immutable
class Options extends StatelessWidget {
  final Data D;
  final List<String> days = new List(7);

  bool proportionSet;
  List optionWidgets;

  Function updateInterval;
  void setUpdateInterval(updInt) {
    updateInterval = updInt;
  }

  Options({this.D}) {
    String dayString = D.days;
    proportionSet = false;
    for (int i = 0; i < dayString.length; i++) days[i] = dayString[i];
  }

  void displayMessage(String message, Color textCol) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: textCol,
        fontSize: D.P.toastFontSize);
  }

  void confirm() {
    D.days = days.join();
    var interval = updateInterval();
    var hour = interval.containsKey('hour') ? interval['hour'] : D.h;
    var min = interval.containsKey('min') ? interval['min'] : D.m;
    if (D.isIntervalValid(hour, min)) {
      D.h = hour;
      D.m = min;
      D.writeData();
      displayMessage('Changes Applied!', Colors.green);
    } else {
      displayMessage(D.msg, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!proportionSet) {
      final size = MediaQuery.of(context).size;
      D.initialiseProportion(size.height, size.width);
    }
    optionWidgets = [
      ToggleNotifications(D: D),

      TimePickers(D: D),

      DayPickers(
          init: days.join(),
          toggleDay: (int idx) => {days[idx] = days[idx] == '1' ? '0' : '1'},
          D: D),

      IntervalPicker(setUpdateInterval: setUpdateInterval, D: D),
      // End Buttons
      Row(
        mainAxisAlignment: D.P.horizontalAxisAlignment,
        children: <Widget>[
          RaisedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: D.P.endButtonPadding,
            child: Text('Back', style: D.P.style),
            color: Color(0xFF90CAF9),
            shape: D.P.sb,
            colorBrightness: Brightness.dark,
          ),
          RaisedButton(
            onPressed: confirm,
            padding: D.P.endButtonPadding,
            child: Text('Confirm', style: D.P.style),
            color: Color(0xFFFFA726),
            shape: D.P.sb,
            colorBrightness: Brightness.dark,
          )
        ],
      ),
    ];

    return Scaffold(
        body: ListView.separated(
      padding: D.P.overallPadding,
      shrinkWrap: true,
      itemCount: optionWidgets.length,
      itemBuilder: (context, index) => optionWidgets[index],
      separatorBuilder: (context, index) => SizedBox(height: D.P.verticalGap),
    ));
  }
}
