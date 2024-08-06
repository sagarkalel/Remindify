import 'package:Remindify/pages/import_from_contacts_page/bloc/import_native_contact_bloc.dart';
import 'package:Remindify/pages/import_from_contacts_page/views/import_native_contact_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImportNativeContactPage extends StatelessWidget {
  const ImportNativeContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ImportNativeContactBloc()..add(ImportNativeContacts()),
      child: const ImportNativeContactPageView(),
    );
  }
}
