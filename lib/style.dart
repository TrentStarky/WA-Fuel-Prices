import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///TODO standardise style in app to use themes specified in this file

class ThemeText {
  static final textPrice = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 25,
  );

  static final textNormal = TextStyle(
    fontWeight: FontWeight.normal,
  );

  static final textBold = TextStyle(
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static final textTileHeader = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static final textStationTitle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
  );

  static final textStationNormal = TextStyle(
    fontSize: 20,
  );
}

class ThemeColor {
  static final lightBackground = Color(0xFFEEEEEE);
  static final mainColor = Color(0xFFc56215);
}
