import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Proportions {
  static const double wSmol = 360.0;
  static const double hSmol = 592.0;

  static const double wBeeg = 411.0;
  static const double hBeeg = 820.0;

  static const double aSmol = wSmol * hSmol;
  static const double aBeeg = wBeeg * hBeeg;

  double verticalGap;
  double horizontalGap;

  double dayPickerRadius;
  double dayPickerOffset;

  double intervalInputHeight;
  double intervalInputWidth;
  double intervalInputsProximity;

  double buttonTextProximity;
  double toastFontSize;

  EdgeInsetsGeometry buttonPadding;
  double buttonPaddingNum;

  EdgeInsetsGeometry endButtonPadding;
  double endButtonPaddingNum;

  EdgeInsetsGeometry overallPadding;
  double overallPaddingTop;
  double overallPaddingBottom;

  MainAxisAlignment horizontalAxisAlignment;

  ShapeBorder sb;
  double borderWidth;
  double borderRadius;

  var style;
  double fontSize;

  Proportions();

  static Proportions construct(h, w) {
    final a = h * w;
    Proportions lerp = Proportions();
    Proportions big = beeg();
    Proportions small = smol();

    // Stuff that stays the same
    lerp.buttonTextProximity = 7;
    lerp.horizontalAxisAlignment = MainAxisAlignment.spaceEvenly;
    lerp.toastFontSize = 20;

    // Linear Interpolation
    lerp.fontSize = linterpolate(a, aSmol, small.fontSize, aBeeg, big.fontSize);
    lerp.style = TextStyle(
        fontFamily: 'Roboto', fontSize: lerp.fontSize, color: Colors.black);

    lerp.buttonPaddingNum = linterpolate(a, aSmol, small.buttonPaddingNum, aBeeg, big.buttonPaddingNum);
    lerp.endButtonPaddingNum = linterpolate(a, aSmol, small.endButtonPaddingNum, aBeeg, big.endButtonPaddingNum);
    lerp.overallPaddingTop = linterpolate(h, hSmol, small.overallPaddingTop, hBeeg, big.overallPaddingTop);
    lerp.overallPaddingBottom = linterpolate(h, hSmol, small.overallPaddingBottom, hBeeg, big.overallPaddingBottom);

    lerp.buttonPadding = EdgeInsets.all(lerp.buttonPaddingNum);
    lerp.endButtonPadding = EdgeInsets.all(lerp.endButtonPaddingNum);
    lerp.overallPadding = EdgeInsets.only(top: lerp.overallPaddingTop, bottom: lerp.overallPaddingBottom);

    lerp.dayPickerRadius = linterpolate(a, aSmol, small.dayPickerRadius, aBeeg, big.dayPickerRadius);
    lerp.dayPickerOffset = linterpolate(a, aSmol, small.dayPickerOffset, aBeeg, big.dayPickerOffset);

    lerp.intervalInputHeight = linterpolate(h, hSmol, small.intervalInputHeight, hBeeg, big.intervalInputHeight);
    lerp.intervalInputsProximity = linterpolate(h, hSmol, small.intervalInputsProximity, hBeeg, big.intervalInputsProximity);
    lerp.intervalInputWidth = linterpolate(w, wSmol, small.intervalInputWidth, wBeeg, big.intervalInputWidth);

    lerp.borderRadius = linterpolate(a, aSmol, small.borderRadius, aBeeg, big.borderRadius);
    lerp.borderWidth = linterpolate(a, aSmol, small.borderWidth, aBeeg, big.borderWidth);
    lerp.sb = RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: lerp.borderWidth),
      borderRadius: BorderRadius.all(Radius.circular(lerp.borderRadius))
    );

    lerp.verticalGap = linterpolate(h, hSmol, small.verticalGap, hBeeg, big.verticalGap);

    return lerp;
  }

  static Proportions beeg() {
    Proportions beeg = Proportions();
    beeg.fontSize = 32;

    beeg.buttonPaddingNum = 12;
    beeg.endButtonPaddingNum = 15;
    beeg.overallPaddingTop = 60;
    beeg.overallPaddingBottom = 40;

    beeg.dayPickerRadius = 70;
    beeg.dayPickerOffset = 25;

    beeg.intervalInputHeight = 60;
    beeg.intervalInputsProximity = 15;
    beeg.intervalInputWidth = 70;

    beeg.borderRadius = 20;
    beeg.borderWidth = 5;

    beeg.verticalGap = 52;
    return beeg;
  }

  static Proportions smol() {
    Proportions smol = Proportions();
    smol.fontSize = 27;

    smol.buttonPaddingNum = 9;
    smol.endButtonPaddingNum = 12;
    smol.overallPaddingTop = 45;
    smol.overallPaddingBottom = 30;

    smol.dayPickerRadius = 55;
    smol.dayPickerOffset = 15;

    smol.intervalInputHeight = 35;
    smol.intervalInputsProximity = 12;
    smol.intervalInputWidth = 55;

    smol.borderRadius = 15;
    smol.borderWidth = 4;

    smol.verticalGap = 40;
    return smol;
  }

  static double linterpolate(double x, double x1, double y1, double x2, double y2) {
    var result = y1 + ((x - x1) * ((y2 - y1) / (x2 - x1)));
    return roundDouble(result, 2);
  }

  static double roundDouble(double value, int places) {
    double mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }
}
