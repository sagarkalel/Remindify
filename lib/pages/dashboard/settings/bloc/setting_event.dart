part of 'setting_bloc.dart';

sealed class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadScheduledTimes extends SettingEvent {}

class AddScheduledTime extends SettingEvent {
  final String time, daysBefore;

  const AddScheduledTime({required this.daysBefore, required this.time});

  @override
  List<Object?> get props => [daysBefore, time];
}

class UpdateScheduledTime extends SettingEvent {
  final String time, daysBefore;
  final int id;

  const UpdateScheduledTime(
      {required this.daysBefore, required this.time, required this.id});

  @override
  List<Object?> get props => [daysBefore, time, id];
}

class DeleteScheduledTime extends SettingEvent {
  final ScheduleTimeModel scheduledTime;

  const DeleteScheduledTime(this.scheduledTime);

  @override
  List<Object?> get props => [scheduledTime];
}
