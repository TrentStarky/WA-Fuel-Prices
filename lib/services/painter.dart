import 'dart:ui';

import 'package:flutter/widgets.dart';

///CLASS: TrianglePainter
///Paints a triangle
class TrianglePainter extends CustomPainter {
  final Color fillColor;
  final bool inversion;

  TrianglePainter({required this.fillColor, required this.inversion});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    if (!inversion) {
      canvas.drawPath(getTrianglePath(size.width, size.height), paint);
    } else {
      canvas.drawPath(getInvertedTrianglePath(size.width, size.height), paint);
    }
  }

  ///Get a normal triangle path
  Path getTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, y)
      ..lineTo(x / 2, 0)
      ..lineTo(x, y)
      ..lineTo(0, y);
  }

  ///Get an inverted triangle Path
  Path getInvertedTrianglePath(double x, double y) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(x / 2, y)
      ..lineTo(x, 0)
      ..lineTo(0, 0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

///CLASS: DashPainter
///Paints a dash
class DashPainter extends CustomPainter {
  final Color fillColor;

  DashPainter({required this.fillColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = fillColor
      ..style = PaintingStyle.fill;

    canvas.drawPath(getDashPath(size.width, size.height), paint);
  }

  ///Get a dash path
  Path getDashPath(double x, double y) {
    return Path()
      ..moveTo(0, y / 2.5)
      ..lineTo(0, y / 1.5)
      ..lineTo(x, y / 1.5)
      ..lineTo(x, y / 2.5)
      ..lineTo(0, y / 2.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
