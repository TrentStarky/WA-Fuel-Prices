import 'package:result_type/result_type.dart';
import 'package:wa_fuel/app/app.locator.dart';
import 'package:wa_fuel/models/api_exception.dart';
import 'package:wa_fuel/models/favourite.dart';
import 'package:wa_fuel/services/rss_service.dart';

class FavouriteService {
  final _rssService = locator<RssService>();

  //todo
  // Future<Result<dynamic, ApiException>> getFavouritePrices(Favourite favourite) async {
  //
  //   return Success(null);
  // }
}