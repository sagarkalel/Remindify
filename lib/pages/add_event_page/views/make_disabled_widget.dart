import 'package:flutter/cupertino.dart';

import '../../../utils/global_constants.dart';

class MakeDisabledWidget extends StatelessWidget {
  const MakeDisabledWidget({
    super.key,
    required this.makeDisable,
    required this.child,
  });

  final bool makeDisable;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!makeDisable) return child;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: kColorScheme.surfaceTint.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }
}
