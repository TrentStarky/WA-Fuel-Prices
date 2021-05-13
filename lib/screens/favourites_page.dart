import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/favourite.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/screens/single_favourite_page.dart';
import 'package:wa_fuel/screens/single_station_page.dart';
import 'package:wa_fuel/services/database_helper.dart';
import 'package:wa_fuel/services/fuelwatch_service.dart';
import 'package:wa_fuel/services/painter.dart';
import 'package:wa_fuel/style.dart';

///CLASS: FavouritesPage
///Displays favourited searches with current prices
class FavouritesPage extends StatefulWidget {
  @override
  _FavouritesPageState createState() => _FavouritesPageState();
}

class _FavouritesPageState extends State<FavouritesPage> {
  List<Favourite> favouritesList;

  ///Load saved favourites then get current prices
  @override
  void initState() {
    _getFavouritesFromDatabase().then((list) {
      _getFavouritesPrices(list).then((finalList) {
        setState(() {
          favouritesList = finalList;
        });
      });
    });
    super.initState();
  }

  ///Gets favourites from database
  Future<List<Map>> _getFavouritesFromDatabase() async {
    Database database = await DBHelper().getFavouritesDatabase();

    List<Map> favouriteDBList = await database.rawQuery('SELECT * FROM ${Resources.dbFavourites}');

    return favouriteDBList;
  }

  ///Gets prices for each favourite
  Future<List<Favourite>> _getFavouritesPrices(List<Map> list) async {
    List<Favourite> returnList = [];
    List<Future<List<FuelStation>>> stationListFutures = [];

    for (Map favourite in list) {
      Favourite favouriteItem = Favourite.fromDatabase(favourite);
      stationListFutures.add(FuelWatchService.getFuelStationsToday(favouriteItem.searchParams));
      stationListFutures.add(FuelWatchService.getFuelStationsTomorrow(favouriteItem.searchParams));
      returnList.add(favouriteItem);
    }

    await Future.wait(stationListFutures).then((stationList) {
      for (int i = 0; i < returnList.length; i++) {
        returnList[i].addTodayStations(stationList[i * 2]);
        returnList[i].addTomorrowStations(stationList[(i * 2) + 1]);
      }
    });

    return returnList;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, con) => (favouritesList == null)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : (favouritesList.length == 0)
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No favourites found, add favourites by starring a search in the search tab',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                )
              : ListView.builder(
                  itemBuilder: (context, index) => Column(
                    children: [
                      ///Add padding to top of first item
                      (index == 0)
                          ? SizedBox(
                              height: con.maxWidth * 0.025,
                            )
                          : Container(),
                      SizedBox(
                        width: con.maxWidth * 0.95,
                        child: FavouriteListItem(
                            favouritesList[index], () => setState(() => favouritesList.removeAt(index))),
                      ),
                      SizedBox(
                        height: con.maxWidth * 0.025,
                      ),
                    ],
                  ),
                  itemCount: favouritesList.length,
                ),
    );
  }
}

///CLASS: FavouriteListItem
///Displays prices for a favourite in the favourites list
class FavouriteListItem extends StatefulWidget {
  final Favourite itemInstance;
  final void Function() removeSelfCallback;

  FavouriteListItem(this.itemInstance, this.removeSelfCallback);

  @override
  _FavouriteListItemState createState() => _FavouriteListItemState();
}

class _FavouriteListItemState extends State<FavouriteListItem> with TickerProviderStateMixin {
  DisplayDay displayDayValue;
  TabController controller;

  ///Set up tab bar controller
  @override
  void initState() {
    displayDayValue = DisplayDay.none;
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      if (controller.index == 0) {
        setState(() {
          displayDayValue = DisplayDay.today;
        });
      } else if (controller.index == 1) {
        setState(() {
          displayDayValue = DisplayDay.tomorrow;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          Column(
            children: [
              Stack(children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${widget.itemInstance.searchParams.getLocation()}',
                      style: ThemeText.textTileHeader,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    constraints: BoxConstraints.tight(Size(25, 25)),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      final refreshScreen = Navigator.push(
                          context, MaterialPageRoute(builder: (context) => SingleFavouritePage(widget.itemInstance)));
                      refreshScreen.then((removeSelf) {
                        //When deleting a favorite on SingleFavouritePage, Navigator.pop returns true and display favourite list should update to remove child from display
                        if (removeSelf != null && removeSelf) {
                          widget.removeSelfCallback();
                        }
                      });
                    },
                    icon: Icon(
                      Icons.more_vert,
                      color: Colors.grey,
                    ),
                  ),
                )
              ]),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Resources.productsColors[widget.itemInstance.searchParams.productValue],
                                width: 2,
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            '${Resources.productsShort[widget.itemInstance.searchParams.productValue]}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        height: 20,
                        child: VerticalDivider(
                          width: 2,
                          thickness: 1,
                          color: Colors.black,
                        )),
                    Expanded(
                        child: Center(
                            child: Text('${Resources.brandsRssToString[widget.itemInstance.searchParams.brandValue]}')))
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
                child: Divider(
                  height: 8,
                  thickness: 1,
                  color: Colors.black12,
                  indent: 24,
                  endIndent: 24,
                ),
              )
            ],
          ),
          TabBar(
            indicator: _CustomTabIndicator(),
            controller: controller,
            tabs: [
              TextButton(
                onPressed: () {
                  setState(() {
                    if (displayDayValue != DisplayDay.today) {
                      displayDayValue = DisplayDay.today;
                      controller.index = 0;
                    } else {
                      displayDayValue = DisplayDay.none;
                    }
                  });
                },
                child: Column(
                  children: [
                    Text(
                      widget.itemInstance.todayPrice ?? '-',
                      style: ThemeText.textPrice,
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.black,
                      width: 60,
                    ),
                    Text(
                      'Today',
                      style: ThemeText.textNormal,
                    ),
                    (displayDayValue == DisplayDay.today)
                        ? Icon(Icons.keyboard_arrow_up)
                        : Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (displayDayValue != DisplayDay.tomorrow) {
                      displayDayValue = DisplayDay.tomorrow;
                      controller.index = 1;
                    } else {
                      displayDayValue = DisplayDay.none;
                    }
                  });
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _paintChangeIcon(widget.itemInstance.changeIcon),
                        Text(
                          '${widget.itemInstance.tomorrowPrice}' ?? '-',
                          style: ThemeText.textPrice,
                        ),
                      ],
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.black,
                      width: 80,
                    ),
                    Text(
                      'Tomorrow',
                      style: ThemeText.textNormal,
                    ),
                    (displayDayValue == DisplayDay.tomorrow)
                        ? Icon(Icons.keyboard_arrow_up)
                        : Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ],
          ),
          (displayDayValue != DisplayDay.none)
              ? SizedBox(
                  height: _calculateTabHeight(),
                  child: TabBarView(
                    controller: controller,
                    children: [
                      _createStationDropdown(widget.itemInstance.todayStations),
                      _createStationDropdown(widget.itemInstance.tomorrowStations),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  ///Paint the change icon depending on value
  Widget _paintChangeIcon(ChangeIcon icon) {
    switch (icon) {
      case ChangeIcon.down:
        return Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: CustomPaint(
            painter: TrianglePainter(fillColor: Colors.green, inversion: true),
            size: Size(15, 15),
          ),
        );
        break;
      case ChangeIcon.up:
        return Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: CustomPaint(
            painter: TrianglePainter(fillColor: Colors.red, inversion: false),
            size: Size(15, 15),
          ),
        );
        break;
      case ChangeIcon.steady:
        return Padding(
          padding: EdgeInsets.only(right: 4.0),
          child: CustomPaint(
            painter: DashPainter(fillColor: Colors.black),
            size: Size(15, 15),
          ),
        );
        break;
      default:
        return Container();
        break;
    }
  }

  ///Creates a table showing top 5 lowest prices for that favourite
  Widget _createStationDropdown(List stations) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xFFEEEEEE),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: (stations.length != 0)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainStationListTile(stations[0]),
                  for (int ii = 1; ii < 5 && ii < stations.length; ii++) StationListTile(stations[ii])
                ],
              )
            : Center(
                child: Text(
                  'No data found.\nTomorrows prices are updated at 2:30pm.',
                  textAlign: TextAlign.center,
                ),
              ),
      ),
    );
  }

  ///Calculates height of dropdown depending on how many stations need to be displayed
  double _calculateTabHeight() {
    int numToday = widget.itemInstance.todayStations.length;
    int numTomorrow = widget.itemInstance.tomorrowStations.length;
    int numToRender;

    if (numToday >= 5) {
      numToRender = 5;
    } else if (numToday > numTomorrow) {
      numToRender = numToday;
    } else if (numTomorrow >= 1) {
      numToRender = numTomorrow;
    } else {
      numToRender = 1;
    }

    return 50.0 * numToRender;
  }
}

///CLASS: StationListTile
///Displays station name and price in a list tile
class StationListTile extends StatelessWidget {
  final FuelStation station;

  StationListTile(this.station);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            minimumSize: MaterialStateProperty.all<Size>(Size(double.infinity, 16)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                side: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(16))))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleStationPage(station: station)));
        },
        child: SizedBox(
          height: 16,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${station.price}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      VerticalDivider(
                        color: Colors.black,
                      ),
                      Flexible(
                          child: Text(
                        '${station.tradingName}',
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  ),
                ),
                Icon(Icons.arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

///CLASS: MainStationListTile
///Gives special highlighting to cheapest station tile
class MainStationListTile extends StationListTile {
  final FuelStation station;

  MainStationListTile(this.station) : super(station);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
                side: BorderSide(width: 2), borderRadius: BorderRadius.all(Radius.circular(20))))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleStationPage(station: station)));
        },
        child: SizedBox(
          height: 20,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          '${station.price}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        VerticalDivider(
                          color: Colors.black,
                        ),
                        Text('${station.tradingName}'),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_right),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///CLASS: _CustomTabIndicator
///Custom (invisible) tab indicator for station dropdown
class _CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _CustomPainter();
  }
}

///CLASS: _CustomPainter
///Paints nothing for the _CustomTabIndicator
class _CustomPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
