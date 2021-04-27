import 'package:wa_fuel/services/rss_parser.dart';
import 'package:xml/xml.dart';

///CLASS: FuelStation
///Stores information about a fuel station obtained from RSS feed
class FuelStation {
  String brand;
  String date;
  String price;
  String tradingName;
  String locationName;
  String address;
  String phone;
  String latitude;
  String longitude;
  String siteFeatures;

  FuelStation._();

  FuelStation.fromRssFeed(XmlElement element) {
    FuelStation._();

    brand = RssParser().findFirstElement(element, 'brand')?.text;
    date = RssParser().findFirstElement(element, 'date')?.text;
    price = RssParser().findFirstElement(element, 'price')?.text;
    tradingName = RssParser().findFirstElement(element, 'trading-name')?.text;
    locationName = RssParser().findFirstElement(element, 'location')?.text;
    address = RssParser().findFirstElement(element, 'address')?.text;
    phone = RssParser().findFirstElement(element, 'phone')?.text;
    latitude = RssParser().findFirstElement(element, 'latitude')?.text;
    longitude = RssParser().findFirstElement(element, 'longitude')?.text;
    siteFeatures = RssParser().findFirstElement(element, 'site-features')?.text;
  }
}
