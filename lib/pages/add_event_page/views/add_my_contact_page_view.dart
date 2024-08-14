import 'dart:typed_data';

import 'package:Remindify/components/app_textfield.dart';
import 'package:Remindify/components/background_widget.dart';
import 'package:Remindify/components/full_screen_loader.dart';
import 'package:Remindify/models/event_model.dart';
import 'package:Remindify/models/my_contact_model.dart';
import 'package:Remindify/pages/add_event_page/bloc/add_my_contact_bloc.dart';
import 'package:Remindify/pages/add_event_page/views/add_first_event_tile.dart';
import 'package:Remindify/pages/add_event_page/views/add_fist_event_dialog.dart';
import 'package:Remindify/pages/add_event_page/views/event_list.dart';
import 'package:Remindify/pages/add_event_page/views/import_from_contact_bottomsheet.dart';
import 'package:Remindify/pages/view_event_page/views/view_full_screen_image.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/services/database_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../../dashboard/home_page/bloc/home_bloc.dart';
import 'edit_profile_image.dart';

class AddMyContactPageView extends StatefulWidget {
  const AddMyContactPageView({super.key});

  @override
  State<AddMyContactPageView> createState() => _AddMyContactPageViewState();
}

class _AddMyContactPageViewState extends State<AddMyContactPageView> {
  /// controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  Uint8List? profileImage;

  /// focus nodes
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode noteFocusNode = FocusNode();

  /// form keys
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// other variables
  final List<EventModel> _events = [];

  @override
  void initState() {
    super.initState();
    final editContactModelData =
        context.read<AddMyContactBloc>().editMyContactData;
    if (editContactModelData != null) {
      nameController.text = editContactModelData.name;
      phoneController.text = editContactModelData.phone ?? '';
      noteController.text = editContactModelData.friendNote ?? '';
      _events.addAll(editContactModelData.events);
      profileImage = editContactModelData.image;
    }
  }

  @override
  void dispose() {
    // focus nodes
    nameFocusNode.dispose();
    phoneFocusNode.dispose();
    noteFocusNode.dispose();
    // controllers
    nameController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Event")),
      body: Stack(
        children: [
          const BackgroundWidget(),
          SafeArea(
            child: Form(
              key: _formKey,
              child: BlocConsumer<AddMyContactBloc, AddMyContactState>(
                listener: (context, state) {
                  if (state is AddMyContactAddedState) {
                    /// go back to home when updating event
                    Navigator.popUntil(
                        context, ModalRoute.withName('/dashboard'));

                    /// refresh contacts in home page
                    context.read<HomeBloc>().add(FetchMyContactsFromDb());
                    AppServices.showSnackBar(
                        context, "Event added successfully!");
                  } else if (state is AddMyContactUpdatedState) {
                    /// go back to home when updating event
                    Navigator.popUntil(
                        context, ModalRoute.withName('/dashboard'));

                    /// refresh contacts in home page
                    context.read<HomeBloc>().add(FetchMyContactsFromDb());
                    AppServices.showSnackBar(
                        context, "Event updated successfully!");
                  } else if (state is AddMyContactErrorState) {
                    AppServices.showSnackBar(
                        context, "Something went wrong, please try again!");
                  }
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      Column(
                        children: [
                          SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// image
                                Center(
                                    child: Stack(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(65),
                                      onTap: profileImage == null
                                          ? null
                                          : () => viewFullScreenImage(
                                              context, profileImage!),
                                      child: CircleAvatar(
                                        maxRadius: 65,
                                        backgroundImage: profileImage == null
                                            ? null
                                            : MemoryImage(profileImage!),
                                        child: Icon(
                                          Icons.person,
                                          size: 75,
                                          color: Theme.of(context).focusColor,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        onPressed: () async {
                                          final result = await editProfileImage(
                                              context, profileImage);
                                          if (result == "delete") {
                                            profileImage = null;
                                            setState(() {});
                                          } else if (result != null) {
                                            profileImage = result;
                                            setState(() {});
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.photo_camera_outlined,
                                            color: Colors.white),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Theme.of(context).disabledColor,
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                                const YGap(30),

                                /// name
                                Text("Name *", style: headingStyle(context)),
                                AppTextField(
                                  controller: nameController,
                                  hintText: "John Cena",
                                  focusNode: nameFocusNode,
                                  prefix: const Icon(Icons.person),
                                  validator: (val) {
                                    if (val == null || val.trim().length < 3) {
                                      return "Please enter valid name!";
                                    }
                                    return null;
                                  },
                                ),
                                const YGap(10),

                                /// phone number
                                Text(
                                  "Phone Number (Optional)",
                                  style: headingStyle(context),
                                ),
                                AppTextField(
                                  controller: phoneController,
                                  hintText: "+911234567890",
                                  focusNode: phoneFocusNode,
                                  keyboardType: TextInputType.phone,
                                  maxLength: 13,
                                  prefix: const Icon(Icons.phone),
                                  suffix: IconButton(
                                    onPressed: () async {
                                      final result =
                                          await showImportFromContactBottomSheet(
                                        context,
                                        context.read<AddMyContactBloc>(),
                                      );
                                      // return if result is null
                                      if (result == null) return;
                                      // assign first phone number to phone controller
                                      phoneController.text = result.phones
                                              .firstOrNull?.normalizedNumber ??
                                          '';
                                      // assign name to name controller if it is empty
                                      if (nameController.text.isEmpty) {
                                        nameController.text =
                                            result.displayName;
                                      }
                                      // assign photo if it is empty
                                      profileImage ??= result.photoOrThumbnail;

                                      // assign events if it is empty
                                      if (_events.isEmpty) {
                                        final contactEvent =
                                            AppServices.getEvents(
                                                result.events);
                                        _events.addAll(contactEvent);
                                      }
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.contacts_rounded),
                                  ),
                                  onChanged: (value) {
                                    if (value.trim().length >= 13) {
                                      phoneFocusNode.unfocus();
                                    }
                                  },
                                  validator: (val) {
                                    if (val != null &&
                                        val.isNotEmpty &&
                                        (val.trim().length > 13 ||
                                            val.trim().length < 10)) {
                                      return "Please enter valid phone number!";
                                    }
                                    return null;
                                  },
                                ),
                                const YGap(10),

                                /// event label
                                Text("Events *", style: headingStyle(context)),

                                const YGap(10),

                                /// event list
                                EventList(
                                  events: _events,
                                  onRemove: (index) =>
                                      setState(() => _events.removeAt(index)),
                                ),

                                /// add first event tile
                                if (_events.isEmpty)
                                  AddFirstEventTile(onTap: () async {
                                    final eventModel =
                                        await addFirstEventDialog(context);
                                    if (eventModel != null) {
                                      _events.add(eventModel);
                                      setState(() {});
                                    }
                                    noteFocusNode.unfocus();
                                    nameFocusNode.unfocus();
                                    phoneFocusNode.unfocus();
                                  }),
                                const YGap(10),

                                /// add more events, button when events.length is less than 4
                                if (_events.length < 4 &&
                                    _events.isNotEmpty) ...[
                                  Container(
                                    height: 30,
                                    alignment: Alignment.centerRight,
                                    child: OutlinedButton.icon(
                                      onPressed: () => _addMoreEvents(),
                                      iconAlignment: IconAlignment.end,
                                      label: const Text("Add more Events"),
                                      icon: const Icon(Icons.add_card_outlined),
                                    ),
                                  ),
                                  const YGap(16)
                                ],

                                /// Note
                                Text(
                                  "Note (Optional)",
                                  style: headingStyle(context),
                                ),
                                AppTextField(
                                  controller: noteController,
                                  maxLines: 5,
                                  focusNode: noteFocusNode,
                                  hintText: "Write note here...",
                                ),
                                const YGap(10),
                              ],
                            ).padAll(16),
                          ).expand,
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  final bloc = context.read<AddMyContactBloc>();
                                  bloc.editMyContactData == null
                                      // add event
                                      ? saveAndAddEvent(bloc)
                                      // update event
                                      : saveAndUpdateEvent(bloc);
                                },
                                child: (state is AddMyContactLoadingState)
                                    ? SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                            color: kColorScheme.onPrimary,
                                            strokeWidth: 2),
                                      )
                                    : const Text("Save"),
                              ).expand,
                            ],
                          ).padXXDefault,
                          const YGap(20)
                        ],
                      ),
                      Visibility(
                        visible: state is AddMyContactLoadingState,
                        child: const FullScreenLoader(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// save myContactModel
  void saveAndAddEvent(AddMyContactBloc bloc) {
    if (_formKey.currentState?.validate() != true) return;
    if (_events.isEmpty) {
      AppServices.showSnackBar(context, 'Please add event!');
      return;
    }
    final myContactModel = MyContactModel(
      name: nameController.text.trim(),
      events: _events,
      phone: phoneController.text.trim(),
      image: profileImage,
      friendNote: noteController.text.trim(),
    );
    FocusScope.of(context).unfocus();
    bloc.add(AddMyContactToDbEvent(
      databaseServices: DatabaseServices.instance,
      myContactModel: myContactModel,
    ));
  }

  /// update myContactModel
  void saveAndUpdateEvent(AddMyContactBloc bloc) {
    if (_formKey.currentState?.validate() != true) return;
    if (_events.isEmpty) {
      AppServices.showSnackBar(context, 'Please add event!');
      return;
    }

    final myContactModel = MyContactModel(
      name: nameController.text.trim(),
      events: _events,
      phone: phoneController.text.trim(),
      image: profileImage,
      friendNote: noteController.text.trim(),
      id: bloc.editMyContactData!.id,
      inBuildId: bloc.editMyContactData!.inBuildId,
    );
    FocusScope.of(context).unfocus();
    bloc.add(UpdateMyContactFromDbEvent(
      databaseServices: DatabaseServices.instance,
      myContactModel: myContactModel,
    ));
  }

  TextStyle headingStyle(BuildContext context) {
    return Theme.of(context).textTheme.labelLarge!;
  }

  _addMoreEvents() async {
    final eventLabelLeft = EventLabel.values.where(
      (element) {
        if (_events.any((i) => i.label == element)) return false;
        return true;
      },
    ).toList();
    final eventModel = await addFirstEventDialog(context,
        initialEventLabelList: eventLabelLeft);
    if (eventModel != null) {
      _events.add(eventModel);
      setState(() {});
    }
    noteFocusNode.unfocus();
    nameFocusNode.unfocus();
    phoneFocusNode.unfocus();
  }
}
