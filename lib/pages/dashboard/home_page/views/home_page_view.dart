import 'package:Remindify/components/app_textfield.dart';
import 'package:Remindify/components/background_widget.dart';
import 'package:Remindify/models/filter_model.dart';
import 'package:Remindify/models/my_contact_model.dart';
import 'package:Remindify/pages/dashboard/settings/bloc/setting_bloc.dart';
import 'package:Remindify/pages/import_from_contacts_page/import_native_contact_page.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/home_bloc.dart';
import 'filter_body.dart';
import 'home_page_list_tile.dart';
import 'notification_disabled_widget.dart';

part 'home_page_list.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, settingState) {
        return BlocBuilder<HomeBloc, HomeState>(
          builder: (context, homeState) {
            final bloc = context.read<HomeBloc>();
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => bloc.searchFocusNode.unfocus(),
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: kToolbarHeight + 10,

                  /// search icon and text field
                  title: bloc.isSearchVisible
                      ? AppTextField(
                          controller: bloc.searchController,
                          focusNode: bloc.searchFocusNode,
                          hintText: 'Search by name, phone or friend note...',
                          onChanged: (p0) => bloc.add(SearchEvents()),
                          prefix: IconButton(
                            onPressed: () => bloc.add(const ClearSearch()),
                            icon: const Icon(Icons.arrow_back),
                          ),
                          suffix: IconButton(
                            onPressed: () =>
                                bloc.add(const ClearSearch(clearOnly: true)),
                            icon: const Icon(Icons.clear),
                          ),
                        )
                      : IconButton(
                          onPressed: () => bloc.add(GetSearch()),
                          icon: const Icon(Icons.search, size: 28),
                        ),
                  actions: [
                    /// import from contact
                    bloc.isSearchVisible
                        ? const SizedBox.shrink()
                        : ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ImportNativeContactPage(),
                                  )).then(
                                (value) {
                                  /// if value is true then only refresh data
                                  if (value == true) {
                                    bloc.add(FetchMyContactsFromDb());
                                  }
                                },
                              );
                            },
                            iconAlignment: IconAlignment.end,
                            icon: const Text('Contacts'),
                            label:
                                const Icon(Icons.drive_file_move_rtl_outlined),
                          ),

                    /// filter
                    bloc.isSearchVisible
                        ? const SizedBox.shrink()
                        : InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                isScrollControlled: true,
                                builder: (context) => const FilterBody(),
                              );
                            },
                            child: CircleAvatar(
                              maxRadius: 18,
                              backgroundColor:
                                  bloc.appliedFilter == filterList.first
                                      ? Colors.transparent
                                      : kColorScheme.onInverseSurface,
                              child: Icon(
                                bloc.appliedFilter == filterList.first
                                    ? Icons.filter_list
                                    : Icons.filter_list_off,
                              ),
                            ),
                          ).padXX(10),
                  ],
                ),
                body: Stack(
                  alignment: Alignment.center,
                  children: [
                    const BackgroundWidget(),
                    Padding(
                      padding: EdgeInsets.only(
                          top: bloc.showPermissionWidget ? 85 : 0),
                      child: Center(
                        child: Builder(
                          builder: (context) {
                            if (homeState is HomeContactsLoadingState) {
                              return const CupertinoActivityIndicator();
                            } else if (homeState is HomeContactsErrorState) {
                              return Text(homeState.errorMessage,
                                      textAlign: TextAlign.center)
                                  .padXXDefault;
                            } else {
                              return HomePageList(
                                myContacts: bloc.isSearchVisible
                                    ? bloc.inSearchContactList
                                    : bloc.filterAppliedContactList,
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    Visibility(
                      visible: bloc.showPermissionWidget,
                      child: const NotificationDisabledWidget(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
