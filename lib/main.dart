// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home:
        Options()
    );
  }
}

class Options extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TimePicker(
      labelText: "Start Time",
      selectedTime: TimeOfDay(hour: 9, minute: 0),
      selectTime: (nt) => {print(nt)},
      );
  }
}

class TimePicker extends StatelessWidget {
  const TimePicker({
    Key key,
    this.labelText,
    this.selectedTime,
    this.selectTime})
    : super(key: key);
  
  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(context: context, initialTime: selectedTime);
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.bodyText2;
    return Scaffold( 
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(icon: Icon(Icons.edit), onPressed: () {
            _selectTime(context);
          })
        ],
      )
    );
  }
}

class TimeKeeper {
  final String 
}
