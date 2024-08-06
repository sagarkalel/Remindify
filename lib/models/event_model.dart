import 'package:Remindify/services/app_services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class EventModel {
  EventModel({
    required this.date,
    this.label = EventLabel.birthday,
    this.customLabel,
    this.eventId = 0,
  });

  final int eventId;
  String date;

  /// Label (default [EventLabel.custom]).
  EventLabel label;

  /// Custom label, if [label] is [EventLabel.custom].
  final String? customLabel;

  factory EventModel.fromMap(Map<String, Object?> map) {
    return EventModel(
      label: AppServices.stringToEventLabel[map['label'] as String? ?? ''] ??
          EventLabel.custom,
      customLabel: map['custom_label'] as String?,
      date: map['date'] as String? ?? "No Date found!",
      eventId: map['event_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': AppServices.eventLabelToString[label],
      'date': date,
      'custom_label': customLabel,
    };
  }
}
