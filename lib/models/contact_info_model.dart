import 'dart:typed_data';

import 'package:Remindify/models/event_info_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ContactInfoModel {
  const ContactInfoModel({
    required this.name,
    required this.events,
    required this.lastModified,
    this.friendNote,
    this.image,
    this.inBuildId,
    this.phone,
    this.id = 0,
  });

  final String name;
  final int id;
  final String? friendNote, phone, inBuildId;
  final List<EventInfoModel> events;
  final Uint8List? image;
  final DateTime lastModified;

  /// while extracting data from map
  factory ContactInfoModel.fromMap(Map<String, Object?> map) {
    return ContactInfoModel(
      name: map['name'] as String? ?? 'No name!',
      inBuildId: map['in_build_id'] as String? ?? 'No id found!',
      id: map['id'] as int? ?? 0,
      friendNote: map['friend_note'] as String?,
      image: map['image'] as Uint8List?,
      phone: map['phone'] as String?,
      lastModified: DateTime.parse((map['last_modified'] as String?) ??
          DateTime.now().toIso8601String()),
      events:
          map['events'] == null ? [] : (map['events'] as List<EventInfoModel>),
    );
  }

  /// while extracting data from map
  factory ContactInfoModel.fromNativeContact(Contact contact) {
    return ContactInfoModel(
      name: AppServices.getName(contact.name),
      inBuildId: contact.id,
      friendNote:
          contact.notes.isEmpty ? null : contact.notes.first.note.trim(),
      image: contact.photoOrThumbnail,
      phone: AppServices.getPhoneNumber(contact.phones),
      events: AppServices.getEvents(contact.events),
      lastModified: DateTime.now(),
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
      'last_modified': lastModified.toIso8601String(),
    };
  }
}
