part of 'add_my_contact_bloc.dart';

sealed class AddMyContactState extends Equatable {
  const AddMyContactState();

  @override
  List<Object> get props => [];
}

/// add event page states
final class AddMyContactLoadingState extends AddMyContactState {}

final class AddMyContactInitialState extends AddMyContactState {}

final class AddMyContactAddedState extends AddMyContactState {}

final class AddMyContactUpdatedState extends AddMyContactState {}

final class AddMyContactErrorState extends AddMyContactState {
  final String errorMessage;

  const AddMyContactErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
