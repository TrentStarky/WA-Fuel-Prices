
import 'package:flutter/material.dart';
import 'package:wa_fuel/app/app.dart';
import 'package:wa_fuel/app/app.locator.dart';

//todo add ios urlLauncher https://pub.dev/packages/url_launcher#configuration

void main() {

  setupLocator();

  runApp(App());
}