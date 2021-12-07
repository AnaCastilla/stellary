import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;


//Clase donde se gestiona las notificaciones
class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future showScheduledNotification({
    int id = 0,
    String? title,
    String? body,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
          id,
          title,
          body,
          _scheduleDialy(Time(21, 30, 0)),
          await notificationDetails(),
          androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },);

    if (initScheduled)  {
      tz.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('Europe/Paris'));
    }
  }

  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            importance: Importance.max),
        iOS: IOSNotificationDetails());
  }

  static tz.TZDateTime _scheduleDialy(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour, time.minute, time.second
    );

    return scheduledDate.isBefore(now)? scheduledDate.add(Duration(days: 1)) : scheduledDate;
  }
}
