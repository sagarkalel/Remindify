import 'dart:typed_data';

import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

Future<void> viewFullScreenImage(BuildContext context, Uint8List image) async {
  showGeneralDialog(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) {
      return Container(
        decoration: BoxDecoration(color: kColorScheme.primary.withOpacity(0.2)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: getScreenY(context) * .75,
                  minWidth: getScreenX(context),
                ),
                child: Image.memory(
                  image,
                  fit: BoxFit.fitWidth,
                )),
            const YGap(50),
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(50),
                onTap: () => Navigator.pop(context),
                child: CircleAvatar(
                  maxRadius: 50,
                  backgroundColor:
                      Theme.of(context).canvasColor.withOpacity(0.5),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [Icon(Icons.close, size: 36), Text("Close")],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      );
    },
  );
}
