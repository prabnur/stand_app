import 'package:flutter/material.dart';
import 'dart:io' show Platform;

class HelpButton extends StatelessWidget {
  static const HELP_SIZE = 40.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: (Platform.isAndroid ? 25 : 10)),
        MaterialButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => Description()
            );
          },
          color: Colors.black,
          minWidth: HELP_SIZE,
          height: HELP_SIZE,
          shape: CircleBorder(side: BorderSide(color: Colors.black, width: 3)),//CircleBorder(side: BorderSide(color: Colors.black)),
          child: Text(
            '?',
            style: TextStyle( 
              fontFamily: 'Robato',
              fontSize: 26,
              color: Colors.white
            ),
          )
        )
      ],
    );
  }
}

class Description extends StatelessWidget {
  // Overall Box
  static const double ELEVATION = 3.0;
  static const double BORDER_RADIUS = 25.0;
  static const double BORDER_WIDTH = 5.0;

  // Content
  static const double CONTENT_PAD = 30;

  // Actions
  static const double ACTIONS_PAD = 20;

  // Both
  static const double FONT_SIZE = 25;

  @override
  Widget build(BuildContext context) {
    return
    AlertDialog(
      contentPadding: const EdgeInsets.only(
        top: CONTENT_PAD,
        left: CONTENT_PAD,
        right: CONTENT_PAD
      ),
      elevation: ELEVATION,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.black, width: BORDER_WIDTH),
        borderRadius: BorderRadius.all(Radius.circular(BORDER_RADIUS))
      ),
      content: RichText(
        text: TextSpan(
          text: 'This app will remind you to stand at every ',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Roboto',
            fontSize: FONT_SIZE
          ),
          children: <TextSpan> [
            TextSpan(text: 'interval ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'after the '),
            TextSpan(text: 'Start Time ', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: 'up till the '),
            TextSpan(text: 'End Time', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '.')
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () { Navigator.of(context).pop(); },
          child: Text('Got It',
            style: TextStyle(fontFamily: 'Roboto', fontSize: FONT_SIZE)
          ),
          padding: EdgeInsets.all(ACTIONS_PAD),
        )
      ],
      
    );
  }
}
