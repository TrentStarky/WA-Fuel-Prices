import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/routing/transition_router.dart';
import '../favourites/favourites_page.dart';
import '../info/information_page.dart';
import '../onboarding/onboarding_page.dart';
import '../search/seach_page.dart';

import '../../style.dart';

///CLASS: HomePage
///Main page of app, displaying FavouritesPage and SearchPage as tabs
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FuelStation> fuelStationList = [];
  final List<Widget> _pageOptions = [const FavouritesPage(), const SearchPage()];
  int _pageIndex = 0;

  ///Setup tabs and check for on-boarding
  @override
  void initState() {
    //Show on-boarding page if first run
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getBool(Resources.dbFirstRun) == null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const OnboardingPage()));
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
          leading: const Icon(Icons.local_gas_station),
          title: const Text('WA Fuel Prices'),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                Navigator.push(context, TransitionRouter.bottomToTop(const InformationPage()));
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
                selectedIconTheme: const IconThemeData(color: ThemeColor.mainColor),
                items: const [
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
