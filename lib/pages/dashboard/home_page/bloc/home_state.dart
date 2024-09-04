part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

final class HomeContactsLoadingState extends HomeState {}

final class FilterChangedState extends HomeState {
  final FilterListModel appliedFilter;

  const FilterChangedState(this.appliedFilter);

  @override
  List<Object> get props => [appliedFilter];
}

final class HomeContactsLoadedState extends HomeState {
  final List<ContactInfoModel> contactInfoList;

  const HomeContactsLoadedState(this.contactInfoList);

  @override
  List<Object> get props => [contactInfoList];
}

final class HomeContactsErrorState extends HomeState {
  final String errorMessage;

  const HomeContactsErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class ContactDeleteFailure extends HomeState {
  final String errorMessage;

  const ContactDeleteFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

final class ContactDeletedSuccessfully extends HomeState {}

final class ContactDeleteLoading extends HomeState {}

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

final class NotificationPermissionCheckState extends HomeState {
  final bool isGranted;

  const NotificationPermissionCheckState(this.isGranted);

  @override
  List<Object> get props => [isGranted];
}

final class ExactAlarmPermissionCheckState extends HomeState {
  final bool isGranted;

  const ExactAlarmPermissionCheckState(this.isGranted);

  @override
  List<Object> get props => [isGranted];
}
