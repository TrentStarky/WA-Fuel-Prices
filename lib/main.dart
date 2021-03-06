import 'dart:ui';

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
import 'package:workmanager/workmanager.dart';

import 'models/favourite.dart';
import 'screens/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance().then((prefs) {
    //Check if notifications have been set up
    if (prefs.getBool(Resources.dbNotificationsEnabled) == null || !prefs.getBool(Resources.dbNotificationsEnabled)) {
      Workmanager.initialize(callbackDispatcher);
      Workmanager.registerPeriodicTask(
        'dailyFuelUpdate',
        'getFavouritesTomorrowPrices',
        existingWorkPolicy: ExistingWorkPolicy.replace,
        constraints: Constraints(),
        frequency: Duration(days: 1),
        initialDelay: calculateDelay(),
      );
      prefs.setBool(Resources.dbNotificationsEnabled, true);
    }
  });

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: ThemeColor.mainColor,
        accentColor: ThemeColor.mainColor,
        textButtonTheme: TextButtonThemeData(
            style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
        ))),
    home: HomePage(),
  ));
}

///Executed when app is run in the background
void callbackDispatcher() {
  Workmanager.executeTask((taskName, inputData) async {
    switch (taskName) {
      case 'getFavouritesTomorrowPrices':
        await executeBackgroundTask();
        break;
      case Workmanager.iOSBackgroundTask:

        ///TODO iOS background notifications
        print('iOS background fetch delegate ran');
        break;
    }
    return Future.value(true);
  });
}

///Gets stations that need to have a notification sent, gets RSS data and sends notification
Future<void> executeBackgroundTask() async {
  FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_fuel');
  InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
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

  if (notificationIndex > 2) {
    await showGroupNotification(notificationsPlugin);
  }
  return;
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
  const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
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
