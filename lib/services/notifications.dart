import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/favourite.dart';

import '../resources.dart';
import 'database_helper.dart';
import 'fuelwatch_service.dart';

class Notifications {
  ///Gets stations that need to have a notification sent, requests RSS data and sends notification
  static Future<void> executeBackgroundTask() async {
    FlutterLocalNotificationsPlugin notificationsPlugin = FlutterLocalNotificationsPlugin();
    AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('ic_fuel');
    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    notificationsPlugin.initialize(initializationSettings);

    notificationsPlugin.cancelAll(); //remove existing notifications

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

  static Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    //do nothing

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
  static Future<void> showNotification(FlutterLocalNotificationsPlugin notificationsPlugin, int id, String locationName,
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
  static Future<void> showGroupNotification(FlutterLocalNotificationsPlugin notificationsPlugin) async {
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
}
