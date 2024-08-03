import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  int currentNavBarIndex = 0;
  PageController pageController = PageController(initialPage: 0);

  DashboardBloc() : super(DashboardInitial()) {
    on<OnNavIndexChanged>((event, emit) {
      if (currentNavBarIndex == 0) {
        currentNavBarIndex = 1;
      } else {
        currentNavBarIndex = 0;
      }
      emit(NavBarIndexChanged(currentNavBarIndex));
      pageController.animateToPage(currentNavBarIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
    on<OnPageChanged>((event, emit) {
      currentNavBarIndex = event.index;
      emit(NavBarIndexChanged(currentNavBarIndex));
    });
  }
}
