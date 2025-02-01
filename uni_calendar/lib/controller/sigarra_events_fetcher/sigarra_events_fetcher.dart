import 'package:uni_calendar/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';

abstract class SigarraEventsFetcher {
  Future<List<CalendarItem>> getSigarraEvents(Store<AppState> store);
}