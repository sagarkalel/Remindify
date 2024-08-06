import 'package:Remindify/models/my_contact_model.dart';
import 'package:Remindify/pages/add_event_page/bloc/add_my_contact_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/add_my_contact_page_view.dart';

class AddEventPage extends StatelessWidget {
  const AddEventPage({super.key, this.editMyContactData});

  final MyContactModel? editMyContactData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddMyContactBloc(editMyContactData: editMyContactData),
      child: const AddMyContactPageView(),
    );
  }
}
