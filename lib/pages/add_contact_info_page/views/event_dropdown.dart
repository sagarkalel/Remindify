import 'package:Remindify/utils/global_constants.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class EventDropdown extends StatelessWidget {
  const EventDropdown({
    super.key,
    this.onChanged,
    required this.value,
    required this.initialEventLabelList,
  });

  final void Function(String?)? onChanged;
  final String value;
  final List<String> initialEventLabelList;

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
              padding: const EdgeInsets.symmetric(horizontal: 8),
              width: getScreenX(context) * .35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Theme.of(context).hintColor),
              ),
            ),
            items: initialEventLabelList
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList()),
      ),
    );
  }
}
