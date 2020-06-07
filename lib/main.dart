// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

import 'data.dart';
import 'options.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: InitOptions()
    );
  }
}

class InitOptions extends StatefulWidget {
  final Data D = new Data();

  @override
  _InitOptions createState() => _InitOptions(D: this.D);
}

class _InitOptions extends State<InitOptions> {
  bool loaded;
  final Data D;

  _InitOptions({this.D});

  @override
  void initState() {
    super.initState();
    loaded = false;
    D.setLoadConfirm(setLoaded);
    D.initState();
  }

  void setLoaded(bool b) {
    setState(() {
      loaded = b;
    });
    print("Ready to display");
  }

  @override
  Widget build(BuildContext context) {
    return (loaded ? Options(D: this.D) : Scaffold(body: Text('Loading'))); // TO:DO add a loading screen
  }
}
