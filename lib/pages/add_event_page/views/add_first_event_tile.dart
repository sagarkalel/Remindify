import 'package:birthday_reminder/utils/extensions.dart';
import 'package:flutter/material.dart';

class AddFirstEventTile extends StatelessWidget {
  const AddFirstEventTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        visualDensity: VisualDensity.compact,
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        title: Text('Event not found!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).hintColor.withOpacity(0.5))),
        trailing: const Icon(Icons.add_card_outlined),
      ).padYBottom(3),
    ).padYBottom(2);
  }
}
