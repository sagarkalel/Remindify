import 'package:Remindify/models/event_info_model.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../../services/app_services.dart';

class EventListTile extends StatelessWidget {
  const EventListTile({
    super.key,
    required this.item,
  });

  final EventInfoModel item;

  @override
  Widget build(BuildContext context) {
    final daysLeft = AppServices.getDaysUntilNextDate(item.date);
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        visualDensity: VisualDensity.compact,
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        title: Text(item.label == EventLabel.custom
            ? item.customLabel ?? 'None'
            : AppServices.eventLabelToString[item.label] ?? 'No Date found!'),
        subtitle: Text(item.date),
        trailing: daysLeft == null
            ? const Icon(Icons.question_mark)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  daysLeft == 0
                      ? Icon(Icons.celebration,
                          size: 32, color: kColorScheme.surfaceTint)
                      : Text(
                          daysLeft.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: kColorScheme.surfaceTint),
                        ),
                  daysLeft == 0 ? const Text("Today") : const Text("Days")
                ],
              ),
      ).padYBottom(3),
    ).padYBottom(2);
  }
}
