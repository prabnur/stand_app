import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';

import 'data.dart';

class TimePickers extends StatelessWidget {
  final Data D;
  static const START = 'start';
  static const END = 'end';

  TimePickers({this.D});

  void setTime(String id, TimeOfDay newTime) {
    if (id == START) {
      D.startHour = newTime.hour;
      D.startMin = newTime.minute;
    } else if (id == END) {
      D.endHour = newTime.hour;
      D.endMin = newTime.minute;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: D.P.horizontalAxisAlignment,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        TimePicker(
          id: START,
          selectTime: (TimeOfDay newTime) => {setTime(START, newTime)},
          D: this.D,
        ),
        TimePicker(
          id: END,
          selectTime: (TimeOfDay newTime) => {setTime(END, newTime)},
          D: this.D,
        )
      ],
    );
  }
}

class TimePicker extends StatefulWidget {
  static const START = 'start';
  static const END = 'end';
  final String id;
  final Function selectTime;
  final Data D;

  TimePicker({this.id, this.selectTime, this.D});

  @override
  _TimePickerState createState() =>
      _TimePickerState(selectTime, D: D, id: id);
}

class _TimePickerState extends State<TimePicker> {
  static const START = 'start';
  static const END = 'end';
  final Data D;
  final String id;
  TimeOfDay selectedTime;
  Function selectTime;

  _TimePickerState(Function sT, {this.D, this.id}) {
    selectTime = sT;
  }

  @override
  void initState() {
    super.initState();
    selectedTime = id == START
        ? TimeOfDay(hour: D.startHour, minute: D.startMin)
        : TimeOfDay(hour: D.endHour, minute: D.endMin);
  }

  Color getHourColour(int hour) {
    if ((0 <= hour && hour <= 5) || (18 < hour && hour <= 24))
      return Color(0xFF263238);
    else if (hour <= 15)
      return Color(0xFF90CAF9);
    else // if (hour <= 18)
      return Color(0xFFFFA726);
  }

  void _openTimePicker(BuildContext context) {
    D.feedback(FeedbackType.light);
    Navigator.of(context).push(
      showPicker(
        context: context,
        value: selectedTime,
        onChange: (newTime) {
          selectTime(newTime);
          setState(() {
            selectedTime = newTime;
          });
        },
      ),
    );
  }

  String parseString() {
    int h = selectedTime.hour;
    int m = selectedTime.minute;
    String suffix = 'AM';
    if (h >= 12) {
      suffix = 'PM';
      h = h % 12;
    }
    if (h < 10) {
      if (m < 10)
        return '0$h:0$m $suffix';
      else
        return '0$h:$m $suffix';
    } else {
      if (m < 10)
        return '$h:0$m $suffix';
      else
        return '$h:$m $suffix';
    }
  }

  @override
  Widget build(BuildContext context) {
    //final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2;
    Color hourColor = getHourColour(selectedTime.hour);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(widget.id == START ? 'Start Time' : 'End Time', style: D.P.style),
        SizedBox(height: D.P.buttonTextProximity),
        RaisedButton(
          onPressed: () => {_openTimePicker(context)},
          padding: D.P.buttonPadding,
          child: Text(parseString(),
              style: TextStyle(
                  fontFamily: 'RobotoMono',
                  fontSize: D.P.style.fontSize,
                  color: hourColor == Color(0xFF263238)
                      ? Colors.white
                      : Colors.black)),
          color: hourColor,
          shape: D.P.sb,
        ),
      ],
    );
  }
}
