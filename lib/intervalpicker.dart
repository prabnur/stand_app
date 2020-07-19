import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    var hour;
    var min;
    Map<String, int> interval = {
      'hour': -1,
      'min': -1,
    };
    bool intvlChanged = false;
    if (hController.text?.isNotEmpty ?? false) {
      hour = int.parse(hController.text);
      min = mController.text?.isNotEmpty ?? false
          ? int.parse(mController.text)
          : 0;
      intvlChanged = true;
    } else if (mController.text?.isNotEmpty ?? false) {
      hour = 0;
      min = int.parse(mController.text);
      intvlChanged = true;
    }
    if (intvlChanged) {
      interval['hour'] = hour;
      interval['min'] = min;
    }
    return interval;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text('Currently every \n $h Hr $m Min', style: D.P.style),
          SizedBox(
              height:
                  (D.P.intervalInputHeight * 2) + D.P.intervalInputsProximity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  IntervalInput(
                    id: 'H',
                    myController: hController,
                    D: D,
                  ),
                  IntervalInput(
                    id: 'M',
                    myController: mController,
                    D: D,
                  )
                ],
              ))
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
                  border: OutlineInputBorder(),
                ),
              )),
          SizedBox(width: D.P.intervalInputsProximity),
          Text(id,
              style: TextStyle(
                  fontFamily: D.P.style.fontFamily,
                  fontSize: D.P.style.fontSize,
                  color: D.P.style.color,
                  fontWeight: FontWeight.bold)),
        ]);
  }
}
