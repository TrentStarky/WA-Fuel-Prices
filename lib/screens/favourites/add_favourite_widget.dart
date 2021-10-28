import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wa_fuel/models/app_state.dart';
import 'package:wa_fuel/models/favourite.dart';
import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/services/database_helper.dart';
import 'package:wa_fuel/widgets/input_field.dart';
import 'package:wa_fuel/widgets/product_selector.dart';

import '../../resources.dart';
import '../../style.dart';


class AddFavouriteWidget extends StatefulWidget {
  const AddFavouriteWidget({Key? key,}) : super(key: key);

  @override
  State<AddFavouriteWidget> createState() => _AddFavouriteWidgetState();
}

// class _AddFavouriteWidgetState extends State<AddFavouriteWidget> {
//
//   GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//
//   @override
//   Widget build(BuildContext context) {
//    return ElevatedButton(
//      child: Text('Add'),
//      onPressed: () {
//        showDialog(
//          context: context,
//          builder: (context) {
//            return Dialog(
//              child: Form(
//                key: _formKey,
//                child: Column(
//                  children: [
//                    DropdownSearch(
//                      items: [
//                        'test',
//                        'test2',
//                        'test3'
//                      ],
//                      showSearchBox: true,
//                    )
//                  ],
//                ),
//              ),
//            );
//          }
//
//        );
//      },
//    );
//   }

class _AddFavouriteWidgetState extends State<AddFavouriteWidget> {
  @override
  Widget build(BuildContext context) {
    TextEditingController controller2 = TextEditingController();

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: MediaQuery.of(context).size.height * 0.0125,
      ),
      child: GestureDetector(
        onTap: () async => await _showAddFavourite(controller2),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: Text('+ Add New Favourite', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddFavourite(TextEditingController controller2) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final GlobalKey<DropdownSearchState> _productKey = GlobalKey();
    final GlobalKey<DropdownSearchState> _brandKey = GlobalKey();
    final GlobalKey<DropdownSearchState> _regionKey = GlobalKey();
    final GlobalKey<DropdownSearchState> _suburbKey = GlobalKey();
    String? _errorText;
    SearchParams searchParams = SearchParams();
    SelectedArea selectedArea = SelectedArea.none;

    await showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            insetPadding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.05, vertical: MediaQuery.of(context).size.height * 0.05),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: StatefulBuilder(
              builder: (context, setState) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () => Navigator.of(context).pop(),
                                  ),
                                ),
                                const Align(
                                  alignment: Alignment.topCenter,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Text('Add Favourite', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  ),
                                ),
                              ],
                            ),
                            if (_errorText != null) Text(_errorText!, style: const TextStyle(color: ThemeColor.deepRed, fontWeight: FontWeight.bold),),

                            //const ProductSelector(),
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
                                  //formKey: _regionKey,
                                  hintText: '--All Regions--',
                                  items: Resources.regionsStringToRss.keys.toList(),
                                  enabled: (selectedArea != SelectedArea.suburb),
                                  search: true,
                                  controller: controller2,
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
                                  //    formKey: _suburbKey,
                                  hintText: '--Any Suburb--',
                                  items: Resources.suburbs,
                                  enabled: (selectedArea != SelectedArea.region),
                                  search: true,
                                  controller: controller2,
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
                            ElevatedButton(
                              onPressed: () async {
                                _formKey.currentState?.save();

                                print(searchParams.toMap());
                                if (await _favouriteSearch(context, searchParams)) {
                                  Navigator.of(context).pop();
                                } else {
                                  setState(() => _errorText = 'This favourite already exists!');
                                }
                              },
                              child: Text('Add Favourite'),
                            ),
                            SizedBox(
                              height: 20,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
            ),

          );
        });
  }

  Future<bool> _favouriteSearch(BuildContext context, SearchParams searchParams) async {
    Database database = await DBHelper().getFavouritesDatabase();

    if (Sqflite.firstIntValue(await database.rawQuery(
            'SELECT COUNT(*) FROM favourites WHERE ${Resources.dbProduct} = ? AND ${Resources.dbBrand} = ? AND ${Resources.dbRegion} = ? AND ${Resources.dbSuburb} = ? AND ${Resources.dbIncludeSurrounding} = ?',
            [
              searchParams.productValue,
              searchParams.brandValue,
              searchParams.regionValue,
              searchParams.suburbValue,
              searchParams.includeSurrounding ? 1 : 0
            ])) ==
        1) {
      print('oh no it already exists');
      return false;
    } else {
      Provider.of<AppState>(context, listen: false).add(Favourite.fromSearchParams(searchParams
          .copy())); //need to deep copy searchParams so that changes to the searchParam on the search page won't update the searchParams in the favourite
      await database.rawInsert(
          'INSERT INTO ${Resources.dbFavourites}(${Resources.dbProduct}, ${Resources.dbBrand}, ${Resources.dbRegion}, ${Resources.dbSuburb}, ${Resources.dbIncludeSurrounding}, ${Resources.dbPushNotification}) VALUES(${searchParams.productValue}, ${searchParams.brandValue}, ${searchParams.regionValue}, \'${searchParams.suburbValue}\', ${searchParams.includeSurrounding ? 1 : 0}, 0)');
      return true;
    }
  }
}
