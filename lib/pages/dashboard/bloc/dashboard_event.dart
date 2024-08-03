part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

class OnNavIndexChanged extends DashboardEvent {
  final int currentIndex;

  const OnNavIndexChanged(this.currentIndex);

  @override
  List<Object?> get props => [currentIndex];
}

class OnPageChanged extends DashboardEvent {
  final int index;

  const OnPageChanged(this.index);

  @override
  List<Object?> get props => [index];
}
