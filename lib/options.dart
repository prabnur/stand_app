import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'timepicker.dart';
import 'intervalpicker.dart';
import 'dayspicker.dart';

class Options extends StatefulWidget {
  final Data D;

  Options({this.D});

  @override
  _Options createState() => _Options(D: this.D);
}

class _Options extends State<Options> {
  static const START = 'start';
  static const END = 'end';

  final Data D;
  final hController = TextEditingController();
  final mController = TextEditingController();
  final List<String> days = new List(7);
  int h;
  int m;

  _Options({this.D}) {
    h = D.h;
    m = D.m;
    String dayString = D.days;

    for(int i=0; i<dayString.length; i++) {
      days[i] = dayString[i];
    }
  }

  @override
  void dispose() {
    hController.dispose();
    mController.dispose();
    super.dispose();
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

  void updateInterval() {
    if (hController.text != '') {
      D.h = int.parse(hController.text);
      D.m = mController.text != '' ? int.parse(mController.text) : 0;
    } else if (mController.text != '') {
      D.h = 0;
      D.m = int.parse(mController.text);
    }
  }

  void confirm() {
    updateInterval();
    D.days = days.join();

    if (D.isDataValid()) {
      D.writeData();
      setState(() {
        h = D.h;
        m = D.m;
      });
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

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    'Currently Every \n $h Hr $m Min',
                    style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'Roboto',
                      color: Colors.black
                    )
                  ),

                  IntervalPicker(hController: this.hController, mController: this.mController, D: D)
                  
                ],
              )
            ),

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
