import 'package:http/http.dart';
import 'package:uni_calendar/controller/networking/network_router.dart';
import 'package:uni_calendar/controller/parsers/parser_feup_calendar.dart';
import 'package:uni_calendar/model/app_state.dart';
import 'package:redux/redux.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';
import 'package:uni_calendar/model/entities/session.dart';

import 'feup_calendar_fetcher.dart';

class FeupCalendarFetcherHtml extends FeupCalendarFetcher {
  @override
  Future<List<CalendarItem>> getFeupCalendar(Store<AppState> store) async {
    final String baseUrl = NetworkRouter.getBaseUrlFromSession(
        store.state.content['session']) +
        'web_base.gera_pagina?p_pagina=página%20estática%20genérica%20106';
    final Session session = store.state.content['session'];
    final Future<Response> response = NetworkRouter.getWithCookies(baseUrl,
        {}, session);
    final List<CalendarItem> restaurants =
    await response.then((response) => getFeupCalendarFromHTML(response));

    return restaurants;
  }
}
