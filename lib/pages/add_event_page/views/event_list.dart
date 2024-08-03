import 'package:birthday_reminder/models/event_model.dart';
import 'package:birthday_reminder/services/app_services.dart';
import 'package:birthday_reminder/utils/extensions.dart';
import 'package:birthday_reminder/utils/global_constants.dart';
import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  const EventList({
    super.key,
    required this.events,
    required this.onRemove,
  });

  final List<EventModel> events;
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
                    AppServices.eventLabelToString[item.label] ?? "Birthday",
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
