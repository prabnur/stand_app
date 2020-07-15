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
  static const START = 'start';
  static const END = 'end';

  final Data D;
  final List<String> days = new List(7);

  Function updateInterval;
  void setUpdateInterval(updInt) {
    updateInterval = updInt;
  }

  Options({this.D}) {
    String dayString = D.days;

    for(int i=0; i<dayString.length; i++) {
      days[i] = dayString[i];
    }
  }

  void setTime(String id, TimeOfDay newTime) {
    if(id == START) {
      D.startHour = newTime.hour;
      D.startMin = newTime.minute;
    } else if (id == END) {
      D.endHour = newTime.hour;
      D.endMin = newTime.minute;
    }
  }

  void displayMessage(String message, Color textCol) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: textCol,
      fontSize: 18
    );
  }

  void confirm() {
    updateInterval();
    D.days = days.join();
    if (D.isDataValid()) {
      D.writeData();
      displayMessage('Changes Applied!', Colors.green);
    } else {
      displayMessage(D.msg, Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold (
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ToggleOptions(D: D),

            TimePicker(
              id: 'start',
              selectTime: (TimeOfDay newTime) => {setTime('start', newTime)},
              D: this.D
            ),

            TimePicker(
              id: 'end',
              selectTime: (TimeOfDay newTime) => {setTime('end', newTime)},
              D: this.D
            ),

            IntervalPicker(setUpdateInterval: setUpdateInterval, D: D),
                  
            DayPickers(init: days.join(), toggleDay: (int idx) => {days[idx] = days[idx] == '1' ? '0' : '1'}),
            // End Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[

                RaisedButton(
                  onPressed: () => {Navigator.pop(context)},
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Back',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto'
                    ),
                  )
                ),

                RaisedButton(
                  onPressed: confirm,
                  padding: EdgeInsets.all(12),
                  child: Text(
                    'Confirm',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Roboto'
                    ),
                  )
                )
                
              ],
            ),

          ],
        )
      )
    );
  }
}
