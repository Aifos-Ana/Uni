import 'dart:collection';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uni_calendar/controller/local_storage/app_favorites_database.dart';
import 'package:uni_calendar/controller/local_storage/app_test_events_database.dart';
import 'package:uni_calendar/controller/notificationService.dart';
import 'package:uni_calendar/model/app_state.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';
import 'package:uni_calendar/model/entities/exam.dart';
import 'package:uni_calendar/view/Pages/general_page_view.dart';
import 'package:uni_calendar/view/Widgets/page_title.dart';
import 'package:uni_calendar/view/Pages/search_page_view.dart';

class CalendarPageView extends StatefulWidget{
  const CalendarPageView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => CalendarPageViewState();
}

int getHashCode(DateTime key){
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class CalendarPageViewState extends GeneralPageViewState{
  DateTime selectedDay;
  DateTime focusedDay = DateTime.now();

  List<CalendarItem> selectedEvents = [];
  LinkedHashMap<DateTime, List<CalendarItem>> events
    = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);

  List<int> lastFetchedSize = [-1, -1, -1];

  void updateEvents(List<CalendarItem> feupcalendar, List<Exam> exams,
      List<CalendarItem> sigarraEvents) async{

    // Nothing changed
    if(feupcalendar.length == lastFetchedSize[0]
    && exams.length == lastFetchedSize[1]
    && sigarraEvents.length == lastFetchedSize[2]){
      return;
    }

    lastFetchedSize[0] = feupcalendar.length;
    lastFetchedSize[1] = exams.length;
    lastFetchedSize[2] = sigarraEvents.length;

    final List<CalendarItem> allEvents =
      await AppTestEventsDatabase().events();

    if(feupcalendar != null) allEvents.addAll(feupcalendar);
    if(exams != null) allEvents.addAll(exams.map((e) => e.toCalendarItem()));
    if(sigarraEvents != null) allEvents.addAll(sigarraEvents);

    events.clear();

    for (var item in allEvents) {
      final List<CalendarItem> sameDay = getEventsForDay(item.date);
      if(sameDay.isEmpty){
        events[item.date] = [item];
      } else{
        sameDay.add(item);
      }
    }

    if(selectedDay == null) {
      onDaySelected(DateTime.now(), DateTime.now());
    }
  }

  List<CalendarItem> getEventsForDay(DateTime date){
    return events[date] ?? [];
  }

  void onDaySelected(DateTime selectedDay, DateTime focusedDay){
    setState(() {
      this.selectedDay = selectedDay;
      this.focusedDay = focusedDay;

      selectedEvents = getEventsForDay(selectedDay);

      final AppFavoritesDatabase db = AppFavoritesDatabase();
      selectedEvents.forEach((element) async {
        element.favorite = await db.isFavorite(element);
      });
    });
  }

  Color getEventColor(CalendarEventType type){
    switch(type){
      case CalendarEventType.Exame:
        return const Color.fromARGB(255, 205, 170, 9);
      case CalendarEventType.General:
        return const Color.fromARGB(255, 86, 141, 172);
      case CalendarEventType.FeupCalendar:
        return const Color.fromARGB(255, 190, 40, 40);
      default:
        return Colors.black;
    }
  }

  Widget calendar(){
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      child: TableCalendar(
        focusedDay: focusedDay,
        firstDay: DateTime(2021),
        lastDay: DateTime(2023),
        startingDayOfWeek: StartingDayOfWeek.monday,
        locale: 'pt_BR',
        key: Key('table_calendar'),

        eventLoader: getEventsForDay,
        onDaySelected: onDaySelected,
        selectedDayPredicate: (date) => isSameDay(selectedDay, date),

        onPageChanged: (_focusedDay) {
          focusedDay = _focusedDay;
        },

        calendarBuilders: CalendarBuilders(
          singleMarkerBuilder: (context, date, CalendarItem event){
            return Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: .2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: getEventColor(event.type),
                border: Border.all(
                  color: Theme.of(context).toggleableActiveColor,
                  width: .5
                )
              ),
            );
          }
        ),

        calendarStyle: CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Theme.of(context).focusColor,
            shape: BoxShape.circle
          ),
          todayTextStyle: Theme.of(context).textTheme.headline2 ?? const TextStyle(),

          selectedDecoration: BoxDecoration(
            color: Theme.of(context).toggleableActiveColor,
            shape: BoxShape.circle
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white
          )
        ),

        headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            leftChevronVisible: false,
            rightChevronVisible: false,
            headerPadding: const EdgeInsets.all(25.0),
            titleTextStyle: Theme.of(context).textTheme.headline3 ?? const TextStyle()
        ),
      ),
    );
  }

  Widget eventTitle() {
    return Container(
        padding: const EdgeInsets.fromLTRB(15, 20, 15, 15),
        child: Text(
          'Eventos',
          style: Theme.of(context).textTheme.headline3,
        )
    );
  }

  void onFavoriteClick(CalendarItem e){
    setState((){
      if (e.favorite) {
        e.favorite = false;
        AppFavoritesDatabase().removeFavoriteEvent(e);

        Provider.of<NotificationService>(
            context,
            listen: false
        ).removeNotificaion(e);
      }
      else {
        e.favorite = true;
        AppFavoritesDatabase().addFavoriteEvent(e);

        Provider.of<NotificationService>(
            context,
            listen: false
        ).scheduleNotification(e);
      }
    });
  }

  Widget eventsList() {
    if (selectedEvents.isEmpty) {
      return Text(
        'Sem eventos',
        style: Theme.of(context).textTheme.headline4,
      );
    }

    return Expanded(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
          children: selectedEvents.map(
              (CalendarItem e) => Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 5.0),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(0x1c, 0, 0, 0),
                      blurRadius: 7.0,
                      offset: Offset(0.0, 1.0)
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      Container(
                        width: 5,
                        height: 50,
                        decoration: BoxDecoration(
                          color: getEventColor(e.type)
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                e.type.value,
                                style: Theme.of(context).textTheme.headline3,
                              ),
                              Text(
                                e.name,
                                style: Theme.of(context).textTheme.headline6,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        padding: EdgeInsets.only(top: 5.0, bottom: 12.0),
                        alignment: Alignment.bottomRight,
                        icon: Icon(MdiIcons.calendarPlus, size: 25),
                        onPressed: () {
                          Add2Calendar.addEvent2Cal(createEvent(e));
                        },
                      ),
                      IconButton(
                          icon: Icon(Icons.star,
                              key: Key(
                                  (e.favorite ? '' : 'not_')
                                      + 'fav_btn_'
                                      + e.name),
                              color:(e.favorite)
                              ? Color.fromARGB(255, 0x75, 0x17, 0x1e)
                              : Color(0xff9A9A9A)),
                          onPressed: () => onFavoriteClick(e)
                      )
                    ],
                  )
                )
              )
          ).toList()
        )
    );
  }

  @override
  Widget getBody(BuildContext context){
    return StoreConnector<AppState, List<dynamic>>(
      converter: (store) {
        updateEvents(
          store.state.content['feupcalendar'],
          store.state.content['exams'],
          store.state.content['sigarraevents']
        );
        return null;
      },
      builder: (context, exams) {
        return Column(

          children: [
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[

              PageTitle(name: 'Calendário de Eventos'),
                IconButton(
                  key: Key('btn_go_to_search'),
                  onPressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (context) => const SearchPageView()),);
                  },
                  icon: const Icon(Icons.search),
                  color: Color.fromARGB(255, 0x75, 0x17, 0x1e),),
              ]
            ),
            calendar(),
            eventTitle(),
            eventsList()
        ],
        );
      },
    );
  }
}


