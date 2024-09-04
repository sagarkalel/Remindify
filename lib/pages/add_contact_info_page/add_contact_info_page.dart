import 'package:Remindify/models/contact_info_model.dart';
import 'package:Remindify/pages/add_contact_info_page/bloc/add_my_contact_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/add_contact_info_page_view.dart';

class AddContactInfoPage extends StatelessWidget {
  const AddContactInfoPage({super.key, this.editContactInfoData});

  final ContactInfoModel? editContactInfoData;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          AddContactInfoBloc(editContactInfoData: editContactInfoData),
      child: const AddContactInfoPageView(),
    );
  }
}
