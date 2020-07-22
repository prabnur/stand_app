import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data.dart';
import 'description.dart';
import 'options.dart';


class Tray extends StatelessWidget {
  static const ICON_SIZE = 60.0;

  final Data D;
  final Function reverseStep;
  final Function takeStep;

  Tray({this.D, this.reverseStep, this.takeStep});

  @override
  Widget build(BuildContext context) {
    return
    Align(
      alignment: Alignment.bottomLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: 10,),
              HelpButton()
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.settings, color: Colors.black,),
                iconSize: ICON_SIZE,
                onPressed: () {
                  D.backup();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => new Options(D: this.D))
                  );
                }
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  FloatingActionButton.extended(
                    onPressed: reverseStep,
                    backgroundColor: Colors.black,
                    label: FaIcon(FontAwesomeIcons.undoAlt, size: 25, color: Colors.white,),
                    heroTag: 'takeStep',
                  ),
                  SizedBox(width: 15,),
                  FloatingActionButton.extended(
                    onPressed: takeStep,
                    backgroundColor: Color(0xfffcec03),
                    elevation: 5,
                    label: Text(
                      'Stand',
                      style: TextStyle(
                        fontSize: 25,
                        fontFamily: 'Roboto',
                        color: Colors.black
                      )
                    ),
                    tooltip: 'Press when you stand!',
                    heroTag: 'reverseStep',
                  ),
                  SizedBox(width: 15,)
                ],
              ),
            ],
      )
        ],
      )
    );
  }
}
