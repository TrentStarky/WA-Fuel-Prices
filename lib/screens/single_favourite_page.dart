import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/app_state.dart';
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
  int _radioGroupValue;

  ///init variables
  @override
  void initState() {
    _pushNotif = false;
    _radioGroupValue = 1;
    _getNotificationSetting().then((value) {
      setState(() {
        if (value == 2) {
          _radioGroupValue = 2;
        }
        _pushNotif = (value != 0);
      });
    });
    super.initState();
  }

  ///Check database for push notification value
  Future<int> _getNotificationSetting() async {
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
      return returnVal[0]['${Resources.dbPushNotification}'];
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite'),
        centerTitle: true,
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
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: _fontSize),
                    children: [
                      TextSpan(
                          text:
                              '${Resources.productsRssToString[widget.favourite.searchParams.productValue]}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: _fontSize))
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: 'Brand: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: _fontSize),
                    children: [
                      TextSpan(
                          text:
                              '${Resources.brandsRssToString[widget.favourite.searchParams.brandValue]}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: _fontSize))
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RichText(
                text: TextSpan(
                    text: (widget.favourite.searchParams.suburbValue !=
                            'Any Suburb')
                        ? 'Suburb: '
                        : 'Region: ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: _fontSize),
                    children: [
                      TextSpan(
                          text:
                              '${widget.favourite.searchParams.getLocation()}',
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: _fontSize))
                    ]),
              ),
            ),
            (widget.favourite.searchParams.suburbValue != 'Any Suburb')
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                          text: 'Include Surrounding: ',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: _fontSize),
                          children: [
                            TextSpan(
                                text:
                                    '${widget.favourite.searchParams.includeSurrounding ? 'Yes' : 'No'}',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: _fontSize))
                          ]),
                    ),
                  )
                : Container(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Switch(
                  value: _pushNotif,
                  onChanged: (switchValue) async {
                    ///Update push notification value in database
                    _updateNotificationInDatabase(switchValue ? 1 : 0);
                    _radioGroupValue = 1;
                    setState(() {
                      _pushNotif = switchValue;
                    });
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    'Enable push notifications? ',
                    style: TextStyle(fontSize: _fontSize),
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            (_pushNotif)
                ? Column(
                    children: [
                      RadioListTile(
                        value: 1,
                        groupValue: _radioGroupValue,
                        onChanged: (radioValue) {
                          setState(() {
                            _radioGroupValue = radioValue;
                            _updateNotificationInDatabase(1);
                          });
                        },
                        title: Text('Daily updates'),
                      ),
                      RadioListTile(
                        value: 2,
                        groupValue: _radioGroupValue,
                        onChanged: (radioValue) {
                          setState(() {
                            _radioGroupValue = radioValue;
                            _updateNotificationInDatabase(2);
                          });
                        },
                        title: Text('Only on price increases'),
                      ),
                    ],
                  )
                : Container(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (await _confirmDeletion()) {
                      Provider.of<AppState>(context, listen: false)
                          .remove(widget.favourite);

                      ///Remove favourite from database
                      Database database =
                          await DBHelper().getFavouritesDatabase();
                      database.rawUpdate(
                          'DELETE FROM ${Resources.dbFavourites} WHERE ${Resources.dbProduct} = ? AND  ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
                          [
                            widget.favourite.searchParams.productValue,
                            widget.favourite.searchParams.brandValue,
                            widget.favourite.searchParams.regionValue,
                            widget.favourite.searchParams.suburbValue,
                            widget.favourite.searchParams.includeSurrounding
                                ? 1
                                : 0
                          ]);
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    elevation: MaterialStateProperty.all<double>(0.0),
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

  void _updateNotificationInDatabase(int notificationValue) async {
    Database database = await DBHelper().getFavouritesDatabase();
    database.rawUpdate(
        'UPDATE ${Resources.dbFavourites} SET ${Resources.dbPushNotification} = ? WHERE ${Resources.dbProduct} = ? AND  ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
        [
          notificationValue,
          widget.favourite.searchParams.productValue,
          widget.favourite.searchParams.brandValue,
          widget.favourite.searchParams.regionValue,
          widget.favourite.searchParams.suburbValue,
          widget.favourite.searchParams.includeSurrounding ? 1 : 0
        ]);
  }

  Future<bool> _confirmDeletion() async {
    return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  actions: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        textStyle: MaterialStateProperty.all(
                            TextStyle(fontWeight: FontWeight.bold)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: Text('Delete'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                    TextButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.of(context).pop(false),
                    )
                  ],
                )) ??
        false;
  }
}
