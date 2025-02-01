import 'dart:convert';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:uni_calendar/view/Pages/calendar_page_view.dart';

enum CalendarEventType{
  Exame,
  General,
  FeupCalendar
}

extension CalendarEventTypeMap on CalendarEventType {
  static const valueMap = {
    CalendarEventType.Exame: 'Exame',
    CalendarEventType.General: 'General',
    CalendarEventType.FeupCalendar: 'FeupCalendar'
  };
  String get value => valueMap[this];

  static CalendarEventType fromString(String input) {
    final reverseValueMap = valueMap.map<String, CalendarEventType>((key, value) => MapEntry(value, key));

    final CalendarEventType output = reverseValueMap[input];
    if(output == null) {
      throw 'Invalid String Input' + input;
    }

    return output;
  }
}

int getHashCode(CalendarItem c) {
  final bytes = utf8.encode(c.name + c.date.toString()); // data being hashed
  return sha256.convert(bytes).hashCode;
}

Event createEvent(CalendarItem i) {
  final String title = i.type == 'Exame'
      ? i.name.substring(0, i.name.indexOf('-') - 1)
      : i.name;
  DateTime start, end;
  bool allDay = false;

  if(i.type == 'Exame'){
    final List<String> parts = i.name.split('-');

    final List<String> hourStart = parts[1].split(':');
    final int startHour = int.parse(hourStart[0]);
    final int startMin = int.parse(hourStart[1]);

    final List<String> hourEnd = parts[2].split(':');
    final int endHour = int.parse(hourEnd[0]);
    final int endMin = int.parse(hourEnd[1]);

    start = i.date.add(Duration(hours: startHour, minutes: startMin));
    end = i.date.add(Duration(hours: endHour, minutes: endMin));
  } else{
    start = i.date;
    end = i.date.add(Duration(days: 1));
    allDay = true;
  }

  return Event(
      title: title,
      startDate: start,
      endDate: end,
      allDay: allDay
  );
}

class CalendarItem {
  int id;
  String name;
  DateTime date;
  bool favorite;
  CalendarEventType type;

  CalendarItem({
    @required this.name,
    @required this.date,
    @required this.type,
    this.favorite = false}){
    this.id = getHashCode(this);
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'date': DateFormat('yyyy-MM-dd').format(date),
    'type': type.value
  };

  static CalendarItem fromJson(Map<String, dynamic> json) => CalendarItem(
    name: json['name'],
    date: DateTime.parse(json['date']),
    type: CalendarEventTypeMap.fromString(json['type'])
  );

  @override
  bool operator == (Object other){
    return other is CalendarItem
        && name == other.name
        && date == other.date;
  }

  @override
  int get hashCode => getHashCode(this);
}