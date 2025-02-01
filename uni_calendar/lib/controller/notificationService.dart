import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:uni_calendar/model/entities/calendar_item.dart';

class NotificationService{
  FlutterLocalNotificationsPlugin localNotificationsPlugin;
  AndroidNotificationDetails androidDetails;

  NotificationService(){
    localNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidDetails = const AndroidNotificationDetails(
        'event_notification',
        'Event Notification',
        importance: Importance.max,
        priority: Priority.max,
        enableVibration: true
    );

    setupNotifications();
  }

  setupNotifications(){
    setupTimeZone();
    initializeNotifications();
  }

  Future<void> setupTimeZone() async{
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  initializeNotifications() async{
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    await localNotificationsPlugin.initialize(
      const InitializationSettings(
        android: android
      )
    );
  }

  tz.TZDateTime getNotifcationDate(DateTime eventDate) {
    final tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, eventDate.year, eventDate.month, eventDate.day - 3);
    return scheduledDate;
  }

  scheduleNotification(CalendarItem event){
    localNotificationsPlugin.zonedSchedule(
        event.id,
        'Falta 3 dias para o evento',
        event.name,
        getNotifcationDate(event.date),
        //tz.TZDateTime.from(DateTime.now().add(Duration(seconds: 3)), tz.local), // For testing
        NotificationDetails(android: androidDetails),
        uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }

  removeNotificaion(CalendarItem event){
    localNotificationsPlugin.cancel(event.id);
  }
}