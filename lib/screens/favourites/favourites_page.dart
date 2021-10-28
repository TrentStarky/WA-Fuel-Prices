import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wa_fuel/models/app_state.dart';
import 'package:wa_fuel/screens/favourites/add_favourite_widget.dart';
import 'package:wa_fuel/style.dart';

import 'favourite_list_item.dart';

//TODO: Add error message when FuelWatch RSS feed is inaccessible so users know the issue is not with the app

///CLASS: FavouritesPage
///Displays favourited searches with current prices
class FavouritesPage extends StatefulWidget {
  const FavouritesPage({Key? key}) : super(key: key);

  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  late RefreshController _refreshController;

  ///Load saved favourites then get current prices
  @override
  void initState() {
    _refreshController = RefreshController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (ctx, con) => Consumer<AppState>(builder: (context, state, child)
    {
      if (state.loading == true) {
        return const Center(
          child: CircularProgressIndicator(
            color: ThemeColor.mainColor,
          ),
        );
      } else {
        // if (state.favouritesList.isEmpty) {
        //   return const Center(
        //     child: Padding(
        //       padding: EdgeInsets.all(16.0),
        //       child: Text(
        //         'No favourites found, add favourites by starring a search in the search tab',
        //         textAlign: TextAlign.center,
        //         style: TextStyle(fontSize: 16.0),
        //       ),
        //     ),
        //   );
        // } else {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery
              .of(context)
              .size
              .width * 0.025),
          child: SmartRefresher(
            controller: _refreshController,
            header: const ClassicHeader(),
            onRefresh: () async {
              await Provider.of<AppState>(context, listen: false).refreshPrices();
              _refreshController.refreshCompleted();
            },
            child: ListView.builder(
              itemBuilder: (context, index) {
                //Puts 'Add Favourite' widget at the end of the list
                if (index != state.favouritesList.length) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery
                          .of(context)
                          .size
                          .height * 0.0125,
                    ),
                    child: FavouriteListItem(state.favouritesList[index]),
                  );
                } else {
                  return AddFavouriteWidget();
                }
              },
              itemCount: state.favouritesList.length + 1,
            ),
          ),
        );
      }
    }

  // }
  )

  ,

  );
}}
