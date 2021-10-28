import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wa_fuel/models/favourite.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/routing/transition_router.dart';
import 'package:wa_fuel/screens/favourites/station_tile.dart';
import 'single_favourite_page.dart';
import 'package:wa_fuel/services/painter.dart';
import 'package:wa_fuel/style.dart';

import 'favourites_page.dart';

///CLASS: FavouriteListItem
///Displays prices for a favourite in the favourites list
class FavouriteListItem extends StatefulWidget {
  final Favourite itemInstance;

  const FavouriteListItem(this.itemInstance, {Key? key}) : super(key: key);

  @override
  _FavouriteListItemState createState() => _FavouriteListItemState();
}

class _FavouriteListItemState extends State<FavouriteListItem> with TickerProviderStateMixin {
  late DisplayDay displayDayValue;
  late TabController controller;

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
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        color: Colors.white,
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
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.itemInstance.searchParams.getLocation(),
                      style: ThemeText.textTileHeader,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    constraints: BoxConstraints.tight(const Size(25, 25)),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.push(
                          context,  TransitionRouter.bottomToTop(SingleFavouritePage(widget.itemInstance)));
                    },
                    icon: const Icon(
                      Icons.settings,
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
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: Resources.productsColors[widget.itemInstance.searchParams.productValue]!,
                                width: 2,
                              ),
                              borderRadius: const BorderRadius.all(Radius.circular(10))),
                          child: Text(
                            '${Resources.productsShort[widget.itemInstance.searchParams.productValue]}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
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
              const Padding(
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
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
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
                      '${widget.itemInstance.todayBestPrice ?? '-'}',
                      style: ThemeText.textPrice,
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.black,
                      width: 60,
                    ),
                    const Text(
                      'Today',
                      style: ThemeText.textNormal,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        decoration: const ShapeDecoration(shape: CircleBorder(side: BorderSide())),
                        child: (displayDayValue == DisplayDay.today)
                            ? const Icon(Icons.keyboard_arrow_up)
                            : const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                style: const ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                ),
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
                          '${widget.itemInstance.tomorrowBestPrice ?? '-'}',
                          style: ThemeText.textPrice,
                        ),
                      ],
                    ),
                    Container(
                      height: 1.0,
                      color: Colors.black,
                      width: 80,
                    ),
                    const Text(
                      'Tomorrow',
                      style: ThemeText.textNormal,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Container(
                        decoration: const ShapeDecoration(shape: CircleBorder(side: BorderSide())),
                        child: (displayDayValue == DisplayDay.tomorrow)
                            ? const Icon(Icons.keyboard_arrow_up)
                            : const Icon(Icons.keyboard_arrow_down),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
//          (displayDayValue != DisplayDay.none)
//              ? SizedBox(
//                  height: _calculateTabHeight(),
//                  child: TabBarView(
//                    controller: controller,
//                    children: [
//                      _createStationDropdown(widget.itemInstance.todayStations),
//                      _createStationDropdown(widget.itemInstance.tomorrowStations),
//                    ],
//                  ),
//                )
//              : Container(),

          if (displayDayValue == DisplayDay.today)
            _createStationDropdown(widget.itemInstance.todayStations)
          else if (displayDayValue == DisplayDay.tomorrow)
            _createStationDropdown(widget.itemInstance.tomorrowStations)
        ],
      ),
    );
  }

  ///Paint the change icon depending on value
  Widget _paintChangeIcon(ChangeIcon? icon) {
    switch (icon) {
      case ChangeIcon.down:
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: CustomPaint(
            painter: TrianglePainter(fillColor: Colors.green, inversion: true),
            size: const Size(15, 15),
          ),
        );
      case ChangeIcon.up:
        return Padding(
          padding: const EdgeInsets.only(right: 4.0),
          child: CustomPaint(
            painter: TrianglePainter(fillColor: Colors.red, inversion: false),
            size: const Size(15, 15),
          ),
        );
      case ChangeIcon.steady:
        return Container();
      default:
        return Container();
    }
  }

  ///Creates a table showing top 5 lowest prices for that favourite
  Widget _createStationDropdown(List stations) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        color: Color(0xFFEEEEEE),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: (stations.isNotEmpty)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MainStationListTile(stations[0]),
                  for (int ii = 1; ii < 5 && ii < stations.length; ii++) StationListTile(stations[ii])
                ],
              )
            : const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Text(
                    'No data found.\nTomorrows prices are updated at 2:30pm.',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }

//  ///Calculates height of dropdown depending on how many stations need to be displayed
//  double _calculateTabHeight() {
//    int numToday = widget.itemInstance.todayStations.length;
//    int numTomorrow = widget.itemInstance.tomorrowStations.length;
//    int numToRender;
//
//    if (numToday >= 5) {
//      numToRender = 5;
//    } else if (numToday > numTomorrow) {
//      numToRender = numToday;
//    } else if (numTomorrow >= 1) {
//      numToRender = numTomorrow;
//    } else {
//      numToRender = 1;
//    }
//
//    var textSize = TextSizeCalculator.calculate(
//        'Pq', const TextStyle(fontWeight: FontWeight.bold), 1, double.infinity, MediaQuery.textScaleFactorOf(context));
//
//    return ((textSize.height + 35) * numToRender);
//  }
}

///CLASS: _CustomTabIndicator
///Custom (invisible) tab indicator for station dropdown
class _CustomTabIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _CustomPainter();
  }
}

///CLASS: _CustomPainter
///Paints nothing for the _CustomTabIndicator
class _CustomPainter extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {}
}
