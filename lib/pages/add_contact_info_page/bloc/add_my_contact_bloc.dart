import 'dart:developer';

import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

part 'add_my_contact_event.dart';
part 'add_my_contact_state.dart';

class AddContactInfoBloc
    extends Bloc<AddContactInfoEvent, AddContactInfoState> {
  final ContactInfoModel? editContactInfoData;
  List<Contact> nativeContacts = [];

  AddContactInfoBloc({this.editContactInfoData})
      : super(AddContactInfoInitialState()) {
    /// add contact info model to database
    on<AddContactInfoToDb>(_addContactInfoToDb);
    on<UpdateContactInfoFromDb>(_updateContactInfoInDb);
    on<GetNativeContacts>(_getNativeContacts);
  }

  /// get native contacts
  Future<void> _getNativeContacts(
      GetNativeContacts event, Emitter<AddContactInfoState> emit) async {
    emit(NativeContactsLoading());
    try {
      final contacts = await FlutterContacts.getContacts(
        withPhoto: true,
        withThumbnail: true,
        withProperties: true,
      );
      nativeContacts = contacts;
      emit(NativeContactsLoaded(contacts));
    } catch (e) {
      log("Error while loading native contacts: $e");
      emit(NativeContactsFailure(e.toString()));
    }
  }

  /// update contact-event in database
  Future<void> _updateContactInfoInDb(
      UpdateContactInfoFromDb event, Emitter<AddContactInfoState> emit) async {
    try {
      emit(AddContactInfoLoadingState());
      if (event.contactInfoModel != editContactInfoData) {
        await event.databaseServices.updateContact(event.contactInfoModel);
      } else {
        log("Ohh!, There was no change to update.");
      }

      /// TODO: added custom delay temp, will have to remove later
      await Future.delayed(const Duration(seconds: 1));
      emit(ContactInfoUpdatedState());
    } catch (e) {
      log("Error while updating Event: $e");
      emit(ContactInfoErrorState(e.toString()));
    }
  }

  /// add contact-event to database
  static Future<void> _addContactInfoToDb(
      AddContactInfoToDb event, Emitter<AddContactInfoState> emit) async {
    try {
      emit(AddContactInfoLoadingState());
      await event.databaseServices.addContact(event.contactInfoModel);

      /// TODO: added custom delay temp, will have to remove later
      await Future.delayed(const Duration(seconds: 1));
      emit(ContactInfoAddedState());
    } catch (e) {
      log("Error while adding Event: $e");
      emit(ContactInfoErrorState(e.toString()));
    }
  }
}
