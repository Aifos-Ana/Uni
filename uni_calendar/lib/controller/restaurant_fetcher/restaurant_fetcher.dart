import 'package:uni_calendar/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni_calendar/model/entities/restaurant.dart';
/// Class for fetching the menu
abstract class RestaurantFetcher {
  Future<List<Restaurant>> getRestaurants(Store<AppState> store);
}