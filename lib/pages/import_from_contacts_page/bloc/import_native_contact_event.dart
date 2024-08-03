part of 'import_native_contact_bloc.dart';

abstract class ImportContactEvent extends Equatable {
  const ImportContactEvent();

  @override
  List<Object?> get props => [];
}

class StoreNativeContactsInDb extends ImportContactEvent {}

class ImportNativeContacts extends ImportContactEvent {}

class ToggleNativeContacts extends ImportContactEvent {
  final String contactId;

  const ToggleNativeContacts(this.contactId);

  @override
  List<Object?> get props => [contactId];
}

class SelectAllContacts extends ImportContactEvent {
  final bool isSelected;

  const SelectAllContacts(this.isSelected);

  @override
  List<Object?> get props => [isSelected];
}
