part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchMyContactsFromDb extends HomeEvent {
  /// default to false
  final bool scheduleEvents;

  const FetchMyContactsFromDb({this.scheduleEvents = false});

  @override
  List<Object?> get props => [scheduleEvents];
}

class ScheduleEvents extends HomeEvent {
  final List<ScheduleTimeModel> times;

  const ScheduleEvents(this.times);

  @override
  List<Object?> get props => [times];
}

class ClearFilter extends HomeEvent {}

class AddFilter extends HomeEvent {
  final FilterModel filterModel;

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
  // TODO: implement props
  List<Object?> get props => [clearOnly];
}
