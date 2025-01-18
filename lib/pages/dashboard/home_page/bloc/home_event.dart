part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchContactsInfoFromDb extends HomeEvent {}

class ScheduleEvents extends HomeEvent {
  final List<ScheduleTimeModel> times;

  const ScheduleEvents(this.times);

  @override
  List<Object?> get props => [times];
}

class ClearFilter extends HomeEvent {}

class DeleteContact extends HomeEvent {
  final ContactInfoModel contactInfoModel;

  const DeleteContact(this.contactInfoModel);

  @override
  List<Object?> get props => [contactInfoModel];
}

class AddFilter extends HomeEvent {
  final FilterListModel filterModel;

  const AddFilter(this.filterModel);

  @override
  List<Object?> get props => [filterModel];
}

class GetSearch extends HomeEvent {}

class SearchEvents extends HomeEvent {}

class CheckPermissions extends HomeEvent {}

class ClearSearch extends HomeEvent {
  final bool clearOnly;

  const ClearSearch({this.clearOnly = false});

  @override
  List<Object?> get props => [clearOnly];
}

class AddItemToSelectedList extends HomeEvent {
  final ContactInfoModel item;

  const AddItemToSelectedList(this.item);

  @override
  List<Object?> get props => [item];
}

class RemoveItemFromSelectedList extends HomeEvent {
  final ContactInfoModel item;

  const RemoveItemFromSelectedList(this.item);

  @override
  List<Object?> get props => [item];
}

class DeleteSelectedContacts extends HomeEvent {}

class ToggleSelectedView extends HomeEvent {
  final bool enableSelectedView;

  const ToggleSelectedView({required this.enableSelectedView});

  @override
  List<Object?> get props => [enableSelectedView];
}
