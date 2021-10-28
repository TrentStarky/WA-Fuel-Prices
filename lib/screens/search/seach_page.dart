import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/routing/transition_router.dart';
import 'package:wa_fuel/style.dart';
import 'package:wa_fuel/widgets/input_field.dart';

import '../../services/fuelwatch_service.dart';
import 'search_results_page.dart';

///CLASS: SearchPage
///Search parameters page to query to RSS feed
class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // final GlobalKey<DropdownSearchState> _productKey = GlobalKey();
  // final GlobalKey<DropdownSearchState> _brandKey = GlobalKey();
  // final GlobalKey<DropdownSearchState> _regionKey = GlobalKey();
  // final GlobalKey<DropdownSearchState> _suburbKey = GlobalKey();
  SearchParams searchParams = SearchParams();
  SelectedArea selectedArea = SelectedArea.none;

  ///init variables
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return Form(
            key: _formKey,
            child: ListView(
              children: [
                // const ProductSelector(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Product:',
                          style: ThemeText.textBold,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      items: Resources.productsStringToRss.keys.toList(),
                      onChanged: null,
                      selected: Resources.productsStringToRss.keys.toList()[0],
                      onSaved: (value) {
                        if (value == null) {
                          searchParams.productValue = '1';
                        } else {
                          searchParams.productValue = Resources.productsStringToRss[value]!;
                        }
                      },
                    ),
                  ],
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Brand:',
                          style: ThemeText.textBold,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      //  formKey: _brandKey,
                      hintText: '--Any Brand--',
                      items: Resources.brandsStringToRss.keys.toList(),
                      onChanged: null,
                      onSaved: (value) {
                        if (value == null) {
                          searchParams.brandValue = '0';
                        } else {
                          searchParams.brandValue = Resources.brandsStringToRss[value]!;
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Region:',
                          style: ThemeText.textBold,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      //   formKey: _regionKey,
                      hintText: '--All Regions--',
                      items: Resources.regionsStringToRss.keys.toList(),
                      enabled: (selectedArea != SelectedArea.suburb),
                      search: true,
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
                          searchParams.regionValue = Resources.regionsStringToRss[value]!;
                        }
                      },
                    ),
                  ],
                ),
                const Center(
                  child: Text('-- OR --'),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Suburb:',
                          style: ThemeText.textBold,
                        ),
                      ),
                    ),
                    CustomTextFormField(
                      //formKey: _suburbKey,
                      valueKey: Key('Suburb Dropdown'),
                      hintText: '--Any Suburb--',
                      items: Resources.suburbs,
                      enabled: (selectedArea != SelectedArea.region),
                      search: true,
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
                                  searchParams.includeSurrounding = !searchParams.includeSurrounding;
                                });
                              }),
                          const Text('Include surrounding suburbs?'),
                        ],
                      )
                    : Container(),
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
                  child: Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height:  MediaQuery.of(context).size.height * 0.07,
                      child: ElevatedButton(
                        key: const Key('Search Button'),
                        child: const Text(
                          'Search',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.zero),//symmetric(horizontal: con.maxWidth * 0.3, vertical: con.maxHeight * 0.03)),
                          backgroundColor: MaterialStateProperty.all<Color>(ThemeColor.mainColor),
                          elevation: MaterialStateProperty.all<double>(0.0),
                        ),
                        onPressed: () async {
                          _formKey.currentState!.save();
                          var fuelStationsTodayFuture = FuelWatchService.getFuelStationsToday(searchParams);
                          var fuelStationsTomorrowFuture = FuelWatchService.getFuelStationsTomorrow(searchParams);
                          Navigator.push(
                            context,
                            TransitionRouter.rightToLeft(
                              SearchResultsPage(
                                fuelStationsTodayFuture: fuelStationsTodayFuture,
                                fuelStationsTomorrowFuture: fuelStationsTomorrowFuture,
                                searchParams: searchParams,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.zero,//only(top: con.maxHeight * 0.04),
                  child: Center(
                    child: TextButton(
                      child: const Text('Clear Search'),
                      onPressed: () {
                        setState(() {
                          final val = _formKey.currentState;
                          _formKey.currentState?.reset(); //todo broken atm.
                          //clear all states and reset to initial values
                          // _productKey.currentState!.changeSelectedItem(Resources.productsStringToRss.keys.toList()[0]);
                          // _brandKey.currentState?.clear();
                          // _regionKey.currentState?.clear();
                          // _suburbKey.currentState?.clear();
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
        );
  }
}
