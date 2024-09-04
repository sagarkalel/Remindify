import 'package:Remindify/components/full_screen_loader.dart';
import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/pages/add_contact_info_page/add_contact_info_page.dart';
import 'package:Remindify/pages/dashboard/home_page/bloc/home_bloc.dart';
import 'package:Remindify/pages/view_event_page/views/view_full_screen_image.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../components/background_widget.dart';
import 'views/event_list_tile.dart';

class ViewEventPage extends StatelessWidget {
  const ViewEventPage({super.key, required this.contactInfoModel});

  final ContactInfoModel contactInfoModel;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is ContactDeletedSuccessfully) {
          /// go back to home when adding event
          Navigator.pop(context, true);
          AppServices.showSnackBar(context, "Event deleted successfully!");
        } else if (state is ContactDeleteFailure) {
          AppServices.showSnackBar(
              context, "Something went wrong, please try again!");
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(contactInfoModel.name),
                actions: [
                  /// delete event contact
                  IconButton.filled(
                    onPressed: () => _showDeleteAlertDialog(context),
                    icon: Icon(Icons.delete_forever_rounded,
                        color: kColorScheme.onPrimary),
                  ),
                  const XGap(4),

                  /// edit event contact
                  IconButton.filled(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddContactInfoPage(
                                editContactInfoData: contactInfoModel),
                          ));
                    },
                    icon: Icon(Icons.edit, color: kColorScheme.onPrimary),
                  ).padXRight(16)
                ],
              ),
              body: Stack(
                children: [
                  const BackgroundWidget(),
                  SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const YGap(30),

                        /// profile image
                        Center(
                            child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(65)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(65),
                            onTap: contactInfoModel.image == null
                                ? null
                                : () => viewFullScreenImage(
                                    context, contactInfoModel.image!),
                            child: CircleAvatar(
                              maxRadius: 65,
                              backgroundImage: contactInfoModel.image == null
                                  ? null
                                  : MemoryImage(contactInfoModel.image!),
                              child: contactInfoModel.image == null
                                  ? Icon(
                                      Icons.person,
                                      size: 75,
                                      color: Theme.of(context).focusColor,
                                    )
                                  : null,
                            ).padAll(2),
                          ),
                        )),
                        const YGap(30),
                        Text("Phone Number", style: headingStyle(context))
                            .padXLeft(20),
                        const YGap(4),
                        Card(
                          child: ListTile(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            visualDensity: VisualDensity.compact,
                            tileColor:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            leading: const Icon(Icons.phone),
                            title: Text(
                                contactInfoModel.phone == null ||
                                        contactInfoModel.phone!.isEmpty
                                    ? 'Empty!'
                                    : contactInfoModel.phone ?? '',
                                style: contactInfoModel.phone == null ||
                                        contactInfoModel.phone!.isEmpty
                                    ? const TextStyle().copyWith(
                                        color: Theme.of(context)
                                            .hintColor
                                            .withOpacity(0.5))
                                    : null),
                          ).padYBottom(3),
                        ).padXXDefault,

                        /// Note
                        Text("Events", style: headingStyle(context))
                            .padXLeft(20),
                        const YGap(4),
                        Visibility(
                          visible: contactInfoModel.events.isEmpty,
                          child: Text(
                            "Events not found!",
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: Theme.of(context).disabledColor),
                          ),
                        ).padXLeft(20),
                        ListView.builder(
                          itemCount: contactInfoModel.events.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) => EventListTile(
                              item: contactInfoModel.events[index]),
                        ),
                        const YGap(16),

                        /// Note
                        Text("Note", style: headingStyle(context)).padXLeft(20),
                        const YGap(4),
                        Card(
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: getScreenY(context) * .1,
                              minWidth: getScreenX(context),
                            ),
                            margin: const EdgeInsets.only(bottom: 3),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(contactInfoModel.friendNote == null ||
                                    contactInfoModel.friendNote!.isEmpty
                                ? 'Note not found!'
                                : contactInfoModel.friendNote!),
                          ),
                        ).padXXDefault,
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: state is ContactDeleteLoading,
              child: const FullScreenLoader(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteAlertDialog(context) async {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("Alert"),
          content: Column(
            children: [
              Icon(Icons.warning_rounded,
                  size: 75, color: kColorScheme.primary.withOpacity(0.7)),
              const Text("Do you really want to delete this event ?")
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<HomeBloc>().add(DeleteContact(contactInfoModel));
                Navigator.pop(context);
              },
              style: TextButton.styleFrom(
                foregroundColor: kColorScheme.error,
              ),
              child: const Text("Delete"),
            )
          ],
        );
      },
    );
  }

  TextStyle headingStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!;
  }
}
