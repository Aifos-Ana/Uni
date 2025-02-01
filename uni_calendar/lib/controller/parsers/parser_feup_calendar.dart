import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';

var months = {
  'janeiro': 1,
  'fevereiro': 2,
  'março': 3,
  'abril': 4,
  'maio': 5,
  'junho': 6,
  'julho': 7,
  'agosto': 8,
  'setembro': 9,
  'outubro': 10,
  'novembro': 11,
  'dezembro': 12,
  'Janeiro': 1,
  'Fevereiro': 2,
  'Março': 3,
  'Abril': 4,
  'Maio': 5,
  'Junho': 6,
  'Julho': 7,
  'Agosto': 8,
  'Setembro': 9,
  'Outubro': 10,
  'Novembro': 11,
  'Dezembro': 12
};

Future<List<CalendarItem>> getFeupCalendarFromHTML(Response response) async {
  final document = parse(response.body);

  final List<Element> tables = document.querySelectorAll('table');
  if(tables.length < 2) return null;

  final List<CalendarItem> result = [];

  for(int i = 0; i < 2; i++){
    final List<Element> rows = tables[i].querySelectorAll('tr');
    rows.forEach((element) {
      final List<Element> fields = element.querySelectorAll('td');

      final String _name = fields[0].text;
      String date = fields[1].text;
      date = date.replaceAll(' de ', ' ');

      if(date != 'TBD' && date != 'N.A.' && !date.contains('até')) {
        final List<String> dateFields = date.split(' ');

        switch (dateFields.length) {
          case 3:
            result.add(CalendarItem(
                name: _name,
                date: DateTime(
                    int.parse(dateFields[2]),
                    months[dateFields[1]],
                    int.parse(dateFields[0])),
                type: CalendarEventType.FeupCalendar
            ));
            break;
          case 5:
            result.add(CalendarItem(
                name: _name + ' - Início',
                date: DateTime(
                    int.parse(dateFields[4]),
                    months[dateFields[3]],
                    int.parse(dateFields[0])),
                type: CalendarEventType.FeupCalendar
            ));
            result.add(CalendarItem(
                name: _name + ' - Fim',
                date: DateTime(
                    int.parse(dateFields[4]),
                    months[dateFields[3]],
                    int.parse(dateFields[2])),
                type: CalendarEventType.FeupCalendar
            ));
            break;
          case 6:
            result.add(CalendarItem(
                name: _name + ' - Início',
                date: DateTime(
                    int.parse(dateFields[5]),
                    months[dateFields[1]],
                    int.parse(dateFields[0])),
                type: CalendarEventType.FeupCalendar
            ));
            result.add(CalendarItem(
                name: _name + ' - Fim',
                date: DateTime(
                    int.parse(dateFields[5]),
                    months[dateFields[4]],
                    int.parse(dateFields[3])),
                type: CalendarEventType.FeupCalendar
            ));
            break;
          case 7:
            result.add(CalendarItem(
                name: _name + ' - Início',
                date: DateTime(
                    int.parse(dateFields[2]),
                    months[dateFields[1]],
                    int.parse(dateFields[0])),
                type: CalendarEventType.FeupCalendar
            ));
            result.add(CalendarItem(
                name: _name + ' - Fim',
                date: DateTime(
                    int.parse(dateFields[6]),
                    months[dateFields[5]],
                    int.parse(dateFields[4])),
                type: CalendarEventType.FeupCalendar
            ));
            break;
        }
      }
    });
  }

  return result;
}
