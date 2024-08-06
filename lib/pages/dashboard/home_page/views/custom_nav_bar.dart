import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/dashboard_bloc.dart';

class CustomNavBar extends StatefulWidget {
  const CustomNavBar({super.key});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<CustomNavBar> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: NavBarCustomClipper(),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.greenAccent, kColorScheme.inversePrimary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
              blurRadius: 8,
              offset: const Offset(-4, 4),
            ),
          ],
        ),
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            final bloc = context.read<DashboardBloc>();
            final currentIndex = bloc.currentNavBarIndex;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: currentIndex == 0
                      ? null
                      : () => bloc.add(OnNavIndexChanged(currentIndex)),
                  style: ElevatedButton.styleFrom(
                    disabledForegroundColor: kColorScheme.primary,
                    foregroundColor: Theme.of(context).disabledColor,
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child: Icon(Icons.home, size: currentIndex == 1 ? 32 : 40),
                ).expand,
                const SizedBox(width: 65),
                ElevatedButton(
                  onPressed: currentIndex == 1
                      ? null
                      : () => bloc.add(OnNavIndexChanged(currentIndex)),
                  style: ElevatedButton.styleFrom(
                    disabledForegroundColor: kColorScheme.primary,
                    foregroundColor: Theme.of(context).disabledColor,
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                  ),
                  child:
                      Icon(Icons.settings, size: currentIndex == 0 ? 32 : 40),
                ).expand,
              ],
            );
          },
        ),
      ),
    );
  }
}

class NavBarCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double arcRadius = 45.0;

    path.lineTo(size.width / 2 - arcRadius - 10, 0);

    // Create a smooth transition to the arc
    path.quadraticBezierTo(
        size.width / 2 - arcRadius, 0, size.width / 2 - arcRadius + 10, 10);

    // Create a half-circle
    path.arcToPoint(
      Offset(size.width / 2 + arcRadius - 10, 10),
      radius: const Radius.circular(40),
      clockwise: false,
    );

    // Create a smooth transition from the arc
    path.quadraticBezierTo(
        size.width / 2 + arcRadius, 0, size.width / 2 + arcRadius + 10, 0);

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);

    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
