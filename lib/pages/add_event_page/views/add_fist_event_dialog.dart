import 'package:Remindify/components/app_textfield.dart';
import 'package:Remindify/models/event_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/properties/event.dart';
import 'package:intl/intl.dart';

import '../../../utils/global_constants.dart';
import 'event_dropdown.dart';

Future<EventModel?> addFirstEventDialog(context,
    {List<EventLabel>? initialEventLabelList}) async {
  return showAdaptiveDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      DateTime? selectedDate;

      /// assigning dropdownList
      List<String> finalEventLabelList = initialEventLabelList
              ?.map((e) => AppServices.eventLabelToString[e] ?? 'None')
              .toList() ??
          EventLabel.values
              .map((j) => AppServices.eventLabelToString[j] ?? 'None')
              .toList();

      /// setting initial value of dropdown
      String dropdownValue = finalEventLabelList.first;

      return StatefulBuilder(
        builder: (context, changeState) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(16),
            actionsPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            title: const Text("Add Event"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        border: Border.all(color: Theme.of(context).hintColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const XGap(8),
                          Text(
                            selectedDate == null
                                ? "Select date"
                                : DateFormat('MM/dd/yyyy')
                                    .format(selectedDate!),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
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
                    ).expand,
                    const XGap(8),
                    EventDropdown(
                      value: dropdownValue,
                      initialEventLabelList: finalEventLabelList,
                      onChanged: (value) async {
                        /// if value is not birthday, anniversary or other then assuming it is either custom or custom added
                        if (value !=
                                AppServices
                                    .eventLabelToString[EventLabel.birthday] &&
                            value !=
                                AppServices.eventLabelToString[
                                    EventLabel.anniversary] &&
                            value !=
                                AppServices
                                    .eventLabelToString[EventLabel.other]) {
                          /// passing initial value of textField as coming value if it is not custom
                          final result = await _showCustomLabelDialog(
                              context,
                              AppServices.eventLabelToString[
                                          EventLabel.custom] ==
                                      value
                                  ? null
                                  : value);
                          if (result != null) {
                            /// making first letter of word as capital and then adding
                            final labelToAdd =
                                result[0].toUpperCase() + result.substring(1);

                            /// firstly removing custom added value from event list
                            finalEventLabelList.removeWhere((e) {
                              return !(e ==
                                      AppServices.eventLabelToString[
                                          EventLabel.birthday] ||
                                  e ==
                                      AppServices.eventLabelToString[
                                          EventLabel.anniversary] ||
                                  e ==
                                      AppServices.eventLabelToString[
                                          EventLabel.other]);
                            });

                            finalEventLabelList.add(labelToAdd);
                            dropdownValue = labelToAdd;
                          }
                        }

                        /// else add value whichever coming
                        else {
                          dropdownValue = value ?? finalEventLabelList.first;
                        }
                        changeState(() {});
                      },
                    ).expand,
                  ],
                ),
                const YGap(8),
                Visibility(
                  visible: selectedDate == null,
                  child: Text(
                    "  Please select date!",
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(color: kColorScheme.error),
                  ),
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
                          label:
                              AppServices.stringToEventLabel[dropdownValue] ??
                                  EventLabel.custom,
                          customLabel:
                              AppServices.stringToEventLabel[dropdownValue] ==
                                      null
                                  ? dropdownValue
                                  : null,
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

Future<String?> _showCustomLabelDialog(BuildContext context,
    [String? initialVal]) async {
  return await showDialog(
    context: context,
    builder: (context) {
      final customEventLabelController =
          TextEditingController(text: initialVal);
      final formKey = GlobalKey<FormState>();
      final FocusNode focusNode = FocusNode();
      focusNode.requestFocus();
      return SimpleDialog(
        title: const Text("Custom label name"),
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Form(
                key: formKey,
                child: Row(
                  children: [
                    AppTextField(
                      controller: customEventLabelController,
                      focusNode: focusNode,
                      validator: (val) {
                        if (val == null || val.length < 3) {
                          return "Please enter valid label name";
                        }
                        return null;
                      },
                    ).expand
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      /// navigating back with controller's value
                      if (formKey.currentState?.validate() ?? false) {
                        Navigator.of(context)
                            .pop(customEventLabelController.text.trim());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
                    child: const Text("Save"),
                  ),
                ],
              )
            ],
          ).padXXDefault
        ],
      );
    },
  );
}
