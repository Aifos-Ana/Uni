import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:sqflite/sqflite.dart';
import 'package:test/scaffolding.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';

import 'app_database.dart';

/// Manages the app's Events database.
///
/// This database stores information about the faculty events.
/// See the [CalendarItem] class to see what data is stored in this database.
class AppFavoritesDatabase extends AppDatabase {
  AppFavoritesDatabase()
      : super('favorites.db',
      [
        '''
        CREATE TABLE Favorites(
          key INTEGER NOT NULL PRIMARY KEY
        );
        '''
      ]
  );

  int getHashCode(CalendarItem c) {
    final bytes = utf8.encode(c.name + c.date.toString()); // data being hashed
    return sha256.convert(bytes).hashCode;
  }

  Future<List<int>> events() async {
    // Get a reference to the database
    final Database db = await getDatabase();
    if(db == null) return null;

    // Query the table for All The Courses.
    final List<Map<String, dynamic>> maps = await db.query('Favorites');

    // Convert the List<Map<String, dynamic> into a List<CalendarItem>.
    return List.generate(maps.length, (i) {
      return maps[i]['key'];
    }
    );
  }

  Future<bool> isFavorite(CalendarItem c) async {
    // Get a reference to the database
    final Database db = await getDatabase();
    if (db == null) return null;

    final List<Map> favoriteEvent = await db.rawQuery(
        'SELECT * FROM Favorites WHERE key=?', [getHashCode(c)]);
    return favoriteEvent.isNotEmpty;
  }

  Future<void> addFavoriteEvent(CalendarItem c) async {
    final Map map = Map<String, dynamic>();
    map['key'] = getHashCode(c);
    await insertInDatabase('Favorites', map, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavoriteEvent(CalendarItem c) async {
     // Get a reference to the database
    final Database db = await getDatabase();
    if (db == null) return null;

    await db.rawQuery('DELETE FROM Favorites WHERE key=?', [getHashCode(c)]);
  }
}