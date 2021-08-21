import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/resources.dart';
import 'package:wa_fuel/services/rss_parser.dart';

///CLASS: FuelWatchService
///Gets fuel price data from RSS feed
class FuelWatchService {
  static final String baseUrl = 'www.fuelwatch.wa.gov.au';
  static final String rssPath = '/fuelwatch/fuelWatchRSS';

  ///Gets today's fuel prices
  static Future<List<FuelStation>> getFuelStationsToday(
      SearchParams searchParams) async {
    try {
      final client = http.Client();
      final response = await client
          .get(Uri.https(baseUrl, rssPath, searchParams.toMap()))
          .timeout(Duration(seconds: 5));

      final feed = RssParser().parse(response.body);

      return feed;
    } on TimeoutException catch (_) {
      print('RSS Timeout');
      // HttpClientRequest.abort
    } catch (error) {
      print('RSS Error: ' + error.toString());
    }

    return [];
  }

  ///Gets tomorrow's fuel prices
  static Future<List<FuelStation>> getFuelStationsTomorrow(
      SearchParams searchParams) async {
    try {
      final client = http.Client();
      final response = await client
          .get(Uri.https(
              baseUrl,
              rssPath,
              searchParams.toMap()
                ..putIfAbsent(Resources.dayString, () => 'tomorrow')))
          .timeout(Duration(seconds: 5));

      final feed = RssParser().parse(response.body);

      return feed;
    } on TimeoutException catch (_) {
      print('RSS Timeout');
      // HttpClientRequest.abort
    } catch (error) {
      print('RSS Error: ' + error.toString());
    }

    return [];
  }
}
