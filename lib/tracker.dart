import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Tracker extends CustomPainter {
  static const SIDE_OFFSET = 90;
  static const STROKE_WIDTH_PRCNT = 15;
  static const STEP_CIRCLE_RADIUS_PRCNT = 100;
  static const STEP_SW_INACTIVE = 10;
  static const STEP_SW_ACTIVE = 25;
  static const ANGLE_SHIFT = 90;

  static const INACTIVE_COLOUR = Color(0xff1d1ae8);
  static const ACTIVE_COLOUR = Color(0xffeb891a);

  static const DARK_OUTLINE_COLOUR = Color(0xff000000);
  static const LIGHT_OUTLINE_COLOUR = Color(0xff333333);

  int numActive;
  int stepsToTake;
  double arcAngle;

  Tracker(nA, sTT, aA) {
    numActive = nA;
    stepsToTake = sTT;
    arcAngle = aA;
  }

  @override
  void paint(Canvas canvas, Size size) {
    // Big Circle in the middle
    final radius =
        (size.width - SIDE_OFFSET) / 2; // Expressed in terms of space left
    final strokeWidth =
        STROKE_WIDTH_PRCNT * (radius / 100); // Expressed as a percent of Radius
    final Offset origin = Offset(size.width / 2, size.height / 2);
    final circlePaint = Paint()
      ..color = LIGHT_OUTLINE_COLOUR
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(origin, radius, circlePaint);

    // Loading arc
    final arcPaint = Paint()
      ..color = ACTIVE_COLOUR
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawArc(Rect.fromCircle(center: origin, radius: radius),
        radians(-90), arcAngle, false, arcPaint);

    // Calculate points for the step circles
    var coordinates = List();
    var angles = List();
    final double division = 360 / stepsToTake;
    for (double angle = 0; angle <= 360; angle += division) {
      var angleShifted = angle - ANGLE_SHIFT;
      var angleShiftedRad = radians(angleShifted);
      var x = radius * cos(angleShiftedRad);
      var y = radius * sin(angleShiftedRad);
      coordinates.add(Point(x, y));
      angles.add(angle);
    }

    // Setup Paints for Step Circles
    // Defined relative to strokeWidth
    final stepCircleRadius = STEP_CIRCLE_RADIUS_PRCNT * (strokeWidth / 100);
    final stepPaintInactive = Paint()..color = INACTIVE_COLOUR;
    final stepPaintActive = Paint()..color = ACTIVE_COLOUR;
    final stepOutlineActive = Paint()
      ..color = DARK_OUTLINE_COLOUR
      ..strokeWidth = STEP_SW_ACTIVE * (stepCircleRadius / 100)
      ..style = PaintingStyle.stroke;
    final stepOutline = Paint()
      ..color = DARK_OUTLINE_COLOUR
      ..strokeWidth = STEP_SW_INACTIVE * (stepCircleRadius / 100)
      ..style = PaintingStyle.stroke;
    double arcPos = 2 * pi * radius * (arcAngle / (2 * pi));
    // Draw step cricles
    for (int pointIdx = coordinates.length - 1; pointIdx >= 0; pointIdx--) {
      var point = coordinates[pointIdx];
      double myPos = 2 * pi * radius * (angles[pointIdx] / 360.0);
      bool amIActive = myPos - (stepCircleRadius * 0.80) <= arcPos;
      if (pointIdx == 0) amIActive &= numActive >= 1;
      canvas.drawCircle(
          Offset(point.x + origin.dx, point.y + origin.dy),
          stepCircleRadius,
          amIActive ? stepPaintActive : stepPaintInactive);
      canvas.drawCircle(
          Offset(point.x + origin.dx, point.y + origin.dy),
          stepCircleRadius,
          amIActive ? stepOutlineActive : stepOutline);
    }
  }

  @override
  bool shouldRepaint(Tracker oldDelegate) {
    return oldDelegate.arcAngle != arcAngle ||
        oldDelegate.stepsToTake != stepsToTake ||
        oldDelegate.numActive != numActive;
  }
}

class LoadingScreen extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(LoadingScreen oldDelegate) {
    return false;
  }
}
