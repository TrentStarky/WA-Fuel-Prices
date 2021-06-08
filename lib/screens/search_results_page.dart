import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/screens/single_station_page.dart';
import 'package:wa_fuel/services/database_helper.dart';
import 'package:wa_fuel/style.dart';

///CLASS: SearchResultsPage
///Displays prices and stations returned from RSS feed after search
class SearchResultsPage extends StatefulWidget {
  SearchResultsPage({this.fuelStationsTodayFuture, this.fuelStationsTomorrowFuture, this.searchParams}) : super();

  final Future<List<FuelStation>> fuelStationsTodayFuture;
  final Future<List<FuelStation>> fuelStationsTomorrowFuture;
  final SearchParams searchParams;

  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> with TickerProviderStateMixin {
  List<FuelStation> fuelStationsToday;
  List<FuelStation> fuelStationsTomorrow;
  bool _favourite;
  TabController _controller;

  ///Wait for futures to return values to update screen
  @override
  void initState() {
    Future.wait([widget.fuelStationsTodayFuture, widget.fuelStationsTomorrowFuture]).then((value) {
      setState(() {
        fuelStationsToday = value[0];
        fuelStationsTomorrow = value[1];
      });
    });

    _favourite = false;
    _checkFavourite();

    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  ///Checks if search is already in favourites database
  _checkFavourite() async {
    Database database = await DBHelper().getFavouritesDatabase();

    if (Sqflite.firstIntValue(await database.rawQuery(
            'SELECT COUNT(*) FROM favourites WHERE ${Resources.dbProduct} = ? AND ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
            [
              widget.searchParams.productValue,
              widget.searchParams.brandValue,
              widget.searchParams.regionValue,
              widget.searchParams.suburbValue,
              widget.searchParams.includeSurrounding ? 1 : 0
            ])) ==
        1) {
      setState(() {
        _favourite = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        elevation: 0,
        actions: [
          IconButton(
            key: Key('Favourite Button'),
              icon: (_favourite) ? Icon(Icons.star) : Icon(Icons.star_border_outlined),
              onPressed: () {
                _favouriteSearch(widget.searchParams);
              }),
        ],
      ),
      body: LayoutBuilder(
        builder: (cxt, con) => Column(
          children: [
            SizedBox(
              height: con.maxHeight * 0.1,
              child: Container(
                decoration: BoxDecoration(border: Border(bottom: BorderSide()), color: ThemeColor.lightBackground),
                child: TabBar(
                  indicator: _CustomTabIndicator(),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  controller: _controller,
                  tabs: [
                    Tab(text: 'Today'),
                    Tab(text: 'Tomorrow'),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: con.maxHeight * 0.9,
              child: TabBarView(
                controller: _controller,
                children: [_buildTodaySearch(con), _buildTomorrowSearch(con)],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///Displays prices and stations list for today
  Widget _buildTodaySearch(Constraints con) {
    return (fuelStationsToday == null)
        ? Center(
            child: CircularProgressIndicator(color: ThemeColor.mainColor),
          )
        : (fuelStationsToday.length != 0)
            ? ListView.separated(
                itemCount: fuelStationsToday.length + 1,
                itemBuilder: (context, index) {
                  if (index == fuelStationsToday.length) { //adds separator icon after last item
                    return Container();
                  }
                  return _buildTile(con, index, fuelStationsToday[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  );
                },
              )
            : Center(
                child: Text(
                  'No data found.',
                  textAlign: TextAlign.center,
                ),
              );
  }

  ///Displays prices and stations list for tomorrow
  Widget _buildTomorrowSearch(Constraints con) {
    return (fuelStationsTomorrow == null)
        ? Center(
            child: CircularProgressIndicator(color: ThemeColor.mainColor),
          )
        : (fuelStationsTomorrow.length != 0)
            ? ListView.separated(
                itemCount: fuelStationsTomorrow.length + 1,
                itemBuilder: (context, index) {
                  if (index == fuelStationsTomorrow.length) {
                    return Container();
                  }
                  return _buildTile(con, index, fuelStationsTomorrow[index]);
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: Colors.black,
                    height: 1,
                    thickness: 1,
                  );
                },
              )
            : Center(
                child: Text(
                'No data found.\nTomorrows prices are updated at 2:30pm.',
                textAlign: TextAlign.center,
              ));
  }

  ///Displays price and station info in a list tile
  Widget _buildTile(BoxConstraints con, int index, FuelStation fuelStation) {
    return InkWell(
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) => SingleStationPage(station: fuelStation))),
        child: Container(
          child: SizedBox(
            height: (_textSizeCalc(fuelStation.tradingName, TextStyle(fontSize: 20), 2, con.maxWidth * 0.6).height  + _textSizeCalc('${fuelStation.address}, ${fuelStation.locationName}', TextStyle(), 1, con.maxWidth * 0.6).height) + 10,
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: Text(
                          '${fuelStation.price}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 16.0),
                        child: SizedBox(
                          width: con.maxWidth * 0.6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${fuelStation.tradingName}',
                                style: TextStyle(fontSize: 20),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${fuelStation.address}, ${fuelStation.locationName}',
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(Icons.chevron_right),
                )
              ],
            ),
          ),
        ));
  }

  ///Calculates height of text (over multiple lines of text if necessary)
  Size _textSizeCalc(String text, TextStyle style, int maxLines, double maxWidth) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: text, style: style), maxLines: maxLines, textDirection: TextDirection.ltr, textScaleFactor: MediaQuery.of(context).textScaleFactor)
      ..layout(minWidth: 0, maxWidth: maxWidth);
    return textPainter.size;
  }

  ///Adds/removes this search to the favourites database
  void _favouriteSearch(SearchParams searchParameters) async {
    setState(() {
      _favourite = !_favourite;
    });

    Database database = await DBHelper().getFavouritesDatabase();

    if (_favourite) {
      await database.rawInsert(
          'INSERT INTO ${Resources.dbFavourites}(${Resources.dbProduct}, ${Resources.dbBrand}, ${Resources.dbRegion}, ${Resources.dbSuburb}, ${Resources.dbIncludeSurrounding}, ${Resources.dbPushNotification}) VALUES(${searchParameters.productValue}, ${searchParameters.brandValue}, ${searchParameters.regionValue}, \'${searchParameters.suburbValue}\', ${searchParameters.includeSurrounding ? 1 : 0}, 0)');
    } else {
      await database.rawDelete(
          'DELETE FROM favourites WHERE ${Resources.dbProduct} = ? AND ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
          [
            widget.searchParams.productValue,
            widget.searchParams.brandValue,
            widget.searchParams.regionValue,
            widget.searchParams.suburbValue,
            widget.searchParams.includeSurrounding ? 1 : 0
          ]);
    }
  }
}

///Custom tab indicator for the 'today/tomorrow' tab selector
class _CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback onChanged]) {
    return _CustomPainter();
  }
}

///Draws a orange rounded box as the tab indicator with a static divider
class _CustomPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paintLine = Paint();
    paintLine.color = Colors.grey;
    paintLine.style = PaintingStyle.stroke;
    paintLine.strokeWidth = 1;
    canvas.drawLine(Offset(configuration.size.width, configuration.size.height / 6),
        Offset(configuration.size.width, configuration.size.height - configuration.size.height / 6), paintLine);

    final Rect rect = Offset(offset.dx + (configuration.size.width / 6), configuration.size.height / 6) &
        Size(configuration.size.width / 1.5, configuration.size.height / 1.5);
    final Paint paint = Paint();
    paint.color = ThemeColor.mainColor;
    paint.style = PaintingStyle.fill;
    paint.strokeWidth = 3;
    canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(15.0)), paint);
  }
}
