import 'dart:developer';

import 'package:Remindify/models/schedule_time_model.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'setting_event.dart';
part 'setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  List<ScheduleTimeModel> scheduledTimes = [];
  final db = DatabaseServices.instance;

  SettingBloc() : super(SettingInitial()) {
    on<LoadScheduledTimes>(_loadScheduledTimes);
    on<AddScheduledTime>(_addScheduledTime);
    on<UpdateScheduledTime>(_updateScheduledTime);
    on<DeleteScheduledTime>(_deleteScheduledTime);
  }

  Future<void> _loadScheduledTimes(
      LoadScheduledTimes event, Emitter<SettingState> emit) async {
    emit(SettingScheduledTimesLoading());
    try {
      final times = await db.getScheduledTimeList();
      scheduledTimes = times;

      /// adding default one event if [times] is empty
      if (times.isEmpty) {
        const defaultTime = ScheduleTimeModel(daysBefore: 0, time: '00:00');
        await db.addScheduledTime(defaultTime);
        final times = await db.getScheduledTimeList();
        scheduledTimes = times;
      }
      log("Fetched length of scheduled times is: ${scheduledTimes.length}");
      emit(SettingScheduledTimesLoaded(List.of(scheduledTimes)));
    } catch (e) {
      emit(SettingGetScheduledTimesFailure(e.toString()));
      log(e.toString());
    }
  }

  Future<void> _addScheduledTime(
      AddScheduledTime event, Emitter<SettingState> emit) async {
    emit(SettingScheduledTimesLoading());
    try {
      if (event.daysBefore.isEmpty) {
        emit(const SettingSaveError('Please enter days'));
        return;
      } else if (scheduledTimes.any((e) =>
          (int.parse(event.daysBefore) == e.daysBefore &&
              event.time == e.time))) {
        emit(const SettingSaveError("This reminder is already exist!"));
        return;
      }
      ScheduleTimeModel scheduledTime = ScheduleTimeModel(
          daysBefore: int.parse(event.daysBefore), time: event.time);
      await db.addScheduledTime(scheduledTime);
      scheduledTimes.add(scheduledTime);
      emit(SettingSaved(List.of(scheduledTimes)));
    } catch (e) {
      emit(SettingSaveError(e.toString()));
      log(e.toString());
    }
  }

  Future<void> _updateScheduledTime(
      UpdateScheduledTime event, Emitter<SettingState> emit) async {
    emit(SettingScheduledTimesLoading());
    try {
      if (event.daysBefore.isEmpty) {
        emit(const SettingSaveError('Please enter days'));
        return;
      } else if (scheduledTimes.any((e) =>
          (int.parse(event.daysBefore) == e.daysBefore &&
              event.time == e.time))) {
        emit(const SettingSaveError("This reminder is already exist!"));
        return;
      }
      ScheduleTimeModel scheduledTime = ScheduleTimeModel(
          daysBefore: int.parse(event.daysBefore),
          time: event.time,
          id: event.id);
      await db.updateScheduledTime(scheduledTime);
      final times = await db.getScheduledTimeList();
      scheduledTimes = times;
      emit(SettingSaved(List.of(scheduledTimes)));
    } catch (e) {
      emit(SettingSaveError(e.toString()));
      log(e.toString());
    }
  }

  Future<void> _deleteScheduledTime(
      DeleteScheduledTime event, Emitter<SettingState> emit) async {
    emit(SettingScheduledTimesLoading());
    try {
      await db.deleteScheduledTime(event.scheduledTime);
      scheduledTimes.remove(event.scheduledTime);
      emit(SettingSaved(List.of(scheduledTimes)));
    } catch (e) {
      emit(SettingSaveError(e.toString()));
      log(e.toString());
    }
  }
}
