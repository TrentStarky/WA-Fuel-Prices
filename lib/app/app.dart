import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:wa_fuel/app/app.router.dart';
import 'package:wa_fuel/services/favourite_service.dart';
import 'package:wa_fuel/services/rss_parser.dart';
import 'package:wa_fuel/services/rss_service.dart';
import 'package:wa_fuel/services/search_service.dart';
import 'package:wa_fuel/services/storage_service.dart';
import 'package:wa_fuel/ui/pages/home/home_view.dart';
import 'package:wa_fuel/ui/pages/information/information_view.dart';

@StackedApp(
  routes: [
    CustomRoute(
      transitionsBuilder: TransitionsBuilders.slideBottom,
      page: InformationView,
    ),
  ],
  dependencies: [
    //Stacked services
    LazySingleton(classType: NavigationService),

    //WA Fuel Services
    LazySingleton(classType: FavouriteService),
    LazySingleton(classType: RssParser),
    LazySingleton(classType: RssService),
    LazySingleton(classType: SearchService),
    LazySingleton(classType: StorageService),
  ],
)
class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      home: HomeView(),
    );
  }
}
