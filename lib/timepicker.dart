import 'package:flutter/material.dart';

import 'data.dart';

class TimePicker extends StatefulWidget {
  final String id;
  Function selectTime;
  final Data D;

  TimePicker({this.id, this.selectTime, this.D});
  @override
  _TimePickerState createState() => _TimePickerState(D.getVal("${id}Hour"), D.getVal("${id}Min"), selectTime);
}

class _TimePickerState extends State<TimePicker> {
  TimeOfDay selectedTime;
  Function selectTime;

  _TimePickerState(int h, int m, Function sT) {
    selectedTime = TimeOfDay(hour: h, minute: m);
    selectTime = sT;
  }

  Future<void> _openTimePicker(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        selectTime(selectedTime);
      });
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
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          InkWell(
              onTap: () => {_openTimePicker(context)},
              child: Text(parseString(), style: TextStyle(fontFamily: 'Roboto', fontSize: 30))
          ),
          RaisedButton(
            onPressed: () => {_openTimePicker(context)},
            padding: EdgeInsets.all(12),
            child: Text(
              widget.id == "start" ? "Pick Start Time" : "Pick End Time",
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Roboto',
                color: Colors.black
              )
            ) 
          )
        ],
      );
  }
}
