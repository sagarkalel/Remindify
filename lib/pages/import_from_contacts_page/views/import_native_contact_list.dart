import 'package:birthday_reminder/pages/import_from_contacts_page/bloc/import_native_contact_bloc.dart';
import 'package:birthday_reminder/pages/import_from_contacts_page/views/import_native_contact_list_tile.dart';
import 'package:birthday_reminder/utils/extensions.dart';
import 'package:birthday_reminder/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

class ImportNativeContactList extends StatelessWidget {
  const ImportNativeContactList({
    super.key,
    required this.nativeContacts,
    required this.selectedContacts,
  });

  final List<Contact> nativeContacts;
  final List<String> selectedContacts;

  @override
  Widget build(BuildContext context) {
    /// getting contacts with event and storing in local variable
    final contactsWithEvent =
        nativeContacts.where((element) => element.events.isNotEmpty).toList();

    /// getting contacts without event and storing in local variable
    final contactsWithoutEvent =
        nativeContacts.where((element) => element.events.isEmpty).toList();

    /// isAllSelected
    final isAllSelected = selectedContacts.length == nativeContacts.length;
    return Column(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            /// top gap
            const SliverToBoxAdapter(child: YGap(16)),

            /// select all checkbox tile
            SliverToBoxAdapter(
              child: CheckboxListTile(
                onChanged: (value) => context
                    .read<ImportNativeContactBloc>()
                    .add(SelectAllContacts(value ?? false)),
                value: isAllSelected,
                controlAffinity: ListTileControlAffinity.leading,
                title: const Text("Select All"),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                visualDensity: VisualDensity.comfortable,
                tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
              ),
            ),

            /// contacts with event text
            SliverToBoxAdapter(
              child: Text(
                "Contacts With Event (${contactsWithEvent.length})",
                style: Theme.of(context).textTheme.titleMedium,
              ).padYY(10),
            ),

            /// contacts with event list
            SliverList.builder(
              itemCount: contactsWithEvent.length,
              itemBuilder: (context, index) => ImportFromContactListTile(
                  contact: contactsWithEvent[index],
                  selectedContacts: selectedContacts),
            ),

            /// contacts without event text
            SliverToBoxAdapter(
              child: Text(
                "Contacts Without Event (${contactsWithoutEvent.length})",
                style: Theme.of(context).textTheme.titleMedium,
              ).padYY(10),
            ),

            /// contacts without event list
            SliverList.builder(
              itemCount: contactsWithoutEvent.length,
              itemBuilder: (context, index) => ImportFromContactListTile(
                  contact: contactsWithoutEvent[index],
                  selectedContacts: selectedContacts),
            ),

            /// bottom gap
            const SliverToBoxAdapter(child: YGap(16)),
          ],
        ).expand,
        BlocBuilder<ImportNativeContactBloc, ImportNativeContactState>(
          builder: (context, state) {
            if (selectedContacts.isEmpty) return const SizedBox.shrink();
            return ElevatedButton(
              onPressed: () => context
                  .read<ImportNativeContactBloc>()
                  .add(StoreNativeContactsInDb()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (state is NativeContactStoringState)
                    SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          color: kColorScheme.onPrimary, strokeWidth: 2),
                    )
                  else
                    const Text("Import"),
                ],
              ),
            );
          },
        ).padYBottom(16),
      ],
    );
  }
}
