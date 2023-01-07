// import 'package:wa_fuel/app/app_constants.dart';
//
// class Favourite {
//   String product;
//   String brand;
//   String? region;
//   String? suburb;
//   bool? includeSurrounding;
//   int order;
//
//   Favourite({
//     required this.product,
//     required this.brand,
//     this.region,
//     this.suburb,
//     this.includeSurrounding,
//     required this.order,
//   });
//
//   /// Display String representing the location of the search
//   String get location {
//     assert(region != null || suburb != null);
//
//     if (region != null) {
//       return AppConstants.rssRegions[region]!.toUpperCase();
//     } else {
//       return suburb!;
//     }
//   }
//
//   String get displayBrand {
//     return AppConstants.rssBrands[brand]!;
//   }
// }
