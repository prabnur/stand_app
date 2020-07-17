import 'package:flutter/material.dart';

import 'data.dart';

class IntervalPicker extends StatefulWidget {
  final Data D;
  final Function setUpdateInterval;
  IntervalPicker({this.D, this.setUpdateInterval});
  @override
  _IntervalPicker createState() => _IntervalPicker(setUpdateInterval, D: this.D);
}

class _IntervalPicker extends State<IntervalPicker> {
  final Data D;
  final hController = TextEditingController();
  final mController = TextEditingController();

  int h;
  int m;

  _IntervalPicker(Function setUpdateInterval, {this.D}) {
    h = D.h;
    m = D.m;
    setUpdateInterval(updateInterval);
  }

  @override
  void dispose() {
    hController.dispose();
    mController.dispose();
    super.dispose();
  }

  void updateInterval() {
    var hour;
    var min;
    if (hController.text != '') {
      hour = int.parse(hController.text);
      min = mController.text != '' ? int.parse(mController.text) : 0;
    } else if (mController.text != '') {
      hour = 0;
      min = int.parse(mController.text);
    }
    D.h = hour;
    D.m = min;
    setState(() {
      h = hour;
      m = min;
    });
  }

  @override
  Widget build(BuildContext context) {
    return 
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[

        Text(
          'Currently Every \n $h Hr $m Min',
          style: TextStyle(
            fontSize: 25,
            fontFamily: 'Roboto',
            color: Colors.black
          )
        ),
        
        SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IntervalInput(id: 'H', myController: hController),
              IntervalInput(id: 'M', myController: mController)
            ],
          )
        )
        
      ]
    );
  }
}

class IntervalInput extends StatelessWidget {
  static const HEIGHT = 35.0;
  static const WIDTH = 45.0;
  
  final String id;
  final myController;

  IntervalInput({this.id, this.myController});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
              height: HEIGHT,
              width: WIDTH,
              child: TextField(
                  keyboardType: TextInputType.number,
                  controller: myController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ))),
          SizedBox(width: 10),
          Text(id, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ]);
  }
}
