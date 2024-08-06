import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

class NotificationDisabledWidget extends StatelessWidget {
  const NotificationDisabledWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        height: 95,
        color: const Color(0xFFFFEABC),
        child: Row(
          children: [
            const Icon(Icons.notifications_off_outlined, size: 28),
            const XGap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enable Permissions",
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    "Enable notifications and exact alarms for timely reminders. Without these, reminders won't work."),
              ],
            ).expand,
            const XGap(24),
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      width: 1.5,
                      color: kColorScheme.primary,
                    )),
                child: Text("Enable now",
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(color: kColorScheme.primary)),
              ),
            ),
          ],
        ).padXXDefault,
      ),
    );
  }
}
