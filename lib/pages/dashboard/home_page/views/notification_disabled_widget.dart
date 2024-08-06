import 'dart:developer';

import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
                ///TODO: for exact alarm permission belows text
                // Text("Enable Permissions",
                // const Text(
                //     "Enable notifications and exact alarms for timely reminders. Without these, reminders won't work."),
                Text("Enable Permission",
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    "Enable notifications for timely reminders. Without this, reminders won't work."),
              ],
            ).expand,
            const XGap(24),
            InkWell(
              onTap: () => _requestForPermission(context),
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

  Future<void> _requestForPermission(BuildContext context) async {
    var status = await Permission.notification.status;
    log("This is the status of notification permission: $status");

    switch (status) {
      case PermissionStatus.granted:

        /// If permission is already granted, no further action is needed.
        return;

      case PermissionStatus.denied:

        /// Request permission if it is denied.
        status = await Permission.notification.request();
        break;

      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.restricted:

        /// Open app settings if permission is permanently denied or restricted.
        await openAppSettings();
        break;

      default:
        break;
    }
  }
}
