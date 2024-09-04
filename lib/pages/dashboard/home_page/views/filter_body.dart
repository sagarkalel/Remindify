import 'package:Remindify/models/filter_list_model.dart';
import 'package:Remindify/pages/dashboard/home_page/bloc/home_bloc.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FilterBody extends StatefulWidget {
  const FilterBody({super.key});

  @override
  State<FilterBody> createState() => _FilterBodyState();
}

class _FilterBodyState extends State<FilterBody> {
  FilterListModel? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = context.read<HomeBloc>().appliedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is FilterChangedState) Navigator.pop(context);
      },
      builder: (context, state) {
        final bloc = context.read<HomeBloc>();
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Sort By",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const Divider(),
            const YGap(16),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filterList.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final item = filterList[index];
                return filterTile(
                  context,
                  value: item.value,
                  title: item.title,
                  selectedValue: selectedValue?.value ?? filterList.first.value,
                  onChanged: (value) {
                    selectedValue = filterList
                        .firstWhere((element) => element.value == value);
                    setState(() {});
                  },
                );
              },
            ),
            const YGap(40),
            Row(
              children: [
                ElevatedButton(
                  onPressed: bloc.appliedFilter == filterList.first
                      ? null
                      : () => bloc.add(ClearFilter()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    disabledBackgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                          color: bloc.appliedFilter == filterList.first
                              ? Theme.of(context).disabledColor
                              : Theme.of(context).primaryColor),
                    ),
                  ),
                  child: const Text("Clear"),
                ).expand,
                const XGap(16),
                ElevatedButton(
                  onPressed: () =>
                      bloc.add(AddFilter(selectedValue ?? filterList.first)),
                  child: const Text("Save"),
                ).expand,
              ],
            ),
            const YGap(16),
          ],
        );
      },
    ).padXXDefault;
  }

  Widget filterTile(
    context, {
    required String value,
    required String title,
    required String selectedValue,
    required void Function(String?)? onChanged,
  }) {
    return RadioListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      // tileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      selectedTileColor: Theme.of(context).primaryColor.withOpacity(0.1),
      visualDensity: VisualDensity.compact,
      selected: selectedValue == value,
      value: value,
      groupValue: selectedValue,
      onChanged: onChanged,
      title: Text(title),
    );
  }
}
