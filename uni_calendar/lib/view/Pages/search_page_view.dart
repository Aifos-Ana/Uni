import 'dart:collection';
import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:uni_calendar/controller/local_storage/app_events_database.dart';
import 'package:uni_calendar/controller/local_storage/app_test_events_database.dart';
import 'package:uni_calendar/controller/notificationService.dart';
import 'package:uni_calendar/model/app_state.dart';
import 'package:uni_calendar/model/entities/exam.dart';
import 'package:uni_calendar/model/entities/calendar_item.dart';
import 'package:uni_calendar/view/Pages/general_page_view.dart';
import 'package:uni_calendar/view/Pages/calendar_page_view.dart';
import '../../controller/local_storage/app_favorites_database.dart';
import '../Widgets/page_transition.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => SearchPageViewState();
}

int getHashCode(DateTime key){
  return key.day * 1000000 + key.month * 10000 + key.year;
}

class SearchPageViewState extends GeneralPageViewState{
  List<CalendarItem> selectedEvents = [];
  LinkedHashMap<DateTime, List<CalendarItem>> events
  = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
  List<int> lastFetchedSize = [-1, -1, -1];

  String searchString = "";
  TextEditingController searchController = TextEditingController();
  List<String> filter = [];
  bool onExame = false;
  bool onFeupCalendar = false;
  bool onGeneral = false;
  bool onFavorite = false;

  void setEvents(LinkedHashMap<DateTime, List<CalendarItem>> events){
    this.events = events;
  }

  List<CalendarItem> getSelectedEvents(){
    return selectedEvents;
  }

  void updateEvents(List<CalendarItem> feupcalendar, List<Exam> exams,
    List<CalendarItem> sigarraEvents) async{
    if(feupcalendar == null || exams == null || sigarraEvents == null) {
      return;
    }

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

    setState(() {
      Search(searchString,filter);
    });
  }

  List<CalendarItem> getEventsForDay(DateTime date){
    return events[date] ?? [];
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

  void Search(String texto, List<String> filter, {bool testing = false}) async{
    List<CalendarItem> aux = [];
    AppFavoritesDatabase db = AppFavoritesDatabase();
    if(texto.toLowerCase().compareTo("")==0){
      if(filter.isEmpty || (filter.length == 1 && filter[0] == "Favorite")){ //ve os eventos todos sem pesquisa
        events.forEach((key, value) {for(var val in value){
          aux.add(val);
        }});
      }
      else{ //adiciona se só tiver filtro
        events.forEach((key, value) {for(var val in value){
          for(var fill in filter){
            if(val.type.value.toString().toLowerCase().compareTo(fill.toLowerCase())==0){
              aux.add(val);
            }
          }
        }});
      }
    }
    else{
      if(filter.isEmpty){ //ve os eventos com a string igual

        events.forEach((key, value) {for(var val in value){
          if(val.name.toLowerCase().contains(texto.toLowerCase())==true){
            aux.add(val);
          }
        }});
      }
      else{
        events.forEach((key, value) {for(var val in value){ //ve os eventos com string e filter;
          if(val.name.toLowerCase().contains(texto.toLowerCase())==true){
            for(var fill in filter) {
              if (val.type.value.toString().toLowerCase().compareTo(
                  fill.toLowerCase()) == 0) {
                aux.add(val);
              }
            }
          }
        }});
      }
    }
    if (filter.contains("Favorite")) {
      List<CalendarItem> finalResult = [];

      await Future.forEach(aux, (element) async{
        element.favorite = await db.isFavorite(element);
        if(element.favorite){
          finalResult.add(element);
        }
      });

      setState(() {
        selectedEvents.clear();
        selectedEvents = finalResult;
      });
    }
    else {
      selectedEvents.clear();
      selectedEvents = aux;
    }

    if(!testing){
      selectedEvents.forEach((element) async {
        element.favorite = await db.isFavorite(element);
      });
    }
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

  Widget eventsList(){
    if (selectedEvents.isEmpty) {
      return Text(
        "Sem eventos",
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
                                      e.type.value.toString(),
                                      style: Theme.of(context).textTheme.headline3,
                                    ),
                                    Text(
                                      e.name,
                                      style: Theme.of(context).textTheme.headline6,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      e.date.day.toString()+"/"+e.date.month.toString()+"/"+e.date.year.toString(),
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

  Widget searchBar() {
    return Container(
        padding: EdgeInsets.only(right: 10, left: 20),
        child:
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [IconButton(
                onPressed: () {
                  Navigator.pop(context,MaterialPageRoute(builder: (context) => const CalendarPageView()),);
                },
                icon: const Icon(Icons.arrow_back),
                color: Color.fromARGB(255, 0x75, 0x17, 0x1e),),
                Text('Search Event', style: Theme
                  .of(context)
                  .textTheme
                  .headline5,),]
            ),
            Row(
                children: [
                  IconButton(
                    key: Key('btn_search'),
                    onPressed: () {
                      openDialog();
                    },
                    icon: const Icon(Icons.search),
                    color: Color.fromARGB(255, 0x75, 0x17, 0x1e),),
                  IconButton(
                    key: Key('btn_filter'),
                    onPressed: () {
                    if(!filter.contains("Exame")){
                      onExame = false;
                    }
                    if(!filter.contains("FeupCalendar")){
                      onFeupCalendar = false;
                    }
                    if(!filter.contains("General")){
                      onGeneral = false;
                    }
                    if(!filter.contains("Favorite")){
                      onFavorite = false;
                    }
                    openFilter();
                  },
                    icon: const Icon(Icons.settings),
                    color: Color.fromARGB(255, 0x75, 0x17, 0x1e),),
                ]
            ),
          ],
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
            searchBar(),
            eventsList()
          ],
        );
      },
    );
  }
  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        key: Key('input_search'),
        title: Text('Search Event',style: TextStyle(color: Color.fromARGB(255, 0x75, 0x17, 0x1e)),),
        content: TextField(
          controller: searchController,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(hintText:"Ex: ES",

            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0x75, 0x17, 0x1e) ),
            ), ),
        ),
          actions:[
            TextButton(
              child: Text('Search'),
              key: Key('perform_search'),
              onPressed:(){
                setState(() {
                  searchString = searchController.text;
                  Search(searchString, filter);
                  Navigator.of(context, rootNavigator: true).pop('dialog');
                });
              }
            )
          ]
      ),
  );

  Future <void> openFilter() async{
    return  showDialog(
    context: context,
    builder: (context){
      return StatefulBuilder(builder: (context, setInnerState){
        return AlertDialog(
            title: Text('Filter Event', style: TextStyle(color: Color.fromARGB(255, 0x75, 0x17, 0x1e))),
            content: Container(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children:[
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                children:[
                  Text("Exame"),
                  Checkbox(
                      value: onExame,
                      key: Key('filter_exams'),
                      onChanged:(checked){
                    setInnerState((){
                      onExame=checked;
                    });
                  })
                ],
              ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      children:[
                        Text("FeupCalendar"),
                        Checkbox(
                            value: onFeupCalendar,
                            key: Key('filter_feupCalendar'),
                            onChanged:(checked){
                          setInnerState((){
                            onFeupCalendar=checked;
                          });
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      children:[
                        Text("General"),
                        Checkbox(
                            value: onGeneral,
                            key: Key('filter_general'),
                            onChanged:(checked){
                          setInnerState((){
                            onGeneral=checked;
                          });
                        })
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween ,
                      children:[
                        Text("Favorite"),
                        Checkbox(value: onFavorite, onChanged:(checked){
                          setInnerState((){
                            onFavorite=checked;
                          });
                        })
                      ],
                    ),

                  ]
              ),
            ),
            actions:[
              TextButton(
                  child: Text('Filter'),
                  key: Key('perform_filter'),
                  onPressed:(){
                      if(onExame==true){
                        if(!filter.contains("Exame")){
                          filter.add("Exame");
                        }
                      }else{
                        filter.remove("Exame");
                      }
                      if(onGeneral==true){
                        if(!filter.contains("General")) {
                          filter.add("General");
                        }
                      }else{
                        filter.remove("General");
                      }
                      if(onFeupCalendar==true){
                        if(!filter.contains("FeupCalendar")) {
                          filter.add("FeupCalendar");
                        }
                      }else{
                        filter.remove("FeupCalendar");
                      }
                      if(onFavorite==true){
                        if(!filter.contains("Favorite")) {
                          filter.add("Favorite");
                        }
                      }else{
                        filter.remove("Favorite");
                      }
                    setState((){
                        Search(searchString,filter);
                        Navigator.of(context, rootNavigator: true).pop('dialog');
                        return;
                    });
                  }
              )
            ]
        );
      });
    });
  }
}