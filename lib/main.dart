// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'dart:math';

import 'confetti.dart';
import 'data.dart';
import 'tray.dart';
import 'tracker.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(color: Colors.white, home: Home(), debugShowCheckedModeBanner: false,);
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
  bool dataLoaded;

  // Model
  final Data D;

  // Primary Message
  static const PRIMARY_MESSAGE = 'Breathe';
  static const SECONDARY_MESSAGE = 'Great Job!';
  String mainText = PRIMARY_MESSAGE;

  // Animation stuff
  static const STEP_DURATION = 300;
  int animationDuration; // ms
  Animation<double> animation;
  AnimationController ac;
  Tween<double> arcTween;
  bool reversing;

  // Logo
  Image logo;
  static const LOGO_WIDTH = 1778.0;
  static const LOGO_HEIGHT = 2459.0;
  static const LOGO_SCALE_FACTOR = 0.09;

  // Confetti
  Function blastAway;

  _Home({this.D});

  @override
  void initState() {
    super.initState();
    dataLoaded = false;
    reversing = false;
    D.initState(onFinishedDataLoad);
  }

  void onFinishedDataLoad() {
    setState(() {
      stepsTaken = D.stepsTaken;
      stepsToTake = D.stepsToTake;
      dataLoaded = true;
      arcTween = Tween(begin: 0, end: 2 * pi);
      animationDuration = STEP_DURATION * stepsToTake;
    });
    print('Data is loaded');
    ac = AnimationController(
        duration: Duration(milliseconds: animationDuration),
        value: (stepsTaken - 1) / stepsToTake,
        vsync: this);

    animation = arcTween.animate(ac)
      ..addListener(() {
        if (!reversing &&
            animation.value >=
                arcTween.transform((stepsTaken) * 1.0 / stepsToTake)) ac.stop();
        if (reversing &&
            animation.value <=
                arcTween.transform((stepsTaken) * 1.0 / stepsToTake)) {
          ac.stop();
          reversing = false;
        }
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          print('Animation completed');
          ac.reset();
          setState(() {
            stepsTaken = 0;
            mainText = SECONDARY_MESSAGE;
          });
          blastAway();
        } else if (status == AnimationStatus.dismissed) {
          print('Reverse Animation completed');
          reversing = false;
          ac.reset();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    ac.dispose();
  }

  void takeStep() {
    if (mainText == SECONDARY_MESSAGE) {
      setState(() {
        mainText = PRIMARY_MESSAGE;
      });
    }
    if (D.canVibrate) Vibrate.feedback(FeedbackType.success);
    setState(() {
      stepsTaken++;
    });
    if (stepsTaken == stepsToTake)
      D.updateSteps(0, stepsToTake);
    else
      D.updateSteps(stepsTaken, stepsToTake);
    ac.forward();
  }

  void reverseStep() {
    if (stepsTaken == 0) return;
    if (D.canVibrate) Vibrate.feedback(FeedbackType.success);
    ac.reverseDuration = Duration(milliseconds: STEP_DURATION * stepsTaken);
    print('New Steps take $stepsTaken');
    print("Reverse");
    setState(() {
      stepsTaken--;
    });
    D.updateSteps(stepsTaken, stepsToTake);
    reversing = true;
    ac.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        Align(
          alignment: Alignment(0, -0.80),
          child: Text(
            mainText,
            style: TextStyle(fontFamily: 'RobotoMono', fontSize: 42),
          ),
        ),
        Align(
          alignment: Alignment(0, -0.45),
          child: ConfettiShooter(setBlastAway: (blastAwayFunc) {
            blastAway = blastAwayFunc;
          }),
        ),
        Align(
          alignment: Alignment.center,
          child: Image.asset('images/logo.png',
              width: LOGO_WIDTH * LOGO_SCALE_FACTOR,
              height: LOGO_HEIGHT * LOGO_SCALE_FACTOR,
              repeat: ImageRepeat.noRepeat),
        ),
        CustomPaint(
          painter: dataLoaded
              ? Tracker(stepsToTake, animation.value)
              : LoadingScreen(),
          child: Container(),
        ),
        Tray(
          D: this.D,
          reverseStep: reverseStep,
          takeStep: takeStep,
        )
      ]),
      //floatingActionButton:
    ); // Maybe add a loading screen
  }
}
