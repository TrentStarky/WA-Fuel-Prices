import 'package:stacked/stacked.dart';
import 'package:wa_fuel/app/app.locator.dart';
import 'package:wa_fuel/services/search_service.dart';

enum SelectedArea {
  none,
  region,
  suburb,
}

class SearchViewModel extends BaseViewModel {
  final _searchService = locator<SearchService>();
  String? product;
  String? brand;
  String? region;
  String? suburb;
  SelectedArea selectedArea = SelectedArea.none;

  void changeProduct(String? newProduct) {
    product = newProduct;
  }

  void changeBrand(String? newBrand) {
    brand = newBrand;
  }
  void changeRegion(String? newRegion) {
    if (newRegion == null) {
      selectedArea = SelectedArea.none;
    } else {
      selectedArea = SelectedArea.region;
    }
    region = newRegion;
    notifyListeners();
  }
  void changeSuburb(String? newSuburb) {
    if (newSuburb == null) {
      selectedArea = SelectedArea.none;
    } else {
      selectedArea = SelectedArea.suburb;
    }
    suburb = newSuburb;
    notifyListeners();
  }

  void search() async {
    print('Product: $product, Brand: $brand, Region: $region, Suburb: $suburb');
    final result = await _searchService.search();
    if (result.isSuccess) {
      print(result.success);
    } else {
      print(result.failure);
    }
  }
}