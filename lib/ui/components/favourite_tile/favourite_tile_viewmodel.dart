// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
// import 'package:wa_fuel/app/app.locator.dart';
// import 'package:wa_fuel/app/app_constants.dart';
// import 'package:wa_fuel/models/favourite.dart';
// import 'package:wa_fuel/services/favourite_service.dart';
//
// class FavouriteTileViewModel extends FutureViewModel {
//   final _favouriteService = locator<FavouriteService>();
//   final Favourite favourite;
//
//   Color get productColor => AppConstants.rssProductsColors[favourite.product] ?? Colors.grey;
//
//   FavouriteTileViewModel(this.favourite);
//
//   @override
//   Future futureToRun() {
//     return _favouriteService.getFavouritePrices(favourite);
//   }
//
//   Future<void> openSettings() async {
//     // open favourite settings page
//   }
// }