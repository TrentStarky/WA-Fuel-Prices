import 'dart:io';
import 'dart:ui';

import 'package:background_fetch/background_fetch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/services/database_helper.dart';
import 'package:wa_fuel/services/fuelwatch_service.dart';
import 'package:wa_fuel/style.dart';

import 'models/favourite.dart';
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
      await executeBackgroundTask();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: ThemeColor.mainColor,
          accentColor: ThemeColor.mainColor,
          textButtonTheme: TextButtonThemeData(
              style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
          ))),
      home: HomePage(),
    );
  }
}

///For iOS, checks if need to get data and send notification (after 2:30pm once daily)
Future<bool> needToRunBackgroundTasks() async {
  DateTime timeNow = DateTime.now();
  DateTime timeToRun = DateTime(timeNow.year, timeNow.month, timeNow.day, 14, 30);
  int lastRunMilliseconds;
  var prefs = await SharedPreferences.getInstance();
  try {
    lastRunMilliseconds = prefs.getInt(Resources.dbLastBackgroundRun);
    if (lastRunMilliseconds == null) {
      if (timeNow.isAfter(timeToRun)) {
        prefs.setInt(Resources.dbLastBackgroundRun, timeNow.millisecondsSinceEpoch);
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
    return false;
  }
}

///Gets stations that need to have a notification sent, requests RSS data and sends notification
Future<void> executeBackgroundTask() async {
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_fuel');
  IOSInitializationSettings initializationSettingsIOS =
      IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  notificationsPlugin.initialize(initializationSettings);

  Database database = await DBHelper().getFavouritesDatabase();

  List<Map> favouriteDBList = await database
      .rawQuery('SELECT * FROM ${Resources.dbFavourites} WHERE ${Resources.dbPushNotification} IN (?, ?)', [1, 2]);

  int notificationIndex = 1;

  for (Map favourite in favouriteDBList) {
    Favourite favouriteInstance = Favourite.fromDatabase(favourite);
    final todayStations = await FuelWatchService.getFuelStationsToday(favouriteInstance.searchParams);
    favouriteInstance.addTodayStations(todayStations);

    final tomorrowStation = await FuelWatchService.getFuelStationsTomorrow(favouriteInstance.searchParams);
    favouriteInstance.addTomorrowStations(tomorrowStation);

    if (favourite[Resources.dbPushNotification] == 2) {
      try {
        if (double.parse(favouriteInstance.todayPrice) >= double.parse(favouriteInstance.tomorrowPrice)) {
          continue;
        }
      } catch (_) {}
    }

    await showNotification(
        notificationsPlugin,
        notificationIndex,
        favouriteInstance.searchParams.getLocation(),
        Resources.productsShort[favouriteInstance.searchParams.productValue],
        favouriteInstance.todayPrice,
        favouriteInstance.tomorrowPrice);

    notificationIndex++;
  }

  if (notificationIndex > 2 && Platform.isAndroid) {
    await showGroupNotification(notificationsPlugin);
  }
  return;
}

Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
  // showDialog(context: context, builder: (BuildContext context) => CupertinoAlertDialog(
  //   title: Text(title),
  //   content: Text(body),
  //   actions: [
  //     CupertinoDialogAction(
  //       isDefaultAction: true,
  //       child: Text('Ok'),
  //       onPressed: () async {
  //         Navigator.of(context, rootNavigator: true).pop();
  //         await Navigator.push(
  //           context,
  //           MaterialPageRoute(builder: (context) => SecondScreen(payload),
  //           ),
  //         );
  //       },
  //
  //     )
  //   ],
  // ));
}

///Sends notification
Future<void> showNotification(FlutterLocalNotificationsPlugin notificationsPlugin, int id, String locationName,
    String product, String todayPrice, String tomorrowPrice) async {
  String changeIcon = '';
  try {
    double today = double.parse(todayPrice);
    double tomorrow = double.parse(tomorrowPrice);
    if (today < tomorrow) {
      changeIcon = '\u25B2';
    } else if (today > tomorrow) {
      changeIcon = '\u25BC';
    }
  } catch (_) {}

  const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'Fuel Notifications', 'Notifications of saved fuel searches when tomorrows\' prices are available.',
      groupKey: 'FuelNotification', playSound: false);
  const IOSNotificationDetails iosPlatformChannelSpecifics = IOSNotificationDetails(threadIdentifier: 'wa-fuel');
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iosPlatformChannelSpecifics);
  await notificationsPlugin.show(id, '$locationName - $product',
      'Today: $todayPrice - $changeIcon Tomorrow: $tomorrowPrice', platformChannelSpecifics);
  return;
}

/// Send Group Summary notification
Future<void> showGroupNotification(FlutterLocalNotificationsPlugin notificationsPlugin) async {
  DateFormat dateFormat = DateFormat('dd:MM:yyyy', 'en_US');
  InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
    [],
    contentTitle: 'WA Fuel Prices - ${dateFormat.format(DateTime.now())}',
  );
  AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '0', 'Fuel Notifications', 'Notifications of saved fuel searches when tomorrows\' prices are available.',
      styleInformation: inboxStyleInformation, groupKey: 'FuelNotification', setAsGroupSummary: true);
  NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
  await notificationsPlugin.show(
      0, 'WA Fuel Prices - ${dateFormat.format(DateTime.now())}', '', platformChannelSpecifics);
}

///Calculates how long to wait until first notification should be sent, so that it will be sent at 2:30pm
Duration calculateDelay() {
  DateTime timeNow = DateTime.now();
  DateTime targetTime;

  final hour = 14;
  final minute = 30;

  if (timeNow.isBefore(DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute))) {
    targetTime = DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute);
  } else {
    targetTime = DateTime(timeNow.year, timeNow.month, timeNow.day, hour, minute);
    targetTime = targetTime.add(Duration(days: 1));
  }

  Duration duration = targetTime.difference(timeNow);

  return duration;
}

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
  // Do your work here...
  BackgroundFetch.finish(taskId);
}