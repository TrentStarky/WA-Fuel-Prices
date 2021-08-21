import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/screens/favourites_page.dart';
import 'package:wa_fuel/screens/information_page.dart';
import 'package:wa_fuel/screens/onboarding_page.dart';
import 'package:wa_fuel/screens/seach_page.dart';

import '../style.dart';

///CLASS: HomePage
///Main page of app, displaying FavouritesPage and SearchPage as tabs
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FuelStation> fuelStationList = [];
  List<Widget> _pageOptions;
  int _pageIndex = 0;

  ///Setup tabs and check for on-boarding
  @override
  void initState() {
    _pageOptions = [FavouritesPage(), SearchPage()];

    //Show on-boarding page if first run
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(Resources.dbFirstRun) == null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => OnboardingPage()));
        prefs.setBool(Resources.dbFirstRun, false);
      }

      if (prefs.getStringList(Resources.dbPushNotification) == null) {
        prefs.setStringList(Resources.dbPushNotification, []);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.local_gas_station),
          title: Text('WA Fuel Prices'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => InformationPage()));
              },
            )
          ],
          elevation: 0,
        ),
        backgroundColor: ThemeColor.lightBackground,
        body: Column(
          children: [
            Expanded(
              child: IndexedStack(
                index: _pageIndex,
                children: _pageOptions,
              ),
            ),
            BottomNavigationBar(
                currentIndex: _pageIndex,
                onTap: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                selectedItemColor: Colors.black,
                selectedIconTheme: IconThemeData(color: ThemeColor.mainColor),
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.star),
                    label: 'Favourites',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                ])
          ],
        ));
  }
}
