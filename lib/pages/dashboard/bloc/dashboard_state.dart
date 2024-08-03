part of 'dashboard_bloc.dart';

sealed class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

final class DashboardInitial extends DashboardState {}

final class NavBarIndexChanged extends DashboardState {
  final int currentIndex;

  const NavBarIndexChanged(this.currentIndex);

  @override
  List<Object> get props => [currentIndex];
}
