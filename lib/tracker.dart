import 'package:flutter/material.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart';

class Tracker extends CustomPainter {
  static const SIDE_OFFSET = 90;
  static const STROKE_WIDTH_PRCNT = 15;
  static const STEP_CIRCLE_RADIUS_PRCNT = 105;
  static const STEP_STROKE_WIDTH_PRCNT = 25;
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
    final double division = 360 / stepsToTake;
    for (double angle = 0; angle <= 360; angle += division) {
      var angleShifted = angle - ANGLE_SHIFT;
      var angleShiftedRad = radians(angleShifted);
      var x = radius * cos(angleShiftedRad);
      var y = radius * sin(angleShiftedRad);
      coordinates.add(Point(x, y));
    }

    // Setup Paints for Step Circles
    // Defined relative to strokeWidth
    final stepCircleRadius = STEP_CIRCLE_RADIUS_PRCNT * (strokeWidth / 100);
    final stepPaintInactive = Paint()..color = INACTIVE_COLOUR;
    final stepPaintActive = Paint()..color = ACTIVE_COLOUR;
    final stepOutlineLast = Paint()
      ..color = DARK_OUTLINE_COLOUR
      ..strokeWidth = STEP_STROKE_WIDTH_PRCNT * (stepCircleRadius / 100)
      ..style = PaintingStyle.stroke;
    final stepOutline = Paint()
      ..color = INACTIVE_COLOUR
      ..strokeWidth = STEP_STROKE_WIDTH_PRCNT * (stepCircleRadius / 100)
      ..style = PaintingStyle.stroke;

    // Draw step cricles
    for (int pointIdx = coordinates.length-1; pointIdx >= 0; pointIdx--) {
      var point = coordinates[pointIdx];
      canvas.drawCircle(
          Offset(point.x + origin.dx, point.y + origin.dy),
          stepCircleRadius,
          pointIdx <= numActive-1 ? stepPaintActive : stepPaintInactive);

      canvas.drawCircle(
          Offset(point.x + origin.dx, point.y + origin.dy),
          stepCircleRadius,
          pointIdx == numActive-1 ? stepOutlineLast : stepOutline
      );
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
