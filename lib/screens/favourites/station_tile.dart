
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import '../search/single_station_page.dart';

///CLASS: StationListTile
///Displays station name and price in a list tile
class StationListTile extends StatelessWidget {
  final FuelStation mainStation;

  const StationListTile(this.mainStation, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            minimumSize: MaterialStateProperty.all<Size>(const Size(double.infinity, 16)),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                side: BorderSide(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(16))))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleStationPage(station: mainStation)));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Text(
                      '${mainStation.price}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const VerticalDivider(
                      color: Colors.black,
                    ),
                    Flexible(
                        child: Text(
                          mainStation.tradingName,
                          overflow: TextOverflow.ellipsis,
                        )),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_right,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///CLASS: MainStationListTile
///Gives special highlighting to cheapest station tile
class MainStationListTile extends StationListTile {
  @override
  final FuelStation mainStation;

  const MainStationListTile(this.mainStation, {Key? key}) : super(mainStation, key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            shape: MaterialStateProperty.all<OutlinedBorder>(const RoundedRectangleBorder(
                side: BorderSide(width: 2), borderRadius: BorderRadius.all(Radius.circular(20))))),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => SingleStationPage(station: mainStation)));
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        '${mainStation.price}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const VerticalDivider(
                        color: Colors.black,
                      ),
                      Flexible(
                          child: Text(
                            mainStation.tradingName,
                            overflow: TextOverflow.ellipsis,
                          )),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_right,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}