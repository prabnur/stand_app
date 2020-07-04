// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'data.dart';
import 'firestore.dart';
import 'messaging.dart';
import 'options.dart';
import 'tracker.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(color: Colors.white, home: Home());
  }
}

class Home extends StatefulWidget {
  final Data D = new Data();
  _Home createState() => _Home(D: this.D);
}

class _Home extends State<Home> {
  int stepsTaken;
  int stepsToTake;
  bool dataLoaded;
  final Data D;

  _Home({this.D});

  @override
  void initState() {
    super.initState();
    dataLoaded = false;
    D.initState(onFinishedDataLoad);
    FCM.configure();
  }

  void onFinishedDataLoad() {
    setState(() {
      dataLoaded = true;
      stepsTaken = D.stepsTaken;
      stepsToTake = D.stepsToTake;
    });
    print("Data is loaded");
  }

  void takeStep() {
    // TODO
    int noop = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
          CustomPaint(
            painter: Tracker(),
            child: Container(),
          ),
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: Icon(Icons.settings),
                iconSize: 56,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Options(D: this.D)));
                }),
          )
        ]),
        floatingActionButton: FloatingActionButton.extended(
            onPressed: null,
            backgroundColor: Color(0xfffcec03),
            label: Text('Stand',
                style: TextStyle(
                    fontSize: 18, fontFamily: 'Roboto', color: Colors.black)),
            tooltip: 'Press when you stand!')); // TODO add a loading screen
  }
}

// TO:DO link Options(Data D). maybe add a loading animation for it?
