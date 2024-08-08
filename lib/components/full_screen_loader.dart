import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

class FullScreenLoader extends StatelessWidget {
  const FullScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kColorScheme.secondary.withOpacity(0.45),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
