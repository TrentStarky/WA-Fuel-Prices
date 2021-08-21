import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/services/notifications.dart';
import 'package:wa_fuel/style.dart';

import 'models/app_state.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());

  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
      BackgroundFetchConfig(
        minimumFetchInterval: 120,
        stopOnTerminate: false,
        enableHeadless: true,
        requiresBatteryNotLow: false,
        requiresCharging: false,
        requiresStorageNotLow: false,
        requiresDeviceIdle: false,
        requiredNetworkType: NetworkType.ANY,
      ),
      _eventHandler,
      _timeoutHandler,
    );
    print('[BackgroundFetch] configure success: $status');

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  _eventHandler(String taskId) async {
    // This is the fetch-event callback.
    print("[BackgroundFetch] Event received $taskId");

    if (await needToRunBackgroundTasks()) {
      await Notifications.executeBackgroundTask();
    }

    // IMPORTANT:  You must signal completion of your task or the OS can punish your app
    // for taking too long in the background.
    BackgroundFetch.finish(taskId);
  }

  _timeoutHandler(String taskId) async {
    // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
    BackgroundFetch.finish(taskId);
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
            ))),
        home: HomePage(),
      ),
    );
  }
}

///Checks if need to get data and send notification (after 2:30pm once daily)
Future<bool> needToRunBackgroundTasks() async {
  DateTime timeNow = DateTime.now();
  DateTime timeToRun =
      DateTime(timeNow.year, timeNow.month, timeNow.day, 14, 30);
  int lastRunMilliseconds;
  var prefs = await SharedPreferences.getInstance();
  try {
    lastRunMilliseconds = prefs.getInt(Resources.dbLastBackgroundRun);
    //For first run after install
    if (lastRunMilliseconds == null) {
      if (timeNow.isAfter(timeToRun)) {
        prefs.setInt(
            Resources.dbLastBackgroundRun, timeNow.millisecondsSinceEpoch);
        return true;
      } else {
        return false;
      }
    }
  } catch (_) {
    print(_);
  }

  DateTime lastRun = DateTime.fromMillisecondsSinceEpoch(lastRunMilliseconds);

  if (timeNow.isAfter(timeToRun) && lastRun.isBefore(timeToRun)) {
    prefs.setInt(Resources.dbLastBackgroundRun, timeNow.millisecondsSinceEpoch);
    return true;
  } else {
    return false; //change for testing
  }
}

/////Calculates how long to wait until first notification should be sent, so that it will be sent at 2:30pm
//Duration calculateDelay() {
//  DateTime timeNow = DateTime.now();
//  DateTime targetTime;
//
//  final hour = 14;
//  final minute = 30;
//
//  if (timeNow.isBefore(DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute))) {
//    targetTime = DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute);
//  } else {
//    targetTime = DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute);
//    targetTime = targetTime.add(Duration(days: 1));
//  }
//
//  Duration duration = targetTime.difference(timeNow);
//
//  return duration;
//}

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    print("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  print('[BackgroundFetch] Headless event received.');

  if (await needToRunBackgroundTasks()) {
    await Notifications.executeBackgroundTask();
  }

  BackgroundFetch.finish(taskId);
}
