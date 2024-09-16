import 'dart:developer';

import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/models/event_info_model.dart';
import 'package:Remindify/models/schedule_time_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseServices {
  DatabaseServices._constructor();

  static final DatabaseServices instance = DatabaseServices._constructor();
  static Database? db;
  static const _mainTableName = 'birthday_reminder_table';
  static const _nameColumnName = 'name';
  static const _inBuildIdColumnName = 'in_build_id';
  static const _friendNoteColumnName = 'friend_note';
  static const _lastModified = 'last_modified';
  static const _imageColumnName = 'image';
  static const _idColumnName = 'id';
  static const _phoneColumnName = 'phone';
  static const _labelColumnName = 'label';
  static const _customLabelColumnName = 'custom_label';
  static const _eventsTableName = 'events';
  static const _dateColumnName = 'date';
  static const _eventIdColumnName = 'event_id';
  static const _contactIdColumnName = 'contact_id';
  static const _scheduledTimeTableName = 'scheduled_time';
  static const _scheduledTimeIdColumnName = 'scheduled_time_id';
  static const _daysBeforeColumnName = 'days_before';
  static const _timesColumnName = 'time';

  /// crete database
  Future<Database> _createDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, 'birthday_reminder_v1.db');

    final database = openDatabase(
      databasePath,
      version: 2,
      onCreate: (db, version) async {
        /// my contact model
        await db.execute('''
        CREATE TABLE $_mainTableName(
        $_idColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_nameColumnName TEXT NOT NULL,
        $_lastModified TEXT,
        $_inBuildIdColumnName TEXT,
        $_friendNoteColumnName TEXT,
        $_phoneColumnName TEXT,
        $_imageColumnName LONGBLOB
        )
        ''');

        /// event model
        await db.execute('''
        CREATE TABLE $_eventsTableName(
        $_eventIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_dateColumnName TEXT,
        $_labelColumnName TEXT,
        $_customLabelColumnName TEXT,
        $_contactIdColumnName INTEGER,
        FOREIGN KEY($_contactIdColumnName) REFERENCES $_mainTableName($_idColumnName) ON DELETE CASCADE      
        )
        ''');

        /// scheduled times
        await db.execute('''
        CREATE TABLE $_scheduledTimeTableName(
        $_scheduledTimeIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
        $_daysBeforeColumnName INTEGER NOT NULL DEFAULT 0,
        $_timesColumnName TEXT NOT NULL
        )
        ''');
      },
    );
    return database;
  }

  /// get database
  Future<Database> getDatabase() async {
    if (db != null) return db!;
    db = await _createDatabase();
    return db!;
  }

  /// add contact
  Future<void> addContact(ContactInfoModel contactModel) async {
    try {
      final db = await getDatabase();

      await db.transaction((txn) async {
        final contactId =
            await txn.insert(_mainTableName, contactModel.toJson());
        for (final event in contactModel.events) {
          await txn.insert(_eventsTableName, {
            ...event.toJson(),
            _contactIdColumnName: contactId,
          });
        }
      });
      log("contact added successfully!");
    } catch (e) {
      throw Exception("error while adding contact: $e");
    }
  }

  /// add scheduled time
  Future<void> addScheduledTime(ScheduleTimeModel scheduledTime) async {
    try {
      final db = await getDatabase();

      await db.transaction((txn) async {
        await txn.insert(_scheduledTimeTableName, scheduledTime.toMap());
      });
      log("Scheduled time added successfully!");
    } catch (e) {
      throw Exception("error while adding scheduled time: $e");
    }
  }

  /// get scheduled time list
  Future<List<ScheduleTimeModel>> getScheduledTimeList() async {
    try {
      List<ScheduleTimeModel> scheduleTimeList = [];
      final db = await getDatabase();

      await db.transaction((txn) async {
        final scheduledTimeMaps = await txn.query(_scheduledTimeTableName);
        scheduleTimeList =
            scheduledTimeMaps.map((e) => ScheduleTimeModel.fromMap(e)).toList();
      });
      log("Scheduled time list fetched successfully!");
      return scheduleTimeList;
    } catch (e) {
      throw Exception("error while getting scheduled time list: $e");
    }
  }

  /// get scheduled time list
  Future<void> updateScheduledTime(ScheduleTimeModel scheduledTimeModel) async {
    try {
      final db = await getDatabase();
      await db.transaction((txn) async {
        /// updating scheduled time model
        await txn.update(
          _scheduledTimeTableName,
          scheduledTimeModel.toMap(),
          where: '$_scheduledTimeIdColumnName = ?',
          whereArgs: [scheduledTimeModel.id],
        );
      });
      log("Scheduled time model updated successfully!");
    } catch (e) {
      throw Exception("error while updating scheduled time model: $e");
    }
  }

  /// delete scheduled time
  Future<void> deleteScheduledTime(ScheduleTimeModel scheduledTimeModel) async {
    try {
      final db = await getDatabase();

      /// deleting scheduled time
      await db.transaction((txn) async {
        await txn.delete(
          _scheduledTimeTableName,
          where: '$_scheduledTimeIdColumnName = ?',
          whereArgs: [scheduledTimeModel.id],
        );
      });
      log("Scheduled time deleted successfully!");
    } catch (e) {
      throw Exception("error while deleting scheduled time: $e");
    }
  }

  /// update contact
  Future<void> updateContact(ContactInfoModel contactModel) async {
    try {
      final db = await getDatabase();

      await db.transaction((txn) async {
        /// updating contact table
        await txn.update(
          _mainTableName,
          contactModel.toJson(),
          where: '$_idColumnName = ?',
          whereArgs: [contactModel.id],
        );

        ///deleting first existing event table
        if (contactModel.events.isNotEmpty) {
          await txn.delete(
            _eventsTableName,
            whereArgs: [contactModel.id],
            where: '$_contactIdColumnName = ?',
          );
        }
        for (final event in contactModel.events) {
          await txn.insert(_eventsTableName, {
            ...event.toJson(),
            _contactIdColumnName: contactModel.id,
          });
        }
      });
      log("contact updated successfully!");
    } catch (e) {
      throw Exception("error while updating contact: $e");
    }
  }

  /// delete contact
  Future<void> deleteContact(ContactInfoModel contactModel) async {
    final db = await getDatabase();
    try {
      await db.transaction((txn) async {
        /// Delete related events
        await txn.delete(
          _eventsTableName,
          where: '$_contactIdColumnName = ?',
          whereArgs: [contactModel.id],
        );

        /// Delete the contact
        await txn.delete(
          _mainTableName,
          where: '$_idColumnName = ?',
          whereArgs: [contactModel.id],
        );
      });

      log("Contact deleted successfully!");
    } catch (e) {
      log("Error while deleting contact with id ${contactModel.id}: $e");
      throw Exception(
          "Error while deleting contact with id ${contactModel.id}: $e");
    }
  }

  /// get all contact list
  Future<List<ContactInfoModel>> getContactInfoListFromLocalDb() async {
    try {
      final db = await getDatabase();

      /// querying contacts from local db
      final contactMaps = await db.query(_mainTableName);

      List<ContactInfoModel> contacts = [];

      for (final contactMap in contactMaps) {
        /// querying events from local db
        final eventMaps = await db.query(
          _eventsTableName,
          where: '$_contactIdColumnName = ?',
          whereArgs: [contactMap[_idColumnName]],
        );
        final events = eventMaps.map((e) => EventInfoModel.fromMap(e)).toList();

        /// inserting events in contact here
        final contact = ContactInfoModel.fromMap({
          ...contactMap,
          'events': events,
        });
        contacts.add(contact);
      }
      log("contacts from db(${contactMaps.length}) fetched successfully!");
      return contacts;
    } catch (e) {
      throw Exception("error while fetching contacts from local DB: $e");
    }
  }

  /// get contact from id
  Future<ContactInfoModel> getContactInfoFromDbById(int id) async {
    try {
      final db = await getDatabase();

      /// querying contacts from local db
      final contactMaps = await db
          .query(_mainTableName, where: '$_idColumnName = ?', whereArgs: [id]);
      return contactMaps.map((e) => ContactInfoModel.fromMap(e)).first;
    } catch (e) {
      throw Exception("error while fetching contacts from local DB by ID: $e");
    }
  }
}
