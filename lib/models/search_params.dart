class SearchParams {
  String product;
  String? brand;
  String? region;
  String? suburb;
  bool? includeSurrounding;

  SearchParams({required this.product, this.brand, this.region, this.suburb, this.includeSurrounding});


  Map<String, String> toMap() {
    return {
      'product': '1'
    };
  }
}