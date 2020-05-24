import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DayPickers extends StatelessWidget {
  final List<String> vals = new List(7);
  final List<String> days = List.unmodifiable(["M", "Tu", "W", "Th", "F", "Sa", "S"]);
  final List<Widget> children = new List(7);
  final String init;
  final Function toggleDay;

  DayPickers({this.init, this.toggleDay}) {
    assert(init.length == vals.length);

    for(int i=0; i<init.length; i++) {
      vals[i] = init[i];
      assert(vals[i] == "1" || vals[i] == "0");
    }

    for(int i=0; i<children.length; i++) {
      children[i] = DayPicker(day: days[i], active: (vals[i] == "1"), toggle: () => {toggleDay(i)});
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: children
    );
  }
}

class DayPicker extends StatefulWidget {
  final String day;
  final bool active;
  final Function toggle;
  DayPicker({this.day, this.active, this.toggle});

  _DayPicker createState() => _DayPicker(active: this.active, toggle: this.toggle);
}

class _DayPicker extends State<DayPicker> {
  bool active;
  final double size = 50;
  final Function toggle;

  _DayPicker({this.active, this.toggle});

  void press() {
    setState(() {
      active = !active;
    });
    toggle();
  }

  @override
  Widget build(BuildContext context) {
    return
    MaterialButton(
      onPressed: press,
      elevation: 2.0,
      color: (active ? Colors.black : Colors.white),
      minWidth: size,
      height: size,
      shape: CircleBorder(side: BorderSide(color: Colors.black, width: 3)),//CircleBorder(side: BorderSide(color: Colors.black)),
      child: Text(
        widget.day,
        style: TextStyle(
          fontFamily: "Robato",
          fontSize: 20,
          color: (active ? Colors.white : Colors.black)
        ),
      )
    );
  }
}
