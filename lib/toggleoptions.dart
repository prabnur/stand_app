import 'package:flutter/material.dart';
import "package:flutter_feather_icons/flutter_feather_icons.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'data.dart';

class ToggleOptions extends StatelessWidget {
  final Data D;
  ToggleOptions({this.D});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          width: 160,
          child: ToggleShift(D: D),
        ),
        SizedBox(
          width: 185,
          child: ToggleNotifications(D: D)
        )
      ]
    );
  }
}

class ToggleShift extends StatefulWidget {
  final Data D;
  ToggleShift({this.D});
  @override
  _ToggleShift createState() => _ToggleShift(D: this.D);
}

class _ToggleShift extends State<ToggleShift> {
  // Constants
  static const ICON_SIZE = 50.0;
  static const ICON_COLOUR_DAY = Color(0xffffd000);
  static const ICON_COLOUR_NIGHT = Color(0xff09004f);
  final Data D;

  bool dayShift;
  _ToggleShift({this.D});

  @override
  void initState() {
    super.initState();
    dayShift = D.dayShift;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Change Shift',
            style: TextStyle(
                fontSize: 25, fontFamily: 'Roboto', color: Colors.black)),
        IconButton(
            icon: Icon(dayShift ? FeatherIcons.sun : FontAwesomeIcons.moon),
            color: dayShift ? ICON_COLOUR_DAY : ICON_COLOUR_NIGHT,
            iconSize: ICON_SIZE,
            onPressed: () {
              D.dayShift = !dayShift;
              setState(() {
                dayShift = !dayShift;
              });
            })
      ],
    );
  }
}

class ToggleNotifications extends StatefulWidget {
  final Data D;
  ToggleNotifications({this.D});
  @override
  _ToggleNotifications createState() => _ToggleNotifications(D: this.D);
}

class _ToggleNotifications extends State<ToggleNotifications> {
  // Constants
  static const ICON_SIZE = 50.0;
  final Data D;

  bool notifyMe;
  _ToggleNotifications({this.D});

  @override
  void initState() {
    super.initState();
    notifyMe = D.notifyMe;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(notifyMe ? 'Notifications On' : 'Notifications Off',
            style: TextStyle(
                fontSize: 25, fontFamily: 'Roboto', color: Colors.black)),
        IconButton(
            icon:
                Icon(notifyMe ? Icons.notifications : Icons.notifications_off),
            // color: notifyMe ? Colors.green : Colors.red,
            iconSize: ICON_SIZE,
            onPressed: () {
              D.notify = !notifyMe;
              setState(() {
                notifyMe = !notifyMe;
              });
            })
      ],
    );
  }
}
