import 'package:Remindify/pages/dashboard/bloc/dashboard_bloc.dart';
import 'package:Remindify/pages/dashboard/dashboard_screen.dart';
import 'package:Remindify/pages/dashboard/home_page/bloc/home_bloc.dart';
import 'package:Remindify/pages/dashboard/settings/bloc/setting_bloc.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'services/notification_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingBloc()..add(LoadScheduledTimes()),
        ),
        BlocProvider(
          create: (context) => HomeBloc()..add(const FetchMyContactsFromDb()),
        ),
        BlocProvider(create: (context) => DashboardBloc()),
      ],
      child: MaterialApp(
          title: 'Event reminder app',
          navigatorKey: AppServices.navigatorKey,
          initialRoute: '/dashboard',
          routes: {"/dashboard": (context) => const DashboardScreen()},
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(useMaterial3: true).copyWith(
            colorScheme: kColorScheme,
            appBarTheme: const AppBarTheme().copyWith(
              backgroundColor: kColorScheme.inversePrimary,
              elevation: 4,
              shadowColor: kColorScheme.primary,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: kColorScheme.surfaceTint,
                foregroundColor: kColorScheme.onInverseSurface,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                textStyle:
                    const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              ),
            ),
            iconTheme: const IconThemeData().copyWith(
              color: Theme.of(context).primaryColor,
            ),
          )),
    );
  }
}
