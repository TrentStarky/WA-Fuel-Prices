import 'package:wa_fuel/resources.dart';

///CLASS: SearchParams
///Stores information about a search
class SearchParams {
  String productValue;
  String brandValue;
  String regionValue;
  String suburbValue;
  bool includeSurrounding;

  SearchParams._();

  SearchParams() {
    this.productValue = '1';
    this.brandValue = '0';
    this.regionValue = '0';
    this.suburbValue = 'Any Suburb';
    this.includeSurrounding = false;
  }

  SearchParams.fromDatabase(Map databaseMap) {
    SearchParams._();

    this.productValue = databaseMap['${Resources.dbProduct}'].toString();
    this.brandValue = databaseMap['${Resources.dbBrand}'].toString();
    this.regionValue = databaseMap['${Resources.dbRegion}'].toString();
    this.suburbValue = databaseMap['${Resources.dbSuburb}'].toString();
    this.includeSurrounding = databaseMap['${Resources.dbIncludeSurrounding}'] == 1 ? true : false;
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
    if (this.suburbValue != 'Any Suburb') {
      return this.suburbValue;
    } else if (this.regionValue != '0') {
      return Resources.regionsRssToString[this.regionValue];
    } else {
      return 'WA';
    }
  }
}
