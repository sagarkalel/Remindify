part of 'add_my_contact_bloc.dart';

sealed class AddMyContactEvent extends Equatable {
  const AddMyContactEvent();

  @override
  List<Object?> get props => [];
}

class AddMyContactToDbEvent extends AddMyContactEvent {
  final DatabaseServices databaseServices;
  final MyContactModel myContactModel;

  const AddMyContactToDbEvent({
    required this.databaseServices,
    required this.myContactModel,
  });

  @override
  List<Object?> get props => [databaseServices, myContactModel];
}

class UpdateMyContactFromDbEvent extends AddMyContactEvent {
  final DatabaseServices databaseServices;
  final MyContactModel myContactModel;

  const UpdateMyContactFromDbEvent({
    required this.databaseServices,
    required this.myContactModel,
  });

  @override
  List<Object?> get props => [databaseServices, myContactModel];
}
