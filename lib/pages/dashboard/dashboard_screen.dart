import 'dart:developer';

import 'package:birthday_reminder/pages/dashboard/home_page/home_page.dart';
import 'package:birthday_reminder/pages/dashboard/settings/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/dashboard_bloc.dart';
import 'home_page/bloc/home_bloc.dart';
import 'home_page/views/add_fab_button.dart';
import 'home_page/views/custom_nav_bar.dart';
import 'settings/bloc/setting_bloc.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final bloc = context.read<DashboardBloc>();
            return BlocConsumer<SettingBloc, SettingState>(
              listener: (context, state) {
                /// when setting data loaded, schedule events based on times
                if (state is SettingScheduledTimesLoaded) {
                  log("setting is loaded in dashboard, now adding scheduled event");
                  context.read<HomeBloc>().add(ScheduleEvents(
                      context.read<SettingBloc>().scheduledTimes));
                }
              },
              builder: (context, state) {
                return PageView(
                  controller: bloc.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  // physics: const AlwaysScrollableScrollPhysics(),
                  onPageChanged: (index) => bloc.add(OnPageChanged(index)),
                  children: const [
                    HomePage(),
                    SettingScreen(),
                  ],
                );
              },
            );
          },
        ),
        const Align(alignment: Alignment.bottomCenter, child: CustomNavBar()),
        const AddFabButton(),
      ],
    ));
  }
}
