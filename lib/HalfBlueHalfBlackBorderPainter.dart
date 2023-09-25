import 'dart:math';
import 'package:flutter/material.dart';

class HalfBlueHalfBlackBorderPainter extends CustomPainter {
  final double borderWidth;

  HalfBlueHalfBlackBorderPainter(this.borderWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    final rect = Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2);

    // Draw the blue color to completely fill the circle (2π radians)
    canvas.drawArc(rect, -1.70, 1.4 * pi, false, paint);

    // Change the color to black
    paint.color = Colors.black;

    // Draw the black color to completely fill the circle (2π radians)
    canvas.drawArc(rect, 0.20, 0 * pi, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
