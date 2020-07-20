import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'data.dart';

class IntervalPicker extends StatefulWidget {
  final Data D;
  final Function setUpdateInterval;
  IntervalPicker({this.D, this.setUpdateInterval});
  @override
  _IntervalPicker createState() =>
      _IntervalPicker(setUpdateInterval, D: this.D);
}

class _IntervalPicker extends State<IntervalPicker> {
  final Data D;
  final hController = TextEditingController();
  final mController = TextEditingController();

  int h;
  int m;

  _IntervalPicker(Function setUpdateInterval, {this.D}) {
    h = D.h;
    m = D.m;
    setUpdateInterval(updateInterval);
    D.updateIntervalState = updateIntervalState;
  }

  @override
  void dispose() {
    hController.dispose();
    mController.dispose();
    super.dispose();
  }

  bool isEmpty(String s) {
    return s?.isEmpty ?? false;
  }

  void updateIntervalState() {
    setState(() {
      h = D.h;
      m = D.m;
    });
  }

  Map<String, int> updateInterval() {
    Map<String, int> interval = {};
    if (hController.text?.isNotEmpty ?? false) {
      int hour = int.tryParse(hController.text);
      if (hour != null)
        interval['hour'] = hour;
      else
        displayError('Please check the value of H');
    }
    if (mController.text?.isNotEmpty ?? false) {
      int min = int.parse(mController.text);
      if (min != null)
        interval['min']= min;
      else
        displayError('Please check the value of M');
    }
    return interval;
  }

   void displayError(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black,
        textColor: Colors.red,
        fontSize: D.P.toastFontSize);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Currently every \n $h Hr $m Min', style: D.P.style),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IntervalInput(
                id: 'H',
                myController: hController,
                D: D,
              ),
              SizedBox(height: D.P.intervalInputsProximity),
              IntervalInput(
                id: 'M',
                myController: mController,
                D: D,
              )
            ],
          )
        ]);
  }
}

class IntervalInput extends StatelessWidget {
  final String id;
  final myController;
  final Data D;

  IntervalInput({this.id, this.myController, this.D});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: D.P.intervalInputHeight,
            width: D.P.intervalInputWidth,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: myController,
              decoration: InputDecoration(
                labelText: id,
                labelStyle: D.P.style,
                isDense: true,
                border: OutlineInputBorder(),
              ),
              style: TextStyle(
                  fontFamily: D.P.style.fontFamily,
                  color: D.P.style.color,
                  fontSize: D.P.style.fontSize - 4
              ),
            )
          ),
        ]);
  }
}
