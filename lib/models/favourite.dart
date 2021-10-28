import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/models/search_params.dart';

import '../resources.dart';

///CLASS: FavouriteInfoItem
///Stores the data obtained from RSS feed using favourited parameters
class Favourite {
  SearchParams searchParams = SearchParams();
  List<FuelStation> todayStations = [];
  List<FuelStation> tomorrowStations = [];
  double? todayBestPrice;
  double? tomorrowBestPrice;
  ChangeIcon? changeIcon;

  Favourite.fromDatabase(Map databaseMap) {
    searchParams = SearchParams.fromDatabase(databaseMap);
  }

  Favourite.fromSearchParams(this.searchParams);

  ///Updates station list, today price and icon if possible
  void addTodayStations(List<FuelStation>? todayStations) {
    if (todayStations != null) {
      this.todayStations = todayStations;
      if (todayStations.isNotEmpty) {
        todayBestPrice = todayStations[0].price;
      } else {
        todayBestPrice = null;
      }
    } else {
      this.todayStations = [];
    }
    _updateChangeIcon();
  }

  ///Updates station list, tomorrow price and icon if possible
  void addTomorrowStations(List<FuelStation>? tomorrowStations) {
    if (tomorrowStations != null) {
      this.tomorrowStations = tomorrowStations;
      if (tomorrowStations.isNotEmpty) {
        tomorrowBestPrice = tomorrowStations[0].price;
      } else {
        tomorrowBestPrice = null;
      }
    } else {
      this.tomorrowStations = [];
    }
    _updateChangeIcon();
  }

  ///If today and tomorrow prices are set then set the change icon
  void _updateChangeIcon() {
    if (todayBestPrice == null ||
        tomorrowBestPrice == null) {
      changeIcon = null;
    } else {
      //todo floating point comparisons are bad, do (difference < 0.001) or something
      if (todayBestPrice! > tomorrowBestPrice!) {
        changeIcon = ChangeIcon.down;
      } else if (todayBestPrice! < tomorrowBestPrice!) {
        changeIcon = ChangeIcon.up;
      } else {
        changeIcon = ChangeIcon.steady;
      }
    }
  }
}
