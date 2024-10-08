import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/pages/view_event_page/view_event_page.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

class HomePageListTile extends StatelessWidget {
  const HomePageListTile({super.key, required this.item});

  final ContactInfoModel item;

  @override
  Widget build(BuildContext context) {
    final daysLeft =
        AppServices.getDaysUntilNextDateFromClosureEvent(item.events);
    return Card(
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: Theme.of(context).unselectedWidgetColor.withOpacity(0.05)),
        ),
        visualDensity: VisualDensity.comfortable,
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        onTap: () {
          /// navigating to view event page
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewEventPage(contactInfoModel: item),
              ));
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          backgroundImage: item.image == null ? null : MemoryImage(item.image!),
          child: item.image == null
              ? Icon(Icons.person, size: 28, color: kColorScheme.secondary)
              : null,
        ),
        title: Text(
          item.name.isEmpty ? "Unknown" : item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(AppServices.getClosureEventDateWithLabel(item.events)),
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
      ).padYY(3),
    ).padYBottom(2);
  }
}
