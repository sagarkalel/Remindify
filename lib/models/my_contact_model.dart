import 'dart:typed_data';

import 'package:Remindify/models/event_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class MyContactModel {
  const MyContactModel({
    required this.name,
    required this.events,
    this.friendNote,
    this.image,
    this.inBuildId,
    this.phone,
    this.id = 0,
  });

  final String name;
  final int id;
  final String? friendNote, phone, inBuildId;
  final List<EventModel> events;
  final Uint8List? image;

  /// while extracting data from map
  factory MyContactModel.fromMap(Map<String, Object?> map) {
    return MyContactModel(
      name: map['name'] as String? ?? 'No name!',
      inBuildId: map['in_build_id'] as String? ?? 'No id found!',
      id: map['id'] as int? ?? 0,
      friendNote: map['friend_note'] as String?,
      image: map['image'] as Uint8List?,
      phone: map['phone'] as String?,
      events: map['events'] == null ? [] : (map['events'] as List<EventModel>),
    );
  }

  /// while extracting data from map
  factory MyContactModel.fromNativeContact(Contact contact) {
    return MyContactModel(
      name: AppServices.getName(contact.name),
      inBuildId: contact.id,
      friendNote: contact.notes.isEmpty ? null : contact.notes.first.note,
      image: contact.photoOrThumbnail,
      phone: AppServices.getPhoneNumber(contact.phones),
      events: AppServices.getEvents(contact.events),
    );
  }

  /// while storing data
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'friend_note': friendNote,
      'image': image,
      'in_build_id': inBuildId,
      'phone': phone,
    };
  }
}
