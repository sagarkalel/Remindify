part of 'add_my_contact_bloc.dart';

sealed class AddContactInfoState extends Equatable {
  const AddContactInfoState();

  @override
  List<Object> get props => [];
}

/// add event page states
final class AddContactInfoLoadingState extends AddContactInfoState {}

final class NativeContactsLoading extends AddContactInfoState {}

final class NativeContactsLoaded extends AddContactInfoState {
  final List<Contact> contacts;

  const NativeContactsLoaded(this.contacts);

  @override
  List<Object> get props => [contacts];
}

final class AddContactInfoInitialState extends AddContactInfoState {}

final class ContactInfoAddedState extends AddContactInfoState {}

final class ContactInfoUpdatedState extends AddContactInfoState {}

final class ContactInfoErrorState extends AddContactInfoState {
  final String errorMessage;

  const ContactInfoErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class NativeContactsFailure extends AddContactInfoState {
  final String errorMessage;

  const NativeContactsFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
