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

Future<List<CalendarItem>> getSigarraEventsFromHTML(Response response) async {
  final document = parse(response.body);

  final List<Element> list = document.querySelectorAll('.topo ul li');
  if(list.isEmpty) return [];

  final List<CalendarItem> result = [];

  final int year =
  int.parse(
      document.querySelectorAll('#conteudoinner h1')[1].text.split(' ')[2]);

  list.forEach((element) {
    String date = element.querySelector('b').text;
    date = date.replaceAll('\n', '');
    final List<String> dateFields = date.split(' ');

    final String eName = element.querySelector('a').text;

    switch(dateFields.length){
      case 3:
        result.add(CalendarItem(
            name: eName,
            date: DateTime(
                year,
                months[dateFields[2]],
                int.parse(dateFields[0])),
            type: CalendarEventType.General));
        break;
      case 5:
        result.add(CalendarItem(
            name: eName + ' - Início',
            date: DateTime(
                year,
                months[dateFields[4]],
                int.parse(dateFields[0])),
            type: CalendarEventType.General));
        result.add(CalendarItem(
            name: eName + ' - Fim',
            date: DateTime(
                year,
                months[dateFields[4]],
                int.parse(dateFields[2])),
            type: CalendarEventType.General));
        break;
      case 7:
        result.add(CalendarItem(
            name: eName + ' - Início',
            date: DateTime(
                year,
                months[dateFields[2]],
                int.parse(dateFields[0])),
            type: CalendarEventType.General));
        result.add(CalendarItem(
            name: eName + ' - Fim',
            date: DateTime(
                year,
                months[dateFields[6]],
                int.parse(dateFields[4])),
            type: CalendarEventType.General));
        break;
      default:
        break;
    }
  });

  return result;
}
