import 'dart:developer';

import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactPermissionDeniedWidget extends StatelessWidget {
  const ContactPermissionDeniedWidget(
      {super.key, required this.onPermissionGranted});
  final VoidCallback onPermissionGranted;

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
            const Gap(16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enable Permission",
                    style: Theme.of(context).textTheme.titleLarge),
                const Text(
                    "Please enable Contact Permission to access contacts."),
              ],
            ).expand,
            const Gap(24),
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
    var status = await FlutterContacts.requestPermission();
    log("This is the status of contact permission: $status");
    if (status) {
      onPermissionGranted.call();
    } else {
      final result = await openAppSettings();
      if (!result && context.mounted) Navigator.pop(context);
    }
  }
}
