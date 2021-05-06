import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/services/rss_parser.dart';

import 'package:http/http.dart' as http;
import 'package:wa_fuel/models/fuel_station.dart';

///CLASS: FuelWatchService
///Gets fuel price data from RSS feed
class FuelWatchService {
  ///Gets today's fuel prices
  static Future<List<FuelStation>> getFuelStationsToday(SearchParams searchParams) async {
    var baseUrl = 'www.fuelwatch.wa.gov.au';
    try {
      final client = http.Client();
      final response = await client.get(Uri.https(baseUrl, '/fuelwatch/fuelWatchRSS', searchParams.toMap()));

      final feed = RssParser().parse(response.body);

      return feed;
    } catch (error) {
      print('RSS Error: ' + error.toString());
    }

    return [];
  }

  ///Gets tomorrow's fuel prices
  static Future<List<FuelStation>> getFuelStationsTomorrow(SearchParams searchParams) async {
    var baseUrl = 'www.fuelwatch.wa.gov.au';
    try {
      final client = http.Client();
      final response = await client.get(Uri.https(baseUrl, '/fuelwatch/fuelWatchRSS',
          searchParams.toMap()..putIfAbsent(Resources.dayString, () => 'tomorrow')));

      final feed = RssParser().parse(response.body);

      return feed;
    } catch (error) {
      print('RSS Error: ' + error.toString());
    }

    return [];
  }
}
