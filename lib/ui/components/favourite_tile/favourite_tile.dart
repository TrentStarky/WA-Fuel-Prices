// import 'package:flutter/material.dart';
// import 'package:stacked/stacked.dart';
// import 'package:wa_fuel/models/favourite.dart';
// import 'package:wa_fuel/ui/components/favourite_tile/favourite_tile_viewmodel.dart';
//
// class FavouriteTile extends StatelessWidget {
//   final Favourite favourite;
//
//   const FavouriteTile({Key? key, required this.favourite}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ViewModelBuilder<FavouriteTileViewModel>.reactive(
//       viewModelBuilder: () => FavouriteTileViewModel(favourite),
//       builder: (context, model, child) => Container(
//         padding: const EdgeInsets.all(8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 Center(
//                   //todo: add 80% width box
//                   child: Text(favourite.location),
//                 ),
//                 Align(
//                   alignment: AlignmentDirectional.centerEnd,
//                   child: GestureDetector(
//                     onTap: model.openSettings,
//                     child: Icon(Icons.settings),
//                   ),
//                 )
//               ],
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: model.productColor, width: 2),
//                   ),
//                   child: Padding(
//                     padding: EdgeInsets.all(4),
//                     child: Text(model.favourite.product),
//                   ),
//                 ),
//                 VerticalDivider(),
//                 Text(model.favourite.displayBrand),
//               ],
//             ),
//             Divider(),
//             model.dataReady
//                 ? Row(
//                     children: [
//                       Column(
//                         children: [
//                           Text(model.data['today price']),
//                         ],
//                       ), // today price
//                       Column(
//                         children: [
//                           Text(model.data['tomorrow price']),
//                         ],
//                       ), // tomorrow price
//                     ],
//                   )
//                 : CircularProgressIndicator(),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// //Container(
// //       padding: const EdgeInsets.all(8),
// //       decoration: const BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.all(Radius.circular(20)),
// //       ),
// //       child: Column(
// //         children: [
// //           Column(
// //             children: [
// //               Stack(children: [
// //                 Align(
// //                   alignment: Alignment.center,
// //                   child: Padding(
// //                     padding: const EdgeInsets.only(top: 8.0),
// //                     child: Text(
// //                       widget.favourite.searchParams.getLocation(),
// //                       style: ThemeText.textTileHeader,
// //                       textAlign: TextAlign.center,
// //                     ),
// //                   ),
// //                 ),
// //                 Align(
// //                   alignment: Alignment.centerRight,
// //                   child: IconButton(
// //                     constraints: BoxConstraints.tight(const Size(25, 25)),
// //                     padding: EdgeInsets.zero,
// //                     onPressed: () {
// //                       Navigator.push(
// //                           context,
// //                           TransitionRouter.bottomToTop(
// //                               SingleFavouritePage(widget.favourite)));
// //                     },
// //                     icon: const Icon(
// //                       Icons.settings,
// //                       color: Colors.grey,
// //                     ),
// //                   ),
// //                 ),
// //                 const Align(
// //                   alignment: Alignment.centerLeft,
// //                   child: Icon(
// //                     Icons.menu,
// //                     color: Colors.grey,
// //                   ),
// //                 ),
// //               ]),
// //               Padding(
// //                 padding: const EdgeInsets.only(top: 4.0),
// //                 child: Row(
// //                   children: [
// //                     Expanded(
// //                       child: Center(
// //                         child: Container(
// //                           padding: const EdgeInsets.symmetric(
// //                               vertical: 4, horizontal: 8),
// //                           decoration: BoxDecoration(
// //                               border: Border.all(
// //                                 color: Resources.productsColors[widget
// //                                     .favourite.searchParams.productValue]!,
// //                                 width: 2,
// //                               ),
// //                               borderRadius:
// //                                   const BorderRadius.all(Radius.circular(10))),
// //                           child: Text(
// //                             '${Resources.productsShort[widget.favourite.searchParams.productValue]}',
// //                             style: const TextStyle(
// //                               fontWeight: FontWeight.bold,
// //                             ),
// //                           ),
// //                         ),
// //                       ),
// //                     ),
// //                     const SizedBox(
// //                         height: 20,
// //                         child: VerticalDivider(
// //                           width: 2,
// //                           thickness: 1,
// //                           color: Colors.black,
// //                         )),
// //                     Expanded(
// //                         child: Center(
// //                             child: Text(
// //                                 '${Resources.brandsRssToString[widget.favourite.searchParams.brandValue]}')))
// //                   ],
// //                 ),
// //               ),
// //               const Padding(
// //                 padding: EdgeInsets.only(top: 4.0, bottom: 8.0),
// //                 child: Divider(
// //                   height: 8,
// //                   thickness: 1,
// //                   color: Colors.black12,
// //                   indent: 24,
// //                   endIndent: 24,
// //                 ),
// //               )
// //             ],
// //           ),
// //           TabBar(
// //             indicator: _CustomTabIndicator(),
// //             controller: controller,
// //             tabs: [
// //               TextButton(
// //                 style: const ButtonStyle(
// //                   splashFactory: NoSplash.splashFactory,
// //                 ),
// //                 onPressed: () {
// //                   setState(() {
// //                     if (displayDayValue != DisplayDay.today) {
// //                       displayDayValue = DisplayDay.today;
// //                       controller.index = 0;
// //                     } else {
// //                       displayDayValue = DisplayDay.none;
// //                     }
// //                   });
// //                 },
// //                 child: Column(
// //                   children: [
// //                     Text(
// //                       '${widget.favourite.favouriteData?.todayBestPrice ?? '-'}',
// //                       style: ThemeText.textPrice,
// //                     ),
// //                     Container(
// //                       height: 1.0,
// //                       color: Colors.black,
// //                       width: 60,
// //                     ),
// //                     const Text(
// //                       'Today',
// //                       style: ThemeText.textNormal,
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 4.0),
// //                       child: Container(
// //                         decoration: const ShapeDecoration(
// //                             shape: CircleBorder(side: BorderSide())),
// //                         child: (displayDayValue == DisplayDay.today)
// //                             ? const Icon(Icons.keyboard_arrow_up)
// //                             : const Icon(Icons.keyboard_arrow_down),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //               TextButton(
// //                 style: const ButtonStyle(
// //                   splashFactory: NoSplash.splashFactory,
// //                 ),
// //                 onPressed: () {
// //                   setState(() {
// //                     if (displayDayValue != DisplayDay.tomorrow) {
// //                       displayDayValue = DisplayDay.tomorrow;
// //                       controller.index = 1;
// //                     } else {
// //                       displayDayValue = DisplayDay.none;
// //                     }
// //                   });
// //                 },
// //                 child: Column(
// //                   children: [
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.center,
// //                       children: [
// //                         _paintChangeIcon(_getChangeIcon(widget.favourite.favouriteData?.todayStations?.first, widget.favourite.favouriteData?.tomorrowStations?.first)),
// //                         Text(
// //                           '${widget.favourite.favouriteData?.tomorrowBestPrice ?? '-'}',
// //                           style: ThemeText.textPrice,
// //                         ),
// //                       ],
// //                     ),
// //                     Container(
// //                       height: 1.0,
// //                       color: Colors.black,
// //                       width: 80,
// //                     ),
// //                     const Text(
// //                       'Tomorrow',
// //                       style: ThemeText.textNormal,
// //                     ),
// //                     Padding(
// //                       padding: const EdgeInsets.only(top: 4.0),
// //                       child: Container(
// //                         decoration: const ShapeDecoration(
// //                             shape: CircleBorder(side: BorderSide())),
// //                         child: (displayDayValue == DisplayDay.tomorrow)
// //                             ? const Icon(Icons.keyboard_arrow_up)
// //                             : const Icon(Icons.keyboard_arrow_down),
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             ],
// //           ),
// // //          (displayDayValue != DisplayDay.none)
// // //              ? SizedBox(
// // //                  height: _calculateTabHeight(),
// // //                  child: TabBarView(
// // //                    controller: controller,
// // //                    children: [
// // //                      _createStationDropdown(widget.itemInstance.todayStations),
// // //                      _createStationDropdown(widget.itemInstance.tomorrowStations),
// // //                    ],
// // //                  ),
// // //                )
// // //              : Container(),
// //
// //           if (displayDayValue == DisplayDay.today)
// //             _createStationDropdown(
// //                 widget.favourite.favouriteData?.todayStations)
// //           else if (displayDayValue == DisplayDay.tomorrow)
// //             _createStationDropdown(
// //                 widget.favourite.favouriteData?.tomorrowStations)
// //         ],
// //       ),
// //     );
