import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///TODO standardise style in app to use themes specified in this file

class ThemeText {
  static const textPrice = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  static const textNormal = TextStyle(
    fontWeight: FontWeight.normal,
  );

  static const textBold = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const textTileHeader = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static const textStationTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static const textStationNormal = TextStyle(
    fontSize: 20,
  );
}

class ThemeColor {
  static const lightBackground = Color(0xFFEEEEEE);
  static const mainColor = Color(0xFFc56215);
  static const mainColorDark = Color(0xFF944a10);
  static const deepRed = Color(0xFFbf0006);
}
