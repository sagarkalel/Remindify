import 'package:Remindify/models/my_contact_model.dart';
import 'package:Remindify/pages/add_event_page/add_my_contact_page.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';

import '../../components/background_widget.dart';
import 'views/event_list_tile.dart';

class ViewEventPage extends StatelessWidget {
  const ViewEventPage({super.key, required this.myContactModel});

  final MyContactModel myContactModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(myContactModel.name),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share),
          ),
          IconButton.filled(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddEventPage(editMyContactData: myContactModel),
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
                  child: CircleAvatar(
                    maxRadius: 65,
                    backgroundImage: myContactModel.image == null
                        ? null
                        : MemoryImage(
                            AppServices.getImageData(myContactModel.image!)),
                    child: myContactModel.image == null
                        ? Icon(
                            Icons.person,
                            size: 75,
                            color: Theme.of(context).focusColor,
                          )
                        : null,
                  ).padAll(2),
                )),
                const YGap(30),
                Text("Phone Number", style: headingStyle(context)).padXLeft(20),
                const YGap(4),
                Card(
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    visualDensity: VisualDensity.compact,
                    tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
                    leading: const Icon(Icons.phone),
                    title: Text(
                        myContactModel.phone == null ||
                                myContactModel.phone!.isEmpty
                            ? 'Empty!'
                            : myContactModel.phone ?? '',
                        style: myContactModel.phone == null ||
                                myContactModel.phone!.isEmpty
                            ? const TextStyle().copyWith(
                                color: Theme.of(context)
                                    .hintColor
                                    .withOpacity(0.5))
                            : null),
                  ).padYBottom(3),
                ).padXXDefault,

                /// Note
                Text("Events", style: headingStyle(context)).padXLeft(20),
                const YGap(4),
                ListView.builder(
                  itemCount: myContactModel.events.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) =>
                      EventListTile(item: myContactModel.events[index]),
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
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(myContactModel.friendNote == null ||
                            myContactModel.friendNote!.isEmpty
                        ? 'Note not found!'
                        : myContactModel.friendNote!),
                  ),
                ).padXXDefault,
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle headingStyle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!;
  }
}
