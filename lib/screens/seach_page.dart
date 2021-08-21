import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/style.dart';

import '../services/fuelwatch_service.dart';
import 'search_results_page.dart';

///CLASS: SearchPage
///Search parameters page to query to RSS feed
class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<DropdownSearchState> _productKey = GlobalKey();
  final GlobalKey<DropdownSearchState> _brandKey = GlobalKey();
  final GlobalKey<DropdownSearchState> _regionKey = GlobalKey();
  final GlobalKey<DropdownSearchState> _suburbKey = GlobalKey();
  SearchParams searchParams;
  SelectedArea selectedArea;

  ///init variables
  @override
  void initState() {
    searchParams = SearchParams();
    selectedArea = SelectedArea.none;

    var keyboardVisibilityController = KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, con) => Form(
        key: _formKey,
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Product:',
                      style: ThemeText.textBold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownSearch<String>(
                            key: _productKey,
                            mode: Mode.BOTTOM_SHEET,
                            items: Resources.productsStringToRss.keys.toList(),
                            onSaved: (value) {
                              if (value == null) {
                                searchParams.productValue = '1';
                              } else {
                                searchParams.productValue =
                                    Resources.productsStringToRss[value];
                              }
                            },
                            selectedItem:
                                Resources.productsStringToRss.keys.toList()[0],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Brand:',
                      style: ThemeText.textBold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownSearch<String>(
                            key: _brandKey,
                            mode: Mode.BOTTOM_SHEET,
                            showClearButton: true,
                            hint: '--Any Brand--',
                            items: Resources.brandsStringToRss.keys.toList(),
                            onSaved: (value) {
                              if (value == null) {
                                searchParams.brandValue = '0';
                              } else {
                                searchParams.brandValue =
                                    Resources.brandsStringToRss[value];
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Region:',
                      style: ThemeText.textBold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownSearch<String>(
                            key: _regionKey,
                            emptyBuilder: (context, temp) => Scaffold(
                              body: Center(
                                child: Text('No locations found'),
                              ),
                            ),
                            mode: Mode.BOTTOM_SHEET,
                            showClearButton: true,
                            showSearchBox: true,
                            enabled: (selectedArea != SelectedArea.suburb),
                            hint: '--All Regions--',
                            searchBoxDecoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: OutlineInputBorder(),
                            ),
                            items: Resources.regionsStringToRss.keys.toList(),
                            onChanged: (value) {
                              if (value == null || value == '0') {
                                setState(() {
                                  selectedArea = SelectedArea.none;
                                });
                              } else {
                                setState(() {
                                  selectedArea = SelectedArea.region;
                                });
                              }
                            },
                            onSaved: (value) {
                              if (value == null) {
                                searchParams.regionValue = '0';
                              } else {
                                searchParams.regionValue =
                                    Resources.regionsStringToRss[value];
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Center(
              child: Text('-- OR --'),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Suburb:',
                      style: ThemeText.textBold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      children: [
                        ButtonTheme(
                          key: Key('Suburb Dropdown'),
                          alignedDropdown: true,
                          child: DropdownSearch<String>(
                            key: _suburbKey,
                            emptyBuilder: (context, temp) => Scaffold(
                              body: Center(
                                child: Text('No locations found'),
                              ),
                            ),
                            mode: Mode.BOTTOM_SHEET,
                            showClearButton: true,
                            showSearchBox: true,
                            enabled: (selectedArea != SelectedArea.region),
                            hint: '--Any Suburb--',
                            searchBoxDecoration: InputDecoration(
                              hintText: 'Search...',
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 0, 0),
                              border: OutlineInputBorder(),
                            ),
                            items: Resources.suburbs,
                            onChanged: (value) {
                              if (value == null || value == 'Any Suburb') {
                                setState(() {
                                  selectedArea = SelectedArea.none;
                                });
                              } else {
                                setState(() {
                                  selectedArea = SelectedArea.suburb;
                                });
                              }
                            },
                            onSaved: (value) {
                              if (value == null) {
                                searchParams.suburbValue = 'Any Suburb';
                              } else {
                                searchParams.suburbValue = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            //Only show the surrounding suburb checkbox when a suburb has been selected
            (selectedArea == SelectedArea.suburb)
                ? Row(
                    children: [
                      Checkbox(
                          value: searchParams.includeSurrounding,
                          onChanged: (value) {
                            setState(() {
                              searchParams.includeSurrounding =
                                  !searchParams.includeSurrounding;
                            });
                          }),
                      Text('Include surrounding suburbs?'),
                    ],
                  )
                : Container(),
            Padding(
              padding: EdgeInsets.only(top: con.maxHeight * 0.02),
              child: Center(
                child: ElevatedButton(
                  key: Key('Search Button'),
                  child: Text(
                    'Search',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            horizontal: con.maxWidth * 0.3,
                            vertical: con.maxHeight * 0.03)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(ThemeColor.mainColor),
                    elevation: MaterialStateProperty.all<double>(0.0),
                  ),
                  onPressed: () async {
                    _formKey.currentState.save();
                    var fuelStationsTodayFuture =
                        FuelWatchService.getFuelStationsToday(searchParams);
                    var fuelStationsTomorrowFuture =
                        FuelWatchService.getFuelStationsTomorrow(searchParams);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchResultsPage(
                          fuelStationsTodayFuture: fuelStationsTodayFuture,
                          fuelStationsTomorrowFuture:
                              fuelStationsTomorrowFuture,
                          searchParams: searchParams,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: con.maxHeight * 0.04),
              child: Center(
                child: TextButton(
                  child: Text('Clear Search'),
                  onPressed: () {
                    setState(() {
                      //clear all states and reset to initial values
                      _productKey.currentState.changeSelectedItem(
                          Resources.productsStringToRss.keys.toList()[0]);
                      _brandKey.currentState.clear();
                      _regionKey.currentState.clear();
                      _suburbKey.currentState.clear();
                      searchParams.productValue = '1';
                      searchParams.brandValue = '0';
                      searchParams.regionValue = '0';
                      searchParams.suburbValue = 'Any Suburb';
                      searchParams.includeSurrounding = false;
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
