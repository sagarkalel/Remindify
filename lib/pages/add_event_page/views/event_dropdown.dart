import 'package:Remindify/services/app_services.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class EventDropdown extends StatelessWidget {
  const EventDropdown({super.key, this.onChanged, required this.value});

  final void Function(EventLabel?)? onChanged;
  final EventLabel value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DropdownButtonHideUnderline(
        child: DropdownButton2(
            value: value,
            onChanged: onChanged,
            dropdownStyleData: DropdownStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            buttonStyleData: ButtonStyleData(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).hintColor),
              ),
            ),
            items: EventLabel.values
                .map(
                  (e) => DropdownMenuItem(
                    value: e,
                    child: Text(AppServices.eventLabelToString[e] ?? 'None'),
                  ),
                )
                .toList()),
      ),
    );
  }
}
