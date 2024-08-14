import 'package:Remindify/pages/add_event_page/bloc/add_my_contact_bloc.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

Future<Contact?> showImportFromContactBottomSheet(
    BuildContext context, AddMyContactBloc bloc) async {
  Contact? selectedContact;
  return await showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) {
      return BlocProvider.value(
        value: bloc..add(GetNativeContacts()),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: getScreenY(context) * 0.5,
            maxHeight: getScreenY(context) * .75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Select contact",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              StatefulBuilder(
                builder: (context, updateState) {
                  return Column(
                    children: [
                      BlocBuilder<AddMyContactBloc, AddMyContactState>(
                        builder: (context, state) {
                          if (state is NativeContactsLoading) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (state is NativeContactsFailure) {
                            return const Center(
                              child: Text(
                                  "Something went wrong, please try again!"),
                            );
                          } else if (state is NativeContactsLoaded &&
                              state.contacts.isEmpty) {
                            return const Center(
                                child: Text("Ohh, contacts not found!"));
                          } else {
                            final contacts =
                                context.read<AddMyContactBloc>().nativeContacts;
                            return ListView.builder(
                              itemCount: contacts.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                final item = contacts[index];
                                return Card(
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: BorderSide(
                                          color: Theme.of(context)
                                              .unselectedWidgetColor
                                              .withOpacity(0.05)),
                                    ),
                                    visualDensity: VisualDensity.compact,
                                    tileColor: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.1),
                                    title: Text(item.displayName),
                                    subtitle: Text(item.phones.firstOrNull
                                            ?.normalizedNumber ??
                                        'Empty'),
                                    leading: CircleAvatar(
                                      backgroundColor:
                                          Theme.of(context).focusColor,
                                      backgroundImage: item.thumbnail == null
                                          ? null
                                          : MemoryImage(item.thumbnail!),
                                      child: item.thumbnail == null
                                          ? Icon(Icons.person,
                                              size: 28,
                                              color: kColorScheme.secondary)
                                          : null,
                                    ),
                                    onTap: () {
                                      if (selectedContact == item) {
                                        selectedContact = null;
                                      } else {
                                        selectedContact = item;
                                      }
                                      updateState(() {});
                                    },
                                    trailing: Icon(item == selectedContact
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off),
                                  ).padYBottom(3),
                                );
                              },
                            ).padXXDefault;
                          }
                        },
                      ).expand,
                      if (selectedContact != null)
                        SizedBox(
                          width: getScreenX(context),
                          child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.pop(context, selectedContact),
                              child: const Text("Import")),
                        ).padXXDefault,
                      const YGap(16),
                    ],
                  ).expand;
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}
