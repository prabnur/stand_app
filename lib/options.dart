import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'data.dart';

class Options extends StatelessWidget {
  final Data D;
  Options({this.D});
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Container( 
              child: Description()
            ),
            TimePicker(
              id: "start",
              selectTime: (nt) => {print(nt)},
              D: this.D
            ),
            TimePicker(
              id: "end",
              selectTime: (nt) => {print(nt)},
              D: this.D
            ),
            IntervalPicker(D: this.D),
            RaisedButton(onPressed: null, child: Text('Back'))
          ],
        )
      )
    );
  }
}

class TimePicker extends StatefulWidget {
  final String id;
  final ValueChanged<TimeOfDay> selectTime;
  final Data D;

  TimePicker({this.id, this.selectTime, this.D});

  @override
  _TimePickerState createState() => _TimePickerState(D.getVal("${id}Hour"), D.getVal("${id}Min"));
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay selectedTime;

  _TimePickerState(int h, int m) {
    selectedTime = TimeOfDay(hour: h, minute: m);
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
      widget.selectTime(picked);
    }
  }

  String parseString() {
    int h = selectedTime.hour;
    int m = selectedTime.minute;
    String suffix = " AM";
    if (h>12) {
      suffix = " PM";
      h = h % 12;
    }
    if(h<10) {
      if (m<10) return '0$h:0$m$suffix';
      else return '0$h:$m$suffix';
    } else {
      if (m<10) return '$h:0$m$suffix';
      else return '$h:$m$suffix';
    }
  }

  @override
  Widget build(BuildContext context) {
    //final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2;
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          RaisedButton(
            onPressed: () => {_selectTime(context)}, 
            child: Text(widget.id == "start" ? "Start Time" : "End Time")
          ),
          Text(parseString(), style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Roboto'))
        ],
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
                TextSpan(text: 'between the '),
                TextSpan(text: 'Start Time ', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: 'and the '),
                TextSpan(text: 'End Time ', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
        )
      );
  }
}

class IntervalPicker extends StatefulWidget {
  final Data D;
  IntervalPicker({this.D});
  @override
  _IntervalPickerState createState() => _IntervalPickerState(D.getVal("intvlHour"), D.getVal("intvlMin"));
}

class _IntervalPickerState extends State<IntervalPicker> {
  String hour, minute;
  _IntervalPickerState(int h, int m) {
    hour = h.toString();
    minute = m.toString();
  }
  @override
  Widget build(BuildContext context) {
    return 
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            RaisedButton(
              onPressed: null,
              child: Text('Set Interval'),
              ), 
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  SizedBox(
                    height: 45,
                    width: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: hour
                      )
                    )
                  ),
                  Text(":", style: TextStyle(fontWeight: FontWeight.bold),),
                  SizedBox(
                    height: 45,
                    width: 50,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: minute
                      )
                    )
                  ),
                ],
              )
          ],
        )
      );
  }
}
