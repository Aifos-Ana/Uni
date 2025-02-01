import 'dart:io';

import 'package:uni_calendar/controller/local_storage/app_events_database.dart';
import 'package:uni_calendar/controller/local_storage/app_favorites_database.dart';
import 'package:uni_calendar/controller/local_storage/app_sigarra_events_database.dart';
import 'package:uni_calendar/controller/local_storage/app_test_events_database.dart';
import 'package:uni_calendar/main.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();

  CalendarItem testEvent = CalendarItem(
      name: "EVENT_TEST_GHERKIN",
      date: DateTime(DateTime.now().year, DateTime.now().month + 2, 15),
      type: CalendarEventType.Exame);

  AppTestEventsDatabase().saveNewEvents(
      [ testEvent ]
  );

  // Call the `main()` function of your app or call `runApp` with any widget you
  // are interested in testing.
  initializeDateFormatting().then((_) => runApp(MyApp(testing: true,)));

  AppFavoritesDatabase().removeFavoriteEvent(testEvent);
}