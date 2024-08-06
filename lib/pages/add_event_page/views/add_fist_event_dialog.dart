import 'package:Remindify/models/event_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/event.dart';
import 'package:intl/intl.dart';

import '../../../utils/global_constants.dart';
import 'event_dropdown.dart';

Future<EventModel?> addFirstEventDialog(context,
    {EventLabel? initialEventLabel}) async {
  return showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      DateTime? selectedDate;
      EventLabel dropdownValue = initialEventLabel ?? EventLabel.birthday;
      return StatefulBuilder(
        builder: (context, changeState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(16),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            title: const Text("Add Event"),
            content: Row(
              children: [
                Container(
                  height: 48,
                  width: getScreenX(context) * .35,
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).hintColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const XGap(10),
                      Text(selectedDate == null
                          ? "Select date"
                          : DateFormat('MM/dd/yyyy').format(selectedDate!)),
                      const Spacer(),
                      IconButton(
                          onPressed: () async {
                            final result = await showDatePicker(
                              context: context,
                              firstDate: DateTime(1950),
                              lastDate: DateTime(DateTime.now().year + 10),
                              initialDate: selectedDate ?? DateTime.now(),
                            );

                            if (result != null) {
                              selectedDate = result;
                              changeState(() {});
                            }
                          },
                          icon: const Icon(Icons.add_card_outlined)),
                    ],
                  ),
                ),
                const XGap(10),
                EventDropdown(
                  value: dropdownValue,
                  onChanged: (value) {
                    dropdownValue = value ?? EventLabel.birthday;
                    changeState(() {});
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: selectedDate == null
                    ? null
                    : () {
                        final eventModel = EventModel(
                          label: dropdownValue,
                          date: AppServices.getFormattedDateFromEvent(Event(
                              month: selectedDate!.month,
                              day: selectedDate!.day,
                              year: selectedDate!.year)),
                        );
                        Navigator.pop(context, eventModel);
                      },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )),
                child: const Text("Add"),
              ),
            ],
          );
        },
      );
    },
  );
}
