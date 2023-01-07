import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:wa_fuel/app/app_colors.dart';
import 'package:wa_fuel/ui/pages/favourite_list/favourite_list_view.dart';
import 'package:wa_fuel/ui/pages/home/home_viewmodel.dart';
import 'package:wa_fuel/ui/pages/search/search_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      viewModelBuilder: () => HomeViewModel(vsync: this),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text('WA Fuel Prices'),
            centerTitle: true,
            leading: Icon(Icons.local_gas_station_rounded),
            actions: [
              IconButton(
                  onPressed: model.openInformation,
                  icon: Icon(Icons.info_outline))
            ],
            backgroundColor: colorPrimaryOrange,
            elevation: 0,
          ),
          backgroundColor: colorLightBackground,
          body: TabBarView(
            controller: model.controller,
            children: [
              FavouriteListView(),
              // SearchView(),
            ],
            physics: NeverScrollableScrollPhysics(),
          ),
          bottomNavigationBar: Container(
            color: Colors.white,
            child: TabBar(
              controller: model.controller,
              indicatorColor: Colors.transparent,
              labelColor: colorPrimaryOrange,
              unselectedLabelColor: colorGrey,
              padding: EdgeInsets.zero,
              tabs: [
                Tab(
                  text: 'Favourites',
                  height: 60,
                  iconMargin: EdgeInsets.zero,
                  icon: Icon(Icons.star),
                ),
                Tab(
                  text: 'Search',
                  height: 60,
                    iconMargin: EdgeInsets.zero,
                    icon: Icon(Icons.search),),
              ],
            ),
          )),
    );
  }
}
