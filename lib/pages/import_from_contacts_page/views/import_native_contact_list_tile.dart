import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';

import '../bloc/import_native_contact_bloc.dart';

class ImportFromContactListTile extends StatelessWidget {
  const ImportFromContactListTile({
    super.key,
    required this.contact,
    required this.selectedContacts,
  });

  final List<String> selectedContacts;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedContacts.contains(contact.id);
    final item = ContactInfoModel.fromNativeContact(contact);
    return Card(
      child: CheckboxListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
              color: Theme.of(context).unselectedWidgetColor.withOpacity(0.05)),
        ),
        visualDensity: VisualDensity.comfortable,
        tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
        secondary: CircleAvatar(
          backgroundColor: Theme.of(context).focusColor,
          backgroundImage: item.image == null ? null : MemoryImage(item.image!),
          child: item.image == null
              ? Icon(Icons.person, size: 28, color: kColorScheme.secondary)
              : null,
        ),
        onChanged: (value) {
          context
              .read<ImportNativeContactBloc>()
              .add(ToggleNativeContacts(contact.id));
        },
        value: isSelected,
        title: Text(item.name.isEmpty ? "Unknown" : item.name),
        subtitle: Text(AppServices.getClosureEventDateWithLabel(item.events)),
      ).padYY(3),
    ).padYBottom(2);
  }
}
