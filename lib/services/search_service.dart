import 'package:result_type/result_type.dart';
import 'package:wa_fuel/app/app.locator.dart';
import 'package:wa_fuel/models/api_exception.dart';
import 'package:wa_fuel/models/fuel_station.dart';
import 'package:wa_fuel/models/search_params.dart';
import 'package:wa_fuel/services/rss_parser.dart';
import 'package:wa_fuel/services/rss_service.dart';

class SearchService {
  final _rssService = locator<RssService>();

  Future<Result<List<FuelStation>, ApiException>> search() async {
    final result =
        await _rssService.searchFuelStations(searchParams: SearchParams(product: '1'));

    if (result.isSuccess) {
      final feed = RssParser().parse(result.success);
      return Success(feed);
    } else {
      return Failure(result.failure);
    }
  }
}
