import 'dart:developer';

import 'package:Remindify/models/my_contact_model.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'add_my_contact_event.dart';
part 'add_my_contact_state.dart';

class AddMyContactBloc extends Bloc<AddMyContactEvent, AddMyContactState> {
  final MyContactModel? editMyContactData;

  AddMyContactBloc({this.editMyContactData})
      : super(AddMyContactInitialState()) {
    /// add contact-event to database
    on<AddMyContactToDbEvent>(_addEventToDatabase);
    on<UpdateMyContactFromDbEvent>(_updateEventInDatabase);
  }

  /// update contact-event in database
  Future<void> _updateEventInDatabase(
      UpdateMyContactFromDbEvent event, Emitter<AddMyContactState> emit) async {
    try {
      emit(AddMyContactLoadingState());
      if (event.myContactModel != editMyContactData) {
        await event.databaseServices.updateContact(event.myContactModel);
      } else {
        log("Ohh!, There was no change to update.");
      }

      /// TODO: added custom delay temp, will have to remove later
      await Future.delayed(const Duration(seconds: 1));
      emit(AddMyContactUpdatedState());
    } catch (e) {
      log("Error while updating Event: $e");
      emit(AddMyContactErrorState(e.toString()));
    }
  }

  /// add contact-event to database
  static Future<void> _addEventToDatabase(
      AddMyContactToDbEvent event, Emitter<AddMyContactState> emit) async {
    try {
      emit(AddMyContactLoadingState());
      await event.databaseServices.addContact(event.myContactModel);

      /// TODO: added custom delay temp, will have to remove later
      await Future.delayed(const Duration(seconds: 1));
      emit(AddMyContactAddedState());
    } catch (e) {
      log("Error while adding Event: $e");
      emit(AddMyContactErrorState(e.toString()));
    }
  }
}
