import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../resources.dart';

///CLASS: DBHelper
///Handles opening and providing the database to the app
class DBHelper {
  Database? _favouritesDatabase;
  static final DBHelper _instance = DBHelper._();

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  ///Opens database or returns already open database
  Future<Database> getFavouritesDatabase() async {
    if (_favouritesDatabase == null) {
      var databasePath = await getDatabasesPath();
      String path = databasePath + 'favourites_db.db';

      ///TODO: temporary fix
      if (Platform.isIOS) {
        path = databasePath + '/favourites_db.db';
      }

      Database database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
        await db.execute(
            'CREATE TABLE ${Resources.dbFavourites} (id INTEGER PRIMARY KEY, ${Resources.dbProduct} INTEGER, ${Resources.dbBrand} INTEGER, ${Resources.dbRegion} INTEGER, ${Resources.dbSuburb} STRING, ${Resources.dbIncludeSurrounding} INTEGER, ${Resources.dbNotificationsEnabled} INTEGER, ${Resources.dbPushNotification} INTEGER)');
      });

      _favouritesDatabase = database;
    }

    return _favouritesDatabase!;
  }
}
