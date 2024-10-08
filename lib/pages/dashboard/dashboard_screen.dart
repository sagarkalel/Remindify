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

class _DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    /// requesting permissions
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await NotificationServices.requestNotificationPermission();
      await NotificationServices.requestExactAlarmPermission();
      if (mounted) {
        context.read<HomeBloc>().add(CheckPermissions());
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      log("AppLifecycle state resumed!");
      context.read<HomeBloc>().add(CheckPermissions());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, dashboardState) {
            final bloc = context.read<DashboardBloc>();
            return BlocBuilder<SettingBloc, SettingState>(
              builder: (context, state) {
                return PageView(
                  controller: bloc.pageController,
                  physics: const NeverScrollableScrollPhysics(),
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
