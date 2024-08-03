import 'package:flutter/material.dart';

class XGap extends StatelessWidget {
  const XGap(this.x, {super.key});

  final double x;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: x);
  }
}

class YGap extends StatelessWidget {
  const YGap(this.y, {super.key});

  final double y;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: y);
  }
}

double getScreenX(BuildContext context) => MediaQuery.of(context).size.width;

double getScreenY(BuildContext context) => MediaQuery.of(context).size.height;

ColorScheme kColorScheme =
// ColorScheme.fromSeed(seedColor: const Color(0xff00ff8c));
    ColorScheme.fromSeed(seedColor: const Color(0xff3e3c50));
