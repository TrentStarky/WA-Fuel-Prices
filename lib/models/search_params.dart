import 'package:wa_fuel/resources.dart';

///CLASS: SearchParams
///Stores information about a search
class SearchParams {
  late String productValue;
  late String brandValue;
  late String regionValue;
  late String suburbValue;
  late bool includeSurrounding;

  SearchParams() {
    productValue = '1';
    brandValue = '0';
    regionValue = '0';
    suburbValue = 'Any Suburb';
    includeSurrounding = false;
  }

  SearchParams.fromDatabase(Map databaseMap) {
    productValue = databaseMap[Resources.dbProduct].toString();
    brandValue = databaseMap[Resources.dbBrand].toString();
    regionValue = databaseMap[Resources.dbRegion].toString();
    suburbValue = databaseMap[Resources.dbSuburb].toString();
    includeSurrounding =
        databaseMap[Resources.dbIncludeSurrounding] == 1 ? true : false;
  }

  ///Converts SearchParams to a map to be used in RSS url, not setting variables with no change from initial values
  Map<String, String> toMap() {
    Map<String, String> map = {};

    if (productValue != '0') {
      map[Resources.productString] = productValue;
    }

    if (brandValue != '0') {
      map[Resources.brandString] = brandValue;
    }

    if (regionValue != '0') {
      map[Resources.regionString] = regionValue;
    }

    if (suburbValue != 'Any Suburb') {
      map[Resources.suburbString] = suburbValue;
    }

    if (includeSurrounding) {
      map[Resources.surroundingString] = 'yes';
    } else {
      map[Resources.surroundingString] = 'no';
    }

    return map;
  }

  ///returns region/suburb string depending on which is set (WA as default)
  String getLocation() {
    if (suburbValue != 'Any Suburb') {
      return suburbValue;
    } else if (regionValue != '0') {
      return Resources.regionsRssToString[regionValue]!;
    } else {
      return 'WA';
    }
  }

  SearchParams copy() {
    SearchParams newSearchParams = SearchParams();

    newSearchParams.suburbValue = suburbValue;
    newSearchParams.regionValue = regionValue;
    newSearchParams.includeSurrounding = includeSurrounding;
    newSearchParams.brandValue = brandValue;
    newSearchParams.productValue = productValue;

    return newSearchParams;
  }
}
