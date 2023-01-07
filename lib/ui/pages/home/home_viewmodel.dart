import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wa_fuel/app/app.locator.dart';
import 'package:wa_fuel/app/app.router.dart';

class HomeViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final TabController controller;

  HomeViewModel({required TickerProvider vsync})
      : controller = TabController(length: 2, vsync: vsync);

  void openInformation() {
    _navigationService.navigateTo(Routes.informationView);
  }
}
