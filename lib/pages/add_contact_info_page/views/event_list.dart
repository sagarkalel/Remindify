import 'package:Remindify/models/event_info_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.events,
    required this.onRemove,
  });

  final List<EventInfoModel> events;
  final Function(int index) onRemove;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final item = events[index];
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: SizedBox(
                child: ListTile(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                        color: Theme.of(context)
                            .unselectedWidgetColor
                            .withOpacity(0.05)),
                  ),
                  visualDensity: VisualDensity.compact,
                  tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  minVerticalPadding: 0,
                  title: Text(item.date),
                  trailing: Text(
                    (AppServices.eventLabelToString[item.label] ==
                            AppServices.eventLabelToString[EventLabel.custom])
                        ? (item.customLabel ?? 'Custom Label')
                        : (AppServices.eventLabelToString[item.label] ??
                            'Birthday'),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ).padYBottom(3),
              ),
            ).expand,
            const XGap(8),
            IconButton(
              onPressed: () => onRemove(index),
              icon: Icon(Icons.close, color: Theme.of(context).primaryColor),
            )
          ],
        );
      },
    );
  }
}
