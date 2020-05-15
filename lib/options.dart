import 'dart:ui';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import 'data.dart';
import 'timepicker.dart';
import 'intervalpicker.dart';

class Options extends StatefulWidget {
  final Data D;

  Options({this.D});

  @override
  _Options createState() => _Options(D: this.D);
}

class _Options extends State<Options> {
  final Data D;
  final hController = TextEditingController();
  final mController = TextEditingController();
  int H;
  int M;

  _Options({this.D}) {
    H = D.getVal("H");
    M = D.getVal("M");
  }

  @override
  void dispose() {
    hController.dispose();
    mController.dispose();
    super.dispose();
  }

  void setTime(String id, TimeOfDay newTime) {
    D.setVal("${id}Hour", newTime.hour);
    D.setVal("${id}Min", newTime.minute);
  }

  void setInterval(String id, int val) {
    D.setVal(id, val);
  }

  void displayMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: Colors.red,
      fontSize: 18
    );
  }

  void confirm() {
    if (hController.text != "") {
      D.setVal("H", int.parse(hController.text));
    }
    if (mController.text != "") {
      D.setVal("M", int.parse(mController.text));
    }

    if (D.isDataValid()) {
      D.writeData();
      setState(() {
        H = D.getVal("H");
        M = D.getVal("M");
      });
    } else {
      displayMessage(D.getMsg);
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

            Container(
              child: Description()
            ),

            TimePicker(
              id: "start",
              selectTime: (TimeOfDay newTime) => {setTime("start", newTime)},
              D: this.D
            ),

            TimePicker(
              id: "end",
              selectTime: (TimeOfDay newTime) => {setTime("end", newTime)},
              D: this.D
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    'Currently Every \n $H Hr $M Min',
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

class Description extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double margin = 20;
    const double fontSize = 26;
    return
        Container(
          margin: const EdgeInsets.only(left: margin, right: margin), 
          child: RichText(
            text: TextSpan(
              text: 'This app will remind you to stand at every ',
              style: 
                TextStyle(
                  color: Colors.black,
                  fontFamily: 'Roboto',
                  fontSize: fontSize
                ),
              children: <TextSpan> [
                TextSpan(text: 'interval ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'after the '),
                TextSpan(text: 'Start Time ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'up till the '),
                TextSpan(text: 'End Time ', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
        )
      );
  }
}