part of 'import_native_contact_bloc.dart';

sealed class ImportNativeContactState extends Equatable {
  const ImportNativeContactState();

  @override
  List<Object> get props => [];
}

/// import Native contacts page states
final class NativeContactErrorState extends ImportNativeContactState {
  final String errorMessage;

  const NativeContactErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class NativeContactLoadedState extends ImportNativeContactState {
  final List<Contact> nativeContacts;
  final List<String> selectedContacts;

  const NativeContactLoadedState(this.nativeContacts, this.selectedContacts);

  @override
  List<Object> get props => [nativeContacts, selectedContacts];
}

final class NativeContactLoadingState extends ImportNativeContactState {}

final class NativeContactStoringState extends ImportNativeContactState {}

final class NativeContactStoredInDbState extends ImportNativeContactState {}

final class NativeContactsPermissionRequestState
    extends ImportNativeContactState {
  final bool isPermissionGranted;

  const NativeContactsPermissionRequestState(this.isPermissionGranted);

  @override
  List<Object> get props => [isPermissionGranted];
}
