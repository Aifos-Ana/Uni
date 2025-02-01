import 'package:http/http.dart';
import 'package:uni_calendar/controller/networking/network_router.dart';
import 'package:uni_calendar/controller/parsers/parser_sigarra_events.dart';
import 'package:uni_calendar/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';
import 'package:uni_calendar/model/entities/session.dart';

import 'sigarra_events_fetcher.dart';

class SigarraEventsFetcherHtml extends SigarraEventsFetcher {
  @override
  Future<List<CalendarItem>> getSigarraEvents(Store<AppState> store) async {
    final int currentYear = DateTime.now().year;
    final List<CalendarItem> events = [];

    for(int month = 1; month <= 12; month++){
      for(int page = 0; page < 2; page++){
        final String baseURL = NetworkRouter.getBaseUrlFromSession(
            store.state.content['session']) +
            'noticias_geral.eventos?p_g_eventos='
            + page.toString() + '&p_ano=' +
            currentYear.toString() + '&p_mes=' + month.toString();

        final Session session = store.state.content['session'];
        final Future<Response> response = NetworkRouter.getWithCookies(baseURL,
            {}, session);
        final List<CalendarItem> fetchedEvents =
        await response.then((response) => getSigarraEventsFromHTML(response));

        events.addAll(fetchedEvents);
      }
    }

    return events;
  }
}
