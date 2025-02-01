import 'dart:collection';

import 'package:flutter_test/flutter_test.dart';
import 'package:collection/collection.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';
import 'package:uni_calendar/view/Pages/search_page_view.dart' as sp;

void main(){
  final LinkedHashMap<DateTime, List<CalendarItem>> testEvents
  = LinkedHashMap(equals: isSameDay, hashCode: sp.getHashCode);

  DateTime date = DateTime.now();
  for(int i = 0; i < 3; i++) {
    date = date.add(Duration(days: i));
    testEvents.addAll(
        {
          date: [
            CalendarItem(
                name: 'Test Event ' + i.toString(),
                date: date,
                type: CalendarEventType.values[i])
          ]
        }
    );
  }

  group('SearchPage', () {
    test('When given an empty search', (){
      // Create expected result
      final List<CalendarItem> expectedResult = [];
      testEvents.forEach((key, value) { expectedResult.addAll(value);});

      // Create state of page
      final pState = sp.SearchPageViewState();
      // Set the test events
      pState.setEvents(testEvents);

      // Perform a empty search
      pState.Search('', [], testing: true);

      // Check if we get the expected result
      final bool equal
      = ListEquality().equals(pState.getSelectedEvents(), expectedResult);
      expect(equal, true);
    });

    test('When we search for a specific event name', (){
      // Create expected result
      final List<CalendarItem> expectedResult = [];
      expectedResult.add(testEvents.values.first[0]);

      // Create state of page
      final pState = sp.SearchPageViewState();
      // Set the test events
      pState.setEvents(testEvents);

      // Perform an empty search
      pState.Search('Test event 0', [], testing: true);

      // Check if we get the expected result
      final bool equal
      = ListEquality().equals(pState.getSelectedEvents(), expectedResult);
      expect(equal, true);
    });

    test('When we filter to General Events', (){
      // Create expected result
      final List<CalendarItem> expectedResult = [];
      expectedResult.add(testEvents.values.toList()[1][0]);

      // Create state of page
      final pState = sp.SearchPageViewState();
      // Set the test events
      pState.setEvents(testEvents);

      // Perform an empty search
      pState.Search('', ["General"], testing: true);

      // Check if we get the expected result
      final bool equal
      = ListEquality().equals(pState.getSelectedEvents(), expectedResult);
      expect(equal, true);
    });

    test('When we apply two filters', (){
      // Create expected result
      final List<CalendarItem> expectedResult = [];
      expectedResult.add(testEvents.values.toList()[1][0]);
      expectedResult.add(testEvents.values.toList()[2][0]);

      // Create state of page
      final pState = sp.SearchPageViewState();
      // Set the test events
      pState.setEvents(testEvents);

      // Perform an empty search
      pState.Search('', ["General", "FeupCalendar"], testing: true);

      // Check if we get the expected result
      final bool equal
      = ListEquality().equals(pState.getSelectedEvents(), expectedResult);
      expect(equal, true);
    });
  });
}