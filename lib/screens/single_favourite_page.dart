import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/favourite.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/services/database_helper.dart';

///CLASS: SingleFavouritePage
///Displays information about a favourite
class SingleFavouritePage extends StatefulWidget {
  final Favourite favourite;

  SingleFavouritePage(this.favourite) : super();

  @override
  _SingleFavouritePageState createState() => _SingleFavouritePageState();
}

class _SingleFavouritePageState extends State<SingleFavouritePage> {
  bool _pushNotif;
  double _fontSize = 16;

  ///init variables
  @override
  void initState() {
    _pushNotif = false;
    _getNotificationSetting().then((value) {
      setState(() {
        _pushNotif = value;
      });
    });
    super.initState();
  }

  ///Check database for push notification value
  Future<bool> _getNotificationSetting() async {
    Database database = await DBHelper().getFavouritesDatabase();
    List<Map> returnVal = await database.rawQuery(
        'SELECT ${Resources.dbPushNotification} FROM ${Resources.dbFavourites} WHERE ${Resources.dbProduct} = ? AND  ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
        [
          widget.favourite.searchParams.productValue,
          widget.favourite.searchParams.brandValue,
          widget.favourite.searchParams.regionValue,
          widget.favourite.searchParams.suburbValue,
          widget.favourite.searchParams.includeSurrounding ? 1 : 0
        ]);
    if (returnVal.length == 1) {
      return (returnVal[0]['${Resources.dbPushNotification}'] != 0) ? true : false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: 'Product: ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: _fontSize),
                    children: [
                      TextSpan(
                          text: '${Resources.productsRssToString[widget.favourite.searchParams.productValue]}',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: _fontSize))
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: 'Brand: ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: _fontSize),
                    children: [
                      TextSpan(
                          text: '${Resources.brandsRssToString[widget.favourite.searchParams.brandValue]}',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: _fontSize))
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: (widget.favourite.searchParams.suburbValue != 'Any Suburb') ? 'Suburb: ' : 'Region: ',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: _fontSize),
                    children: [
                      TextSpan(
                          text: '${widget.favourite.searchParams.getLocation()}',
                          style: TextStyle(fontWeight: FontWeight.normal, fontSize: _fontSize))
                    ]),
              ),
            ),
            (widget.favourite.searchParams.suburbValue != 'Any Suburb')
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Include Surrounding: ',
                          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: _fontSize),
                          children: [
                            TextSpan(
                                text: '${widget.favourite.searchParams.includeSurrounding ? 'Yes' : 'No'}',
                                style: TextStyle(fontWeight: FontWeight.normal, fontSize: _fontSize))
                          ]),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Enable push notifications? ',
                  style: TextStyle(fontSize: _fontSize),
                ),
                Switch(
                  value: _pushNotif,
                  onChanged: (switchValue) async {
                    ///Update push notification value in database
                    Database database = await DBHelper().getFavouritesDatabase();
                    database.rawUpdate(
                        'UPDATE ${Resources.dbFavourites} SET ${Resources.dbPushNotification} = ? WHERE ${Resources.dbProduct} = ? AND  ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
                        [
                          switchValue ? 1 : 0,
                          widget.favourite.searchParams.productValue,
                          widget.favourite.searchParams.brandValue,
                          widget.favourite.searchParams.regionValue,
                          widget.favourite.searchParams.suburbValue,
                          widget.favourite.searchParams.includeSurrounding ? 1 : 0
                        ]);
                    setState(() {
                      _pushNotif = switchValue;
                    });
                  },
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    ///Remove favourite from database
                    Database database = await DBHelper().getFavouritesDatabase();
                    database.rawUpdate(
                        'DELETE FROM ${Resources.dbFavourites} WHERE ${Resources.dbProduct} = ? AND  ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
                        [
                          widget.favourite.searchParams.productValue,
                          widget.favourite.searchParams.brandValue,
                          widget.favourite.searchParams.regionValue,
                          widget.favourite.searchParams.suburbValue,
                          widget.favourite.searchParams.includeSurrounding ? 1 : 0
                        ]);
                    Navigator.pop(context, true);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text(
                    'Delete Favourite',
                    style: TextStyle(fontSize: _fontSize),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
