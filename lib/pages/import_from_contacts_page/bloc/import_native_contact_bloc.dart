import 'dart:developer';

import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'import_native_contact_event.dart';
part 'import_native_contact_state.dart';

class ImportNativeContactBloc
    extends Bloc<ImportContactEvent, ImportNativeContactState> {
  final List<String> selectedContacts = [];
  final List<Contact> allImportedContacts = [];
  static final List<ContactInfoModel> _allContactInfoListFromDatabase = [];

  ImportNativeContactBloc() : super(NativeContactLoadingState()) {
    /// import contacts from native device
    on<ImportNativeContacts>(_importNativeContacts);

    /// store Native Contacts in db
    on<StoreNativeContactsInDb>(_storeNativeContactsInDb);

    /// toggle contact while importing
    on<ToggleNativeContacts>(_toggleContactWhenTapped);

    /// on select all contacts
    on<SelectAllContacts>(_selectAllContacts);
  }

  /// select all contacts
  Future<void> _selectAllContacts(
      SelectAllContacts event, Emitter<ImportNativeContactState> emit) async {
    /// returning if any state is loading withing this page
    if (state is NativeContactLoadingState ||
        state is NativeContactStoringState) return;

    /// clearing at initially
    selectedContacts.clear();

    /// adding all imported contacts in [_selected] variable
    if (event.isSelected) {
      for (final element in allImportedContacts) {
        selectedContacts.add(element.id);
      }
    }
    emit(NativeContactLoadedState(
        List.from(allImportedContacts), List.from(selectedContacts)));
  }

  /// toggle contact when tapped while importing
  Future<void> _toggleContactWhenTapped(ToggleNativeContacts event,
      Emitter<ImportNativeContactState> emit) async {
    /// returning if any state is loading withing this page
    if (state is NativeContactLoadingState ||
        state is NativeContactStoringState) return;
    try {
      if (selectedContacts.contains(event.contactId)) {
        selectedContacts.remove(event.contactId);
        log("This contact.id is removed: ${event.contactId}");
      } else {
        selectedContacts.add(event.contactId);
        log("This contact.id is added: ${event.contactId}");
      }
      log("These are the selected contacts: ${selectedContacts.length}");
      emit(NativeContactLoadedState(
          List.from(allImportedContacts), List.from(selectedContacts)));
    } catch (e) {
      emit(NativeContactErrorState("Error while selecting contact: $e"));
    }
  }

  /// fetch contacts from local device
  Future<void> _importNativeContacts(ImportNativeContacts event,
      Emitter<ImportNativeContactState> emit) async {
    final isRequestGranted = await FlutterContacts.requestPermission();
    selectedContacts.clear();
    allImportedContacts.clear();
    _allContactInfoListFromDatabase.clear();
    emit(NativeContactsPermissionRequestState(isRequestGranted));

    try {
      if (isRequestGranted) {
        emit(NativeContactLoadingState());
        _allContactInfoListFromDatabase.addAll(
            await DatabaseServices.instance.getContactInfoListFromLocalDb());
        final nativeContacts = await FlutterContacts.getContacts(
          withPhoto: true,
          withThumbnail: true,
          withProperties: true,
        );

        /// contacts only which are not imported earlier
        final contactsOnlyWhichAreNotImportedEarlier =
            nativeContacts.where((contact) {
          return !_allContactInfoListFromDatabase
              .any((element) => element.inBuildId == contact.id);
        }).toList();

        /// contacts contains event
        final contactContainsEvent = contactsOnlyWhichAreNotImportedEarlier
            .where((element) => element.events.isNotEmpty);

        /// adding contacts contains event in [_selectedContacts] variable
        for (final element in contactContainsEvent) {
          selectedContacts.add(element.id);
        }

        /// storing loaded native contacts in local variable
        allImportedContacts.addAll(contactsOnlyWhichAreNotImportedEarlier);
        emit(NativeContactLoadedState(
            List.from(allImportedContacts), List.from(selectedContacts)));
      }
    } catch (e) {
      emit(
          NativeContactErrorState("Error while importing native contacts: $e"));
    }
  }

  /// store native contacts in local database if they are not already exist in local database
  Future<void> _storeNativeContactsInDb(StoreNativeContactsInDb event,
      Emitter<ImportNativeContactState> emit) async {
    /// returning if any state is loading withing this page
    if (state is NativeContactLoadingState ||
        state is NativeContactStoringState) return;

    emit(NativeContactStoringState());
    try {
      /// checking new contacts to add
      final newNativeContactIds = selectedContacts.where((element) {
        return !_allContactInfoListFromDatabase
            .any((i) => i.inBuildId == element);
      }).toList();

      /// new native contacts which has to import
      final newNativeContacts = allImportedContacts
          .where((element) => newNativeContactIds.contains(element.id))
          .toList();

      /// parsing native contacts and converting in local [ContactInfoModel]
      final parsedNewNativeContacts = newNativeContacts
          .map((e) => ContactInfoModel.fromNativeContact(e))
          .toList();

      for (final item in parsedNewNativeContacts) {
        await DatabaseServices.instance.addContact(item);
      }
      emit(NativeContactStoredInDbState());
    } catch (e) {
      emit(NativeContactErrorState("Error while storing contact: $e"));
    }
  }
}
