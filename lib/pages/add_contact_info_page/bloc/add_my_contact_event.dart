part of 'add_my_contact_bloc.dart';

sealed class AddContactInfoEvent extends Equatable {
  const AddContactInfoEvent();

  @override
  List<Object?> get props => [];
}

class AddContactInfoToDb extends AddContactInfoEvent {
  final DatabaseServices databaseServices;
  final ContactInfoModel contactInfoModel;

  const AddContactInfoToDb({
    required this.databaseServices,
    required this.contactInfoModel,
  });

  @override
  List<Object?> get props => [databaseServices, contactInfoModel];
}

class UpdateContactInfoFromDb extends AddContactInfoEvent {
  final DatabaseServices databaseServices;
  final ContactInfoModel contactInfoModel;

  const UpdateContactInfoFromDb({
    required this.databaseServices,
    required this.contactInfoModel,
  });

  @override
  List<Object?> get props => [databaseServices, contactInfoModel];
}

class GetNativeContacts extends AddContactInfoEvent {}
