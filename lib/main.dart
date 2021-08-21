import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/services/notifications.dart';
import 'package:wa_fuel/style.dart';

import 'models/app_state.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Firebase.initializeApp().then((firebaseApp) async {
    print(await FirebaseMessaging.instance.getToken());
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data['category'] == Resources.updateFuelPricesCategory) {
        Notifications.executeBackgroundTask();
      }
    });

    FirebaseMessaging.onBackgroundMessage(_handler);
  });

  runApp(MyApp());
}

Future<void> _handler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.data['category'] == Resources.updateFuelPricesCategory) {
    Notifications.executeBackgroundTask();
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: ThemeColor.mainColor,
          accentColor: ThemeColor.mainColor,
          textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
            ),
          ),
        ),
        home: HomePage(),
      ),
    );
  }
}
