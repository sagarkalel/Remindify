part of 'setting_bloc.dart';

sealed class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

final class SettingInitial extends SettingState {}

class SettingScheduledTimesLoading extends SettingState {}

class SettingSaved extends SettingState {
  final List<ScheduleTimeModel> times;

  const SettingSaved(this.times);

  @override
  List<Object?> get props => [times];
}

class SettingGetScheduledTimesFailure extends SettingState {
  final String errorMsg;

  const SettingGetScheduledTimesFailure(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class SettingSaveError extends SettingState {
  final String errorMsg;

  const SettingSaveError(this.errorMsg);

  @override
  List<Object?> get props => [errorMsg];
}

class SettingScheduledTimesLoaded extends SettingState {
  final List<ScheduleTimeModel> times;

  const SettingScheduledTimesLoaded(this.times);

  @override
  List<Object?> get props => [times];
}
