import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/favourite.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/services/database_helper.dart';
import 'package:wa_fuel/services/fuelwatch_service.dart';

import '../resources.dart';

class AppState extends ChangeNotifier {
  List<Favourite> _favourites = [];
  bool _loading = false;

  AppState() {
    loadFromDatabase();
  }

  List<Favourite> get favouritesList => _favourites;

  bool get loading => _loading;

  void add(Favourite favourite) async {
    _favourites.add(await _loadPrices(favourite));
    notifyListeners();
  }

  void remove(Favourite favourite) {
    _favourites.removeWhere((currentFavourite) =>
        currentFavourite.searchParams == favourite.searchParams);
    notifyListeners();
  }

  Future<void> refreshPrices() async {
    List<Favourite> updatedFavourites = [];
    for (Favourite favourite in _favourites) {
      updatedFavourites.add(await _loadPrices(favourite));
    }
    _favourites = updatedFavourites;
    notifyListeners();
    return;
  }

  Future<void> loadFromDatabase() async {
    _loading = true;
    notifyListeners();
    Database database = await DBHelper().getFavouritesDatabase();

    List<Map> favouriteDBList =
        await database.rawQuery('SELECT * FROM ${Resources.dbFavourites}');

    for (Map favouriteMap in favouriteDBList) {
      _favourites.add(await _loadPrices(Favourite.fromDatabase(favouriteMap)));
    }
    _loading = false;
    notifyListeners();
  }

  Future<Favourite> _loadPrices(Favourite favourite) async {
    Future<List<FuelStation>> todayPricesFuture;
    Future<List<FuelStation>> tomorrowPricesFuture;

    todayPricesFuture =
        FuelWatchService.getFuelStationsToday(favourite.searchParams);
    tomorrowPricesFuture =
        FuelWatchService.getFuelStationsTomorrow(favourite.searchParams);

    await Future.wait([todayPricesFuture, tomorrowPricesFuture])
        .then((stationPrices) {
      favourite.addTodayStations(stationPrices[0]);
      //prevents weird edge case where today prices timeout but tomorrows doesn't and formatting/everything breaks
      if (stationPrices[0].isNotEmpty) {
        favourite.addTomorrowStations(stationPrices[1]);
      }
    });

    return favourite;
  }

//
//  ///Gets data for UI
//  Future<void> _getData() async {
//    var favourites = await _getFavouritesFromDatabase();
//    var finalList = await _getFavouritesPrices(favourites);
//    setState(() {
//      favouritesList = finalList;
//    });
//
//    return;
//  }
//
//  ///Gets favourites from database
//  Future<List<Map>> _getFavouritesFromDatabase() async {
//    Database database = await DBHelper().getFavouritesDatabase();
//
//    List<Map> favouriteDBList = await database.rawQuery('SELECT * FROM ${Resources.dbFavourites}');
//
//    return favouriteDBList;
//  }
//
//  ///Gets prices for each favourite
//  Future<List<Favourite>> _getFavouritesPrices(List<Map> list) async {
//    List<Favourite> returnList = [];
//    List<Future<List<FuelStation>>> stationListFutures = [];
//
//    for (Map favourite in list) {
//      Favourite favouriteItem = Favourite.fromDatabase(favourite);
//      stationListFutures.add(FuelWatchService.getFuelStationsToday(favouriteItem.searchParams));
//      stationListFutures.add(FuelWatchService.getFuelStationsTomorrow(favouriteItem.searchParams));
//      returnList.add(favouriteItem);
//    }
//
//    await Future.wait(stationListFutures).then((stationList) {
//      for (int i = 0; i < returnList.length; i++) {
//        returnList[i].addTodayStations(stationList[i * 2]);
//        returnList[i].addTomorrowStations(stationList[(i * 2) + 1]);
//      }
//    });
//
//    return returnList;
//  }

}
