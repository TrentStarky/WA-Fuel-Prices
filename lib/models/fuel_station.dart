import 'package:wa_fuel/services/rss_parser.dart';
import 'package:xml/xml.dart';

///CLASS: FuelStation
///Stores information about a fuel station obtained from RSS feed
class FuelStation {
  String brand;
  String date; //todo change to DateTime
  double price;
  String tradingName;
  String locationName;
  String address;
  String phone;
  double latitude;
  double longitude;
  String siteFeatures;

  FuelStation(
      {required this.brand,
      required this.date,
      required this.price,
      required this.tradingName,
      required this.locationName,
      required this.address,
      required this.phone,
      required this.latitude,
      required this.longitude,
      required this.siteFeatures});

  factory FuelStation.fromRssFeed(XmlElement element) => FuelStation(
        brand: RssParser().findFirstElement(element, 'brand')!.text,
        date: RssParser().findFirstElement(element, 'date')!.text,
        price: double.parse(RssParser().findFirstElement(element, 'price')!.text),
        tradingName: RssParser().findFirstElement(element, 'trading-name')!.text,
        locationName: RssParser().findFirstElement(element, 'location')!.text,
        address: RssParser().findFirstElement(element, 'address')!.text,
        phone: RssParser().findFirstElement(element, 'phone')!.text,
        latitude: double.parse(RssParser().findFirstElement(element, 'latitude')!.text),
        longitude: double.parse(RssParser().findFirstElement(element, 'longitude')!.text),
        siteFeatures: RssParser().findFirstElement(element, 'site-features')!.text,
      );

  //todo move to ui page
  ///Adds a '.0' to values that don't have a decimal from the feed for better formatting
  String _ensureDecimal(String value) {
    try {
      var num = double.parse(value);
      if (num % 1 == 0) {
        return value + '.0';
      }
      return value;
    } catch (_) {
      return value;
    }
  }
}
