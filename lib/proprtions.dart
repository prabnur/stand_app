import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Proportions {
  static const widths = [375, 400, 425];
  static const heights = [600, 700, 800];
  //                   [225000,               280000,               340000]
  static final areas = [
    widths[0] * heights[0] / (10 ^ 3),
    widths[1] * heights[1] / (10 ^ 3),
    widths[2] * heights[2] / (10 ^ 3)
  ];

  // General
  double paddingTop;
  double paddingBottom;

  double verticalGap;
  double horizontalGap;

  double dayPickerRadius;
  double dayPickerOffset;

  double iconSize;

  double intervalInputHeight;
  double intervalInputWidth;
  double intervalInputsProximity;

  double buttonTextProximity;
  double toastFontSize;

  EdgeInsetsGeometry buttonPadding;
  EdgeInsetsGeometry endButtonPadding;
  EdgeInsetsGeometry overallPadding;

  MainAxisAlignment horizontalAxisAlignment;
  MainAxisAlignment verticalAxisAlignment;

  ShapeBorder sb;

  var style;

  Proportions(h, w) {
    smallPhone(h, w);
  }

  void smallPhone(h, w) {
    final a = h * w;

    style = TextStyle(fontFamily: 'Roboto', fontSize: 27, color: Colors.black);

    paddingTop = 50;
    paddingBottom = 30;

    buttonPadding = EdgeInsets.all(8);
    endButtonPadding = EdgeInsets.all(10);
    overallPadding = EdgeInsets.only(top: 35, bottom: 30);
    buttonTextProximity = 8;

    dayPickerRadius = 55;
    dayPickerOffset = 15;

    horizontalAxisAlignment = MainAxisAlignment.spaceEvenly;

    iconSize = 50;

    intervalInputHeight = 35;
    intervalInputsProximity = 15;
    intervalInputWidth = 45;

    toastFontSize = 20;

    sb = RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: 4),
      borderRadius: BorderRadius.all(Radius.circular(15))
    );

    verticalGap = 40;
  }
}
