import 'dart:developer';

import 'package:Remindify/pages/dashboard/home_page/home_page.dart';
import 'package:Remindify/pages/dashboard/settings/setting_screen.dart';
import 'package:Remindify/services/notification_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/dashboard_bloc.dart';
import 'home_page/bloc/home_bloc.dart';
import 'home_page/views/add_fab_button.dart';
import 'home_page/views/custom_nav_bar.dart';
import 'settings/bloc/setting_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    /// requesting permissions
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await NotificationServices.requestNotificationPermission();
      await NotificationServices.requestExactAlarmPermission();
      if (mounted) {
        context.read<HomeBloc>().add(CheckPermissions());
      }
    });
    WidgetsBinding.instance.scheduleFrameCallback(
      (timeStamp) {},
    );
  }

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
