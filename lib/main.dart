// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'options.dart';
import 'data.dart';

void main() => runApp(Home());

class Home extends StatelessWidget {
  Data D = Data();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.white,
      home:
        Options(D: this.D)
    );
  }
}
