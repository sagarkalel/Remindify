import 'package:flutter/material.dart';

class Gap extends StatelessWidget {
  const Gap(this.val, {super.key});

  final double val;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: val, width: val);
  }
}

double getScreenX(BuildContext context) => MediaQuery.of(context).size.width;

double getScreenY(BuildContext context) => MediaQuery.of(context).size.height;

ColorScheme kColorScheme =
// ColorScheme.fromSeed(seedColor: const Color(0xff00ff8c));
    ColorScheme.fromSeed(seedColor: const Color(0xff3e3c50));
