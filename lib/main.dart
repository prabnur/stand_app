// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vmath;
import 'dart:math';

import 'data.dart';
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

  @override
  _Home createState() => _Home(D: this.D);
}

class _Home extends State<Home> with TickerProviderStateMixin {
  // Basic State
  int stepsTaken;
  int stepsToTake;
  int numActive;
  bool dataLoaded;

  // Model
  final Data D;

  // Animation stuff
  static const ANIMATION_DURATION = 700; // ms
  Animation<double> animation;
  AnimationController ac;
  Tween<double> arcTween;

  _Home({this.D});

  @override
  void initState() {
    super.initState();
    dataLoaded = false;
    D.initState(onFinishedDataLoad);
  }

  void onFinishedDataLoad() {
    setState(() {
      stepsTaken = D.stepsTaken;
      stepsToTake = D.stepsToTake;
      //print("Steps to take (Main) $stepsToTake");
      dataLoaded = true;
      numActive = stepsTaken;
      arcTween = Tween(begin: 0, end: vmath.radians(360));
    });
    print("Data is loaded");
    ac = AnimationController(
        duration: Duration(milliseconds: ANIMATION_DURATION * stepsToTake),
        value: (stepsTaken - 1) / stepsToTake,
        vsync: this);

    animation = arcTween.animate(ac)
      ..addListener(() {
        if (animation.value >=
            arcTween.transform((stepsTaken - 1) * 1.0 / stepsToTake)) {
          setState(() {
            numActive++;
          });
          ac.stop();
        } else
          setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          ac.reset();
          stepsTaken = 0;
          numActive = 0;
        }
      });
    print(animation == null ? 'animation null' : 'animation good');
  }

  @override
  void dispose() {
    super.dispose();
    ac.dispose();
  }

  void takeStep() {
    // TODO
    setState(() {
      stepsTaken++;
      numActive = numActive == 0 ? numActive + 1 : numActive;
    });
    if (stepsTaken > 1) ac.forward();
    D.updateSteps(stepsTaken, stepsToTake);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
          /*
          AnimatedBuilder(
              animation: animation,
              builder: (context, snapshot) {
                return */
          CustomPaint(
            painter: dataLoaded
                ? Tracker(numActive, stepsToTake, animation.value)
                : LoadingScreen(),
            child: Container(),
          ),
          //;}),
          Align(
            alignment: Alignment.bottomLeft,
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
            onPressed: takeStep,
            backgroundColor: Color(0xfffcec03),
            label: Text('Stand',
                style: TextStyle(
                    fontSize: 22, fontFamily: 'Roboto', color: Colors.black)),
            tooltip: 'Press when you stand!')); // Maybe add a loading screen
  }
}
