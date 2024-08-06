import 'dart:developer';

import 'package:Remindify/components/background_widget.dart';
import 'package:Remindify/pages/import_from_contacts_page/bloc/import_native_contact_bloc.dart';
import 'package:Remindify/services/app_services.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'import_native_contact_list.dart';

class ImportNativeContactPageView extends StatelessWidget {
  const ImportNativeContactPageView({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Import From Contacts")),
      body: Stack(
        children: [
          const BackgroundWidget(),
          SafeArea(
            child: Center(
              child: BlocConsumer<ImportNativeContactBloc,
                  ImportNativeContactState>(
                listener: (context, state) {
                  if (state is NativeContactStoredInDbState) {
                    /// go back to home when adding event
                    Navigator.pop(context, true);
                    AppServices.showSnackBar(
                        context, "Selected contacts imported successfully!");
                  } else if (state is NativeContactErrorState) {
                    AppServices.showSnackBar(
                        context, "Something went wrong, please try again!");
                    log("This error is getting while dding imported contacts: ${state.errorMessage}");
                  }
                },
                builder: (context, state) {
                  if (state is NativeContactLoadingState) {
                    return const CupertinoActivityIndicator();
                  } else if (state is NativeContactErrorState) {
                    return Text(state.errorMessage);
                  } else if (state is NativeContactsPermissionRequestState) {
                    return const Text("Permission is not given");
                  } else {
                    final bloc = context.read<ImportNativeContactBloc>();
                    return ImportNativeContactList(
                      nativeContacts: bloc.allImportedContacts,
                      selectedContacts: bloc.selectedContacts,
                    );
                  }
                },
              ),
            ).padXXDefault,
          ),
        ],
      ),
    );
  }
}
