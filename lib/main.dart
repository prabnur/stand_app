// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'options.dart';
import 'data.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home: OptionsWrapper()
    );
  }
}

class OptionsWrapper extends StatefulWidget {
  @override
  _OptionsWrapperState createState() => _OptionsWrapperState();
}

class _OptionsWrapperState extends State<OptionsWrapper> {
  bool loaded;
  final Data D = new Data();

  _OptionsWrapperState();

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
    return (loaded ? Options(D: D) : Scaffold(body: Text('Loading'))); // TO:DO add a loading screen
  }
}
