import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'data.dart';

class DayPickers extends StatelessWidget {
  final List<String> vals = new List(7);
  final List<String> dayAcronyms =
      List.unmodifiable(['M', 'Tu', 'W', 'Th', 'F', 'Sa', 'S']);
  final List<Widget> dayPickerList = new List(7);
  final Data D;
  final String init;
  final Function toggleDay;

  DayPickers({this.init, this.toggleDay, this.D}) {
    assert(init.length == vals.length);

    for (int i = 0; i < init.length; i++) {
      vals[i] = init[i];
      assert(vals[i] == '1' || vals[i] == '0');
    }

    for (int i = 0; i < dayPickerList.length; i++)
      dayPickerList[i] = DayPicker(
          day: dayAcronyms[i],
          active: (vals[i] == '1'),
          toggle: () => {toggleDay(i)},
          D: D);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: (D.P.dayPickerRadius * 2) + D.P.dayPickerOffset,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: dayPickerList.sublist(0, 4)),
          Stack(
            children: <Widget>[
              Align(
                alignment: Alignment(-0.56, 0),
                child: dayPickerList[4],
              ),
              Align(
                alignment: Alignment(0, 0),
                child: dayPickerList[5],
              ),
              Align(
                alignment: Alignment(0.56, 0),
                child: dayPickerList[6],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class DayPicker extends StatefulWidget {
  final String day;
  final Data D;
  final bool active;
  final Function toggle;
  DayPicker({this.day, this.active, this.toggle, this.D});

  _DayPicker createState() =>
      _DayPicker(active: this.active, toggle: this.toggle, D: D);
}

class _DayPicker extends State<DayPicker> {
  bool active;
  final Data D;
  final Function toggle;

  _DayPicker({this.active, this.toggle, this.D});

  void press() {
    if (D.canVibrate) Vibrate.feedback(FeedbackType.light);
    setState(() {
      active = !active;
    });
    toggle();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        onPressed: press,
        elevation: 2.0,
        color: (active ? Colors.black : Colors.white),
        minWidth: D.P.dayPickerRadius,
        height: D.P.dayPickerRadius,
        shape: CircleBorder(
            side: BorderSide(
                color: Colors.black, width: (4 * D.P.dayPickerRadius) / 50)),
        child: Text(
          widget.day,
          style: TextStyle(
              fontFamily: D.P.style.fontFamily,
              fontSize: D.P.style.fontSize,
              color: (active ? Colors.white : Colors.black)),
        ));
  }
}
