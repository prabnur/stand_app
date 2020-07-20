import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import "package:flutter_feather_icons/flutter_feather_icons.dart";
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'data.dart';

class ToggleNotifications extends StatefulWidget {
  final Data D;
  ToggleNotifications({this.D});
  @override
  _ToggleNotifications createState() => _ToggleNotifications(D: this.D);
}

class _ToggleNotifications extends State<ToggleNotifications> {
  final Data D;
  bool notifyMe;
  _ToggleNotifications({this.D}) {
    notifyMe = D.notifyMe;
  }

  void toggleNotificationsCupertino(bool newNotifyMe) {
    D.notify = newNotifyMe;
    setState(() {
      notifyMe = newNotifyMe;
    });
    Fluttertoast.showToast(
      msg: D.notifyMe ? 'Notifications Set' : 'Notifications Cancelled',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: Colors.black,
      textColor: D.notifyMe ? Colors.green : Colors.red,
      fontSize: D.P.toastFontSize
    );
  }

  @override 
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Notifications', style: D.P.style),
        SizedBox(width: 20),
        CupertinoSwitch(
          value: notifyMe,
          onChanged: toggleNotificationsCupertino,
          activeColor: Color(0xFFFFA726),
        )
      ],
    );
  }
}
