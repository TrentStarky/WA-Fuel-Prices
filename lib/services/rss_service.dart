import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:result_type/result_type.dart';
import 'package:wa_fuel/models/api_exception.dart';
import 'package:wa_fuel/models/search_params.dart';


class RssService {
  final String _baseUrl = 'www.fuelwatch.wa.gov.au';
  final String _rssPath = '/fuelwatch/fuelWatchRSS';

  Future<Result<dynamic, ApiException>> searchFuelStations({
    required SearchParams searchParams,
  }) async {
    try {
      final response = await http.Client()
          .get(Uri.https(_baseUrl, _rssPath, searchParams.toMap()))
          .timeout(const Duration(seconds: 5));

      return Success(response.body);

    } on TimeoutException catch (e) {
      print('TimeoutException');
      print(e);
      return Failure(ApiException(e.toString()));
    } on Exception catch (e) {
      print('Exception');
      print(e);
      return Failure(ApiException(e.toString()));
    } on Error catch (e) {
      print('Error');
      print(e);
      return Failure(ApiException(e.toString()));
    }
  }
}
