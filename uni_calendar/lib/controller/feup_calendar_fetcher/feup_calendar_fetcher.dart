import 'package:uni_calendar/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';

abstract class FeupCalendarFetcher {
  Future<List<CalendarItem>> getFeupCalendar(Store<AppState> store);
}