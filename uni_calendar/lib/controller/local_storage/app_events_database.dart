import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';

import 'app_database.dart';

/// Manages the app's Events database.
///
/// This database stores information about the faculty events.
/// See the [CalendarItem] class to see what data is stored in this database.
class AppEventsDatabase extends AppDatabase {
  AppEventsDatabase()
      : super('events.db',
        [
        '''
        CREATE TABLE Events(
          eventID INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          date DATE NOT NULL,
          type TEXT NOT NULL
        )
        '''
        ]
      );

  /// Replaces all of the data in this database with the data from [events].
  saveNewEvents(List<CalendarItem> events) async {
    await deleteEvents();
    await _insertEvents(events);
  }

  /// Returns a list containing all of the events stored in this database.
  Future<List<CalendarItem>> events() async {
    // Get a reference to the database
    final Database db = await getDatabase();
    if(db == null) return null;

    // Query the table for All The Courses.
    final List<Map<String, dynamic>> maps = await db.query('Events');

    // Convert the List<Map<String, dynamic> into a List<CalendarItem>.
    return List.generate(maps.length, (i) {
      return CalendarItem.fromJson(maps[i]);
      }
    );
  }

  /// Adds all items from [events] to this database.
  ///
  /// If a row with the same data is present, it will be replaced.
  Future<void> _insertEvents(List<CalendarItem> events) async {
    for (CalendarItem event in events) {
      await insertInDatabase(
        'Events',
        event.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Deletes all of the data stored in this database.
  Future<void> deleteEvents() async {
    // Get a reference to the database
    final Database db = await getDatabase();
    await db?.delete('Events');
  }
}
