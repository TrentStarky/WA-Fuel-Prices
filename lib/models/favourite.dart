import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/models/search_params.dart';

import '../resources.dart';

///CLASS: FavouriteInfoItem
///Stores the data obtained from RSS feed using favourited parameters
class Favourite {
  SearchParams searchParams;
  List<FuelStation> todayStations;
  List<FuelStation> tomorrowStations;
  String todayPrice;
  String tomorrowPrice;
  ChangeIcon changeIcon;

  Favourite._();

  Favourite.fromDatabase(Map databaseMap) {
    Favourite._();
    this.searchParams = SearchParams.fromDatabase(databaseMap);
  }

  Favourite.fromSearchParams(SearchParams searchParams) {
    Favourite._();
    this.searchParams = searchParams;
  }

  ///Updates station list, today price and icon if possible
  void addTodayStations(List<FuelStation> todayStations) {
    if (todayStations != null) {
      this.todayStations = todayStations;
      if (todayStations.length != 0) {
        todayPrice = todayStations[0].price;
      } else {
        todayPrice = '---.-';
      }
    } else {
      this.todayStations = [];
    }
    _updateChangeIcon();
  }

  ///Updates station list, tomorrow price and icon if possible
  void addTomorrowStations(List<FuelStation> tomorrowStations) {
    if (tomorrowStations != null) {
      this.tomorrowStations = tomorrowStations;
      if (tomorrowStations.length != 0) {
        tomorrowPrice = tomorrowStations[0].price;
      } else {
        tomorrowPrice = '---.-';
      }
    } else {
      this.tomorrowStations = [];
    }
    _updateChangeIcon();
  }

  ///If today and tomorrow prices are set then set the change icon
  void _updateChangeIcon() {
    if (this.todayPrice == null ||
        this.tomorrowPrice == null ||
        this.todayPrice == '---.-' ||
        this.tomorrowPrice == '---.-') {
      this.changeIcon = null;
    } else {
      if (double.tryParse(todayPrice) > double.tryParse(tomorrowPrice)) {
        this.changeIcon = ChangeIcon.down;
      } else if (double.tryParse(todayPrice) < double.tryParse(tomorrowPrice)) {
        this.changeIcon = ChangeIcon.up;
      } else {
        this.changeIcon = ChangeIcon.steady;
      }
    }
  }
}
