import 'package:Remindify/components/background_widget.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkNavigation();
  }

  Future<void> _checkNavigation() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, "/dashboard", (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundWidget(),
        Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const Gap(kToolbarHeight),
              Image.asset(
                'assets/images/remindify_app_icon.jpg',
                height: kToolbarHeight * 3,
                width: kToolbarHeight * 3,
              ),
              const Gap(24),
              const LinearProgressIndicator(),
            ],
          ).padXX(kToolbarHeight),
        ),
      ],
    );
  }
}
