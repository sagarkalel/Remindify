import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:Remindify/models/event_info_model.dart';
import 'package:Remindify/models/schedule_time_model.dart';
import 'package:Remindify/pages/view_event_page/view_event_page.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';

import 'notification_services.dart';

class AppServices {
  /// global navigator key
  static final navigatorKey = GlobalKey<NavigatorState>();

  /// get UInt8List image format from string
  static Uint8List getImageData(String stringImage) =>
      base64Decode(stringImage);

  /// Months list
  static List<String> months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  ];

  /// date format
  static DateFormat dateFormat = DateFormat("dd MMM");

  /// get display name from contact name model
  static String getName(Name name) {
    String prefix = name.prefix.isEmpty ? '' : '${name.prefix.trim()} ';
    String first = name.first.isEmpty ? '' : '${name.first.trim()} ';
    String middle = name.middle.isEmpty ? '' : '${name.middle.trim()} ';
    String last = name.last.trim();
    return prefix + first + middle + last;
  }

  /// get display phone from contact/phone model
  static String? getPhoneNumber(List<Phone> phones) {
    if (phones.isNotEmpty) {
      return phones.first.normalizedNumber.isNotEmpty
          ? phones.first.normalizedNumber
          : phones.first.number;
    }
    return null;
  }

  /// get list of event model from phone contact events
  static List<EventInfoModel> getEvents(List<Event> events) {
    if (events.isEmpty) return [];
    return events.map((e) {
      return EventInfoModel(
          date: getFormattedDateFromEvent(e),
          label: e.label,
          customLabel: e.customLabel);
    }).toList();
  }

  /// get formatted date from EventModel ['$day $month $year']
  static String getFormattedDateFromEvent(Event event) {
    final day = event.day > 31 ? 31 : event.day.toString().padLeft(2, '0');
    final month = months[(event.month > 12 ? 12 : event.month) - 1];
    final year = event.year?.toString().padLeft(4, '0') ?? '';
    return '$day $month $year';
  }

  /// Get image in string form from UInt8List
  static String? getImageInStringFromUInt8List(Uint8List? uint8ListImage) {
    if (uint8ListImage == null) return null;
    return base64Encode(uint8ListImage);
  }

  static final eventLabelToString = {
    EventLabel.anniversary: 'Anniversary',
    EventLabel.birthday: 'Birthday',
    EventLabel.other: 'Other',
    EventLabel.custom: 'Custom',
  };

  static final stringToEventLabel = {
    'Anniversary': EventLabel.anniversary,
    'Birthday': EventLabel.birthday,
    'Other': EventLabel.other,
    'Custom': EventLabel.custom,
  };

  static void showSnackBar(context, String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 800),
      showCloseIcon: true,
      margin: EdgeInsets.fromLTRB(15, 5, 15, getScreenY(context) * 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: kColorScheme.secondary,
    ));
  }

  /// get compressed file
  static Future<Uint8List?> getCompressedFile(String path) async {
    final result =
        await FlutterImageCompress.compressWithFile(path, quality: 40);
    return result;
  }

  /// get closure event and if it is empty then return null
  static EventInfoModel? getClosureEventFromEvents(
      List<EventInfoModel> events) {
    if (events.isEmpty) return null;
    final DateTime now = DateTime.now();

    /// Check if any event matches today's date
    for (var event in events) {
      DateTime eventDate = dateFormat.parse(event.date);
      if (eventDate.month == now.month && eventDate.day == now.day) {
        return event;
      }
    }

    /// Convert event dates to the next occurrence
    List<DateTime> adjustedDates = events.map((event) {
      DateTime eventDate = dateFormat.parse(event.date);
      DateTime adjustedDate =
          DateTime(now.year, eventDate.month, eventDate.day);

      /// If the adjusted date is before today, moving it to the next year
      if (adjustedDate.isBefore(now)) {
        adjustedDate = DateTime(now.year + 1, eventDate.month, eventDate.day);
      }
      return adjustedDate;
    }).toList();

    /// Pair adjusted dates with events
    List<MapEntry<DateTime, EventInfoModel>> pairedList = [];
    for (int i = 0; i < events.length; i++) {
      pairedList.add(MapEntry(adjustedDates[i], events[i]));
    }

    /// Sort the paired list by the adjusted date
    pairedList.sort((a, b) => a.key.compareTo(b.key));

    /// Get the event with the closest upcoming date
    EventInfoModel closestEvent = pairedList.first.value;

    return closestEvent;
  }

  /// get closure date occurrence
  static String getClosureEventDateWithLabel(List<EventInfoModel> events) {
    /// Get the event with the closest upcoming date
    EventInfoModel? closestEvent = getClosureEventFromEvents(events);
    if (closestEvent == null) return 'No event found!';
    DateTime closestDate = dateFormat.parse(closestEvent.date);
    return '${dateFormat.format(closestDate)} (${(eventLabelToString[closestEvent.label] == eventLabelToString[EventLabel.custom]) ? closestEvent.customLabel : (eventLabelToString[closestEvent.label] ?? '')})';
  }

  /// get days left until next date
  static int? getDaysUntilNextDate(String date) {
    if (date.isEmpty) return null;
    DateTime inputDate = dateFormat.parse(date);
    DateTime today = DateTime.now();
    DateTime nextOccurrence =
        DateTime(today.year, inputDate.month, inputDate.day);

    /// when [nextOccurrence] is today, returning 0 days left
    if (nextOccurrence.day == today.day &&
        nextOccurrence.month == today.month) {
      return 0;
    }

    /// when [nextOccurrence] was in past, setting next year [nextOccurrence}
    if (nextOccurrence.isBefore(today)) {
      nextOccurrence = DateTime(today.year + 1, inputDate.month, inputDate.day);
    }

    /// calculate difference between today and nextOccurrence
    Duration difference = nextOccurrence.difference(today);
    return (difference.inHours / 24).ceil();
  }

  /// get days left until next date from closure event
  static int? getDaysUntilNextDateFromClosureEvent(
      List<EventInfoModel> events) {
    EventInfoModel? closestEvent = getClosureEventFromEvents(events);

    /// if events are empty then return null
    if (closestEvent == null) return null;
    DateTime inputDate = dateFormat.parse(closestEvent.date);
    DateTime today = DateTime.now();
    DateTime nextOccurrence =
        DateTime(today.year, inputDate.month, inputDate.day);

    /// when [nextOccurrence] is today, returning 0 days left
    if (nextOccurrence.day == today.day &&
        nextOccurrence.month == today.month) {
      return 0;
    }

    /// when [nextOccurrence] was in past, setting next year [nextOccurrence}
    if (nextOccurrence.isBefore(today)) {
      nextOccurrence = DateTime(today.year + 1, inputDate.month, inputDate.day);
    }

    /// calculate difference between today and nextOccurrence
    Duration difference = nextOccurrence.difference(today);
    return (difference.inHours / 24).ceil();
  }

  /// schedule events
  static Future<void> scheduleEventNotifications({
    required List<EventInfoModel> events,
    required String name,
    required int contactId,
    required List<ScheduleTimeModel> times,
  }) async {
    if (events.isEmpty) return;

    /// firstly cancelling scheduled notification before scheduling
    /// because of multiple scheduled times
    // await NotificationServices.cancelAllNotifications();
    log("scheduled times length = ${times.length}");
    for (var event in events) {
      if (event.date.isEmpty) return;
      final eventDate = dateFormat.parse(event.date);

      for (final eachTime in times) {
        await NotificationServices.cancelNotification(event.eventId);
        final isToday = eventDate.day == eventDate.day - eachTime.daysBefore;
        await NotificationServices.scheduleYearlyNotification(
          title: generateNotificationTitle(
            event: event.label,
            name: name,
            isToday: isToday,
            customLabel: event.customLabel,
          ),
          body: generateNotificationBody(
            event: event.label,
            name: name,
            isToday: isToday,
            date: event.date,
          ),
          payload: '$contactId&&${event.eventId}',
          birthDate: eventDate,
          eventId: event.eventId,
          contactId: contactId,
          scheduleTimeModel: eachTime,
        );
      }
    }
  }

  /// generate notification title based on event
  static String generateNotificationTitle({
    required EventLabel event,
    required String name,
    required bool isToday,
    required String? customLabel,
  }) {
    switch (event) {
      case EventLabel.birthday:
        if (isToday) return 'Today it is $name\'s Birthday!';
        return 'Reminder for $name\'s Birthday!';
      case EventLabel.anniversary:
        if (isToday) return 'Today it is $name\'s Anniversary!';
        return 'Reminder for $name\'s Anniversary!';
      case EventLabel.other:
        return 'Reminder for ${eventLabelToString[event]}! 📅📌';
      case EventLabel.custom:
        return 'Reminder for $customLabel! 📅📌';
      default:
        return 'Reminder for ${eventLabelToString[event]}! 📅📌';
    }
  }

  /// generate notification body based on event
  static String generateNotificationBody({
    required EventLabel event,
    required String name,
    required bool isToday,
    required String date,
  }) {
    switch (event) {
      case EventLabel.birthday:
        if (isToday) {
          return '🎉🎂  Don\'t forget to wish them a happy birthday! 🎂🎉';
        } else {
          return '🎉🎂 $name\'s Birthday is on ${dateFormat.format(dateFormat.parse(date))}, Don\'t forget to wish them a happy birthday! 🎂🎉';
        }

      case EventLabel.anniversary:
        if (isToday) {
          return '💖💍 Remember to send your best wishes! 💍💖';
        } else {
          return '💖💍 $name\'s Anniversary is on ${dateFormat.format(dateFormat.parse(date))}, Remember to send your best wishes! 💍💖';
        }

      /// TODO: add proper body for custom label
      default:
        if (isToday) {
          return '🎈🎉 Don’t forget to celebrate with $name! 🎉🎈';
        } else {
          return '🎈🎉 Don’t forget to celebrate with $name on ${dateFormat.format(dateFormat.parse(date))}! 🎉🎈';
        }
    }
  }

  static Future<void> handleNotificationTap(String payload) async {
    log('Notification payload: $payload');
    try {
      final int contactId = int.parse(payload.split('&&').first);
      final contactInfo =
          await DatabaseServices.instance.getContactInfoFromDbById(contactId);

      /// navigating to view event page
      navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (context) => ViewEventPage(contactInfoModel: contactInfo),
      ));
    } catch (e) {
      log("Error while handling notification onTap: $e");
    }
  }
}
