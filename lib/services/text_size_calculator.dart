import 'package:flutter/material.dart';

///Calculates height of text (over multiple lines of text if necessary)
class TextSizeCalculator {
  static Size calculate(String text, TextStyle style, int maxLines, double maxWidth, double textScaleFactor) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style),
        maxLines: maxLines,
        textDirection: TextDirection.ltr,
        textScaleFactor: textScaleFactor)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }
}
