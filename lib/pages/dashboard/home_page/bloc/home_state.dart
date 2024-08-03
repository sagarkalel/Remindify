part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeContactsLoadingState extends HomeState {}

final class FilterChangedState extends HomeState {
  final FilterModel appliedFilter;

  const FilterChangedState(this.appliedFilter);

  @override
  List<Object> get props => [appliedFilter];
}

final class HomeContactsLoadedState extends HomeState {
  final List<MyContactModel> myContacts;

  const HomeContactsLoadedState(this.myContacts);

  @override
  List<Object> get props => [myContacts];
}

final class HomeContactsErrorState extends HomeState {
  final String errorMessage;

  const HomeContactsErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class EventsSchedulingError extends HomeState {
  final String errorMessage;

  const EventsSchedulingError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class SearchToggleState extends HomeState {
  final bool isSearchVisible;

  const SearchToggleState(this.isSearchVisible);

  @override
  List<Object> get props => [isSearchVisible];
}
