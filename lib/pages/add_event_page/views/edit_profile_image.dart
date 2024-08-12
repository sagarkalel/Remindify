import 'dart:typed_data';

import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> editProfileImage(BuildContext context,
    [Uint8List? initialImage]) async {
  Uint8List? image = initialImage;
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    builder: (context) {
      return StatefulBuilder(builder: (context, updateState) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile photo",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton.filledTonal(
                  onPressed: () {
                    /// setting null value in image var when clicked on delete
                    image = null;
                    updateState(() {});
                    Navigator.pop(context, 'delete');
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ],
            ).padXXDefault,
            const Divider().padXXDefault,
            const YGap(8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    final imagePicker = ImagePicker();
                    final result =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    if (result != null) {
                      final imageInBytes =
                          await AppServices.getCompressedFile(result.path);
                      image = imageInBytes;
                      updateState(() {});
                    }
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.camera_alt),
                      Text(
                        "Camera",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () async {
                    final imagePicker = ImagePicker();
                    final result = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (result != null) {
                      final imageInBytes =
                          await AppServices.getCompressedFile(result.path);
                      image = imageInBytes;
                      updateState(() {});
                    }
                    if (context.mounted) {
                      Navigator.pop(context, image);
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.photo_library),
                      Text(
                        "Gallery",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const YGap(30),
          ],
        );
      });
    },
  );
}
