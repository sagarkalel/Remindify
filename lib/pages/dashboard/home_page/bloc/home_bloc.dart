import 'dart:developer';

import 'package:Remindify/models/filter_model.dart';
import 'package:Remindify/models/my_contact_model.dart';
import 'package:Remindify/models/schedule_time_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../settings/bloc/setting_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final List<MyContactModel> originalContactListFromDb = [];
  final List<MyContactModel> filterAppliedContactList = [];
  final List<MyContactModel> inSearchContactList = [];

  FilterModel appliedFilter = filterList.first;
  bool isSearchVisible = false;
  bool showPermissionWidget = false;
  final searchController = TextEditingController();
  final searchFocusNode = FocusNode();

  HomeBloc() : super(HomeContactsLoadingState()) {
    /// get all local contacts
    on<FetchMyContactsFromDb>(_fetchContactEventsFromDb);
    on<AddFilter>(_changeFilter);
    on<ClearFilter>(_clearFilter);
    on<ScheduleEvents>(_scheduleEvents);
    on<GetSearch>(_getSearch);
    on<SearchEvents>(_searchEvents);
    on<ClearSearch>(_clearSearch);
    on<CheckPermissions>(_checkPermissionWidget);
  }

  /// toggle search
  Future<void> _getSearch(GetSearch event, Emitter<HomeState> emit) async {
    searchFocusNode.requestFocus();
    isSearchVisible = true;
    inSearchContactList.clear();
    inSearchContactList.addAll(List.from(filterAppliedContactList));
    emit(HomeContactsLoadedState(List.from(inSearchContactList)));
    emit(SearchToggleState(isSearchVisible));
  }

  Future<void> _clearSearch(ClearSearch event, Emitter<HomeState> emit) async {
    if (!event.clearOnly) {
      isSearchVisible = false;
      searchFocusNode.unfocus();
      emit(SearchToggleState(isSearchVisible));
    }
    inSearchContactList.clear();
    inSearchContactList.addAll(List.from(filterAppliedContactList));
    emit(HomeContactsLoadedState(List.from(inSearchContactList)));
    searchController.clear();
  }

  Future<void> _searchEvents(
      SearchEvents event, Emitter<HomeState> emit) async {
    final searchResult = filterAppliedContactList.where(
      (element) {
        return element.name
                .toLowerCase()
                .contains(searchController.text.trim().toLowerCase()) ||
            (element.friendNote
                    ?.toLowerCase()
                    .contains(searchController.text.trim()) ??
                false) ||
            (element.phone
                    ?.toLowerCase()
                    .contains(searchController.text.trim().toLowerCase()) ??
                false);
      },
    ).toList();

    if (searchController.text.trim().isEmpty) {
      inSearchContactList.clear();
      inSearchContactList.addAll(List.from(filterAppliedContactList));
    }
    log("search result length: ${searchResult.length}");
    inSearchContactList.clear();
    inSearchContactList.addAll(searchResult);
    emit(HomeContactsLoadedState(List.from(inSearchContactList)));
  }

  Future<void> _scheduleEvents(
      ScheduleEvents event, Emitter<HomeState> emit) async {
    try {
      for (final element in originalContactListFromDb) {
        await AppServices.scheduleEventNotifications(
          events: element.events,
          name: element.name,
          contactId: element.id,
          times: event.times,
        );
      }
    } catch (e) {
      log("Error while scheduling events: $e");
      emit(EventsSchedulingError("Error while scheduling events: $e"));
    }
  }

  /// fetch contact-events from db
  Future<void> _fetchContactEventsFromDb(
      FetchMyContactsFromDb event, Emitter<HomeState> emit) async {
    try {
      emit(HomeContactsLoadingState());
      final myLocalContacts =
          await DatabaseServices.instance.getMyContactListFromLocalDb();
      originalContactListFromDb.clear();
      originalContactListFromDb.addAll(myLocalContacts);

      /// if applied any filter earlier it will sort list accordingly here
      final sortedList = await _applyFilterLogic();
      filterAppliedContactList.clear();
      filterAppliedContactList.addAll(sortedList);
      final scheduledTimes = AppServices.navigatorKey.currentContext
              ?.read<SettingBloc>()
              .scheduledTimes ??
          [];
      if (event.scheduleEvents) {
        add(ScheduleEvents(scheduledTimes));
      }
      emit(HomeContactsLoadedState(List.from(filterAppliedContactList)));
    } catch (e) {
      log("Error while adding Event: $e");
      emit(HomeContactsErrorState(e.toString()));
    }
  }

  /// change filter
  Future<void> _changeFilter(AddFilter event, Emitter<HomeState> emit) async {
    appliedFilter = event.filterModel;

    /// apply filter logic
    final sortedList = await _applyFilterLogic();
    filterAppliedContactList.clear();
    filterAppliedContactList.addAll(sortedList);

    /// emit states and update main list
    emit(FilterChangedState(appliedFilter));
    emit(HomeContactsLoadedState(List.from(filterAppliedContactList)));
  }

  /// clear filter
  Future<void> _clearFilter(ClearFilter event, Emitter<HomeState> emit) async {
    appliedFilter = filterList.first;

    /// apply filter logic
    final sortedList = await _applyFilterLogic();
    filterAppliedContactList.clear();
    filterAppliedContactList.addAll(sortedList);

    /// emit states and update main list
    emit(FilterChangedState(appliedFilter));
    emit(HomeContactsLoadedState(List.from(filterAppliedContactList)));
  }

  /// apply filter logic
  Future<List<MyContactModel>> _applyFilterLogic() async {
    List<MyContactModel> sortedList = originalContactListFromDb;
    switch (appliedFilter.value) {
      case 'default':
        final withEvents =
            sortedList.where((element) => element.events.isNotEmpty).toList();
        final withoutEvents =
            sortedList.where((element) => element.events.isEmpty).toList();

        /// sort only with events
        withEvents.sort((a, b) {
          final aDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(a.events) ?? 0;
          final bDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(b.events) ?? 0;
          return aDaysLeft.compareTo(bDaysLeft);
        });

        /// final sorted list
        sortedList = withEvents + withoutEvents;
        log("Default sorted by event date!");
        break;
      case 'most_recent':
        sortedList.sort((a, b) => b.id.compareTo(a.id));
        log("Most recent sorted!");
        break;
      case 'oldest_first':
        sortedList.sort((a, b) => a.id.compareTo(b.id));
        log("Oldest first sorted!");
        break;
      case 'alphabetical_order':
        sortedList.sort((a, b) => a.name.compareTo(b.name));
        log("alphabetical_order sorted!");
        break;
      case 'with_event':
        sortedList =
            sortedList.where((element) => element.events.isNotEmpty).toList();

        /// sort only with events
        sortedList.sort((a, b) {
          final aDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(a.events) ?? 0;
          final bDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(b.events) ?? 0;
          return aDaysLeft.compareTo(bDaysLeft);
        });
        log("With event sorted!");
        break;
      case 'without_event':
        sortedList =
            sortedList.where((element) => element.events.isEmpty).toList();
        log("Without event sorted!");
        break;
      case 'birthday_events':
        sortedList = sortedList.where((element) {
          for (final event in element.events) {
            if (event.label == EventLabel.birthday) return true;
          }
          return false;
        }).toList();
        sortedList.sort((a, b) {
          final aDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(a.events) ?? 0;
          final bDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(b.events) ?? 0;
          return aDaysLeft.compareTo(bDaysLeft);
        });
        log("Birthday event sorted!");
        break;
      case 'anniversary_events':
        sortedList = sortedList.where((element) {
          for (final event in element.events) {
            if (event.label == EventLabel.anniversary) return true;
          }
          return false;
        }).toList();
        sortedList.sort((a, b) {
          final aDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(a.events) ?? 0;
          final bDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(b.events) ?? 0;
          return aDaysLeft.compareTo(bDaysLeft);
        });
        log("Anniversary event sorted!");
        break;
      case 'other_events':
        sortedList = sortedList.where((element) {
          for (final event in element.events) {
            if (event.label == EventLabel.other) return true;
          }
          return false;
        }).toList();
        sortedList.sort((a, b) {
          final aDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(a.events) ?? 0;
          final bDaysLeft =
              AppServices.getDaysUntilNextDateFromClosureEvent(b.events) ?? 0;
          return aDaysLeft.compareTo(bDaysLeft);
        });
        log("Other event sorted!");
        break;
      default:
        break;
    }
    return sortedList;
  }

  Future<void> _checkPermissionWidget(
      CheckPermissions event, Emitter<HomeState> emit) async {
    final notificationPermission = await Permission.notification.isGranted;
    final exactAlarmPermission = await Permission.scheduleExactAlarm.isGranted;
    showPermissionWidget = !notificationPermission || !exactAlarmPermission;
    log("this is permission variable state: $showPermissionWidget");
    emit(NotificationPermissionCheckState(notificationPermission));
    emit(ExactAlarmPermissionCheckState(exactAlarmPermission));
  }
}
