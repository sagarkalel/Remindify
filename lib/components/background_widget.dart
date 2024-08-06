import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            kColorScheme.inversePrimary.withOpacity(0.25),
            Colors.greenAccent.withOpacity(0.10),
          ],
          end: Alignment.topCenter,
          begin: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
