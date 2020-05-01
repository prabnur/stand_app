import 'package:flutter/material.dart';

import 'data.dart';

class IntervalPicker extends StatelessWidget {
  final hController;
  final mController;
  final Data D;

  IntervalPicker({this.hController, this.mController, this.D}); 

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[

          Text(
            'Currently Every \n ${D.getVal("H")} Hr ${D.getVal("M")} Min',
            style: TextStyle(
              fontSize: 25,
              fontFamily: 'Roboto',
              color: Colors.black
            )
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IntervalInput(id: "H", myController: hController),
              SizedBox(height: 20),
              IntervalInput(id: "M", myController: mController)
            ],
          )
          
        ],
      )
    );   
  }
}

class IntervalInput extends StatelessWidget {
  final String id;
  final myController;

  IntervalInput({this.id, this.myController});
  /*
  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }
  */

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(
            height: 40,
            width: 45,
            child: TextField(
              keyboardType: TextInputType.number,
              controller: myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              )
            )
          ),
          SizedBox(width: 10),
          Text(id, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        ]
    );
  }
}

