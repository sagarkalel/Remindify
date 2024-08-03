import 'dart:developer';

import 'package:birthday_reminder/models/schedule_time_model.dart';
import 'package:birthday_reminder/services/app_services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationServices {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future init() async {
    try {
      await _configureLocalTimeZone();

      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      final DarwinInitializationSettings initializationSettingsIos =
          DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) {},
      );

      final InitializationSettings initializationSettings =
          InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIos,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (details) async {
          String? payload = details.payload;
          if (payload == null) return;
          await AppServices.handleNotificationTap(payload);
        },
      );
    } catch (e) {
      log("Error in init method of notification services: $e");
    }
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final timeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZone));
  }

  static Future<bool> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    return await Permission.notification.isGranted;
  }

  static Future<bool> requestExactAlarmPermission() async {
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }

    return await Permission.scheduleExactAlarm.isGranted;
  }

  /// Shows a simple notification
  static Future<void> showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final permissionGranted = await requestNotificationPermission();
      if (!permissionGranted) {
        log('Notification permission not granted');
        return;
      }

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'simple_channel_id',
        'simple_channel_name',
        channelDescription: 'simple_description',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        notificationDetails,
        payload: payload,
      );

      log('Simple notification shown');
    } catch (e) {
      log('Error showing simple notification: $e');
    }
  }

  /// Shows periodic notifications after each specific interval
  static Future<void> showPeriodicNotifications({
    required String title,
    required String body,
    required String payload,
  }) async {
    try {
      final permissionGranted = await requestNotificationPermission();
      if (!permissionGranted) {
        log('Notification permission not granted');
        return;
      }

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        'periodic_channel_id',
        'periodic_channel_name',
        channelDescription: 'periodic_description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails,
      );

      await _flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        title,
        body,
        RepeatInterval.everyMinute,
        notificationDetails,
      );

      log('Periodic notification scheduled');
    } catch (e) {
      log('Error showing periodic notification: $e');
    }
  }

  /// Schedules a notification for a specific date and time, repeating yearly
  static Future<void> scheduleYearlyNotification({
    required String title,
    required String body,
    required String payload,
    required DateTime birthDate,
    required int eventId,
    required int contactId,
    required ScheduleTimeModel scheduleTimeModel,
  }) async {
    try {
      final notificationPermission = await requestNotificationPermission();
      final exactAlarmPermission = await requestExactAlarmPermission();
      final parts = scheduleTimeModel.time.split(':');
      final notificationHour = int.parse(parts.first);
      final notificationMinute = int.parse(parts.last);
      final notificationDay = birthDate.day - scheduleTimeModel.daysBefore;

      if (!notificationPermission || !exactAlarmPermission) {
        log('Notification permission not granted');
        return;
      }

      final now = tz.TZDateTime.now(tz.local);
      final nextBirthday = tz.TZDateTime(
        tz.local,
        now.year,
        birthDate.month,
        notificationDay,
        notificationHour,
        notificationMinute,
      );

      final scheduledDate = nextBirthday.isBefore(now)
          ? tz.TZDateTime(
              tz.local,
              now.year + 1,
              birthDate.month,
              notificationDay,
              notificationHour,
              notificationMinute,
            )
          : nextBirthday;

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('yearly_channel_id', 'yearly_channel_name',
              channelDescription: 'yearly_description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker',
              styleInformation: BigTextStyleInformation(''));

      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await _flutterLocalNotificationsPlugin.zonedSchedule(
        eventId,
        title,
        body,
        scheduledDate,
        notificationDetails,
        // androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
      );
      log('Yearly notification scheduled, id: $eventId, and scheduled time: $scheduledDate');
    } catch (e) {
      log('Error scheduling yearly notification: $e');
    }
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
