import 'package:Remindify/components/app_textfield.dart';
import 'package:Remindify/components/background_widget.dart';
import 'package:Remindify/models/schedule_time_model.dart';
import 'package:Remindify/pages/dashboard/home_page/bloc/home_bloc.dart';
import 'package:Remindify/utils/extensions.dart';
import 'package:Remindify/utils/global_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/setting_bloc.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Stack(
        children: [
          const BackgroundWidget(),
          BlocConsumer<SettingBloc, SettingState>(
            listener: (context, state) {
              if (state is SettingSaved) {
                context.read<HomeBloc>().add(
                    ScheduleEvents(context.read<SettingBloc>().scheduledTimes));
              }
            },
            builder: (context, state) {
              final bloc = context.read<SettingBloc>();
              if (state is SettingScheduledTimesLoading) {
                return const Center(child: CupertinoActivityIndicator());
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Reminders",
                      style: Theme.of(context).textTheme.titleLarge),
                  const YGap(8),
                  Column(
                      children: bloc.scheduledTimes.map((e) {
                    return ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                            color: Theme.of(context)
                                .unselectedWidgetColor
                                .withOpacity(0.05)),
                      ),
                      trailing: IconButton.outlined(
                        onPressed: () => viewOrAddScheduledTime(context,
                            scheduleTimeModel: e),
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8))),
                        icon: Icon(Icons.edit, color: kColorScheme.surfaceTint),
                      ),
                      visualDensity: VisualDensity.comfortable,
                      tileColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                      title: Text(
                          "Reminder ${bloc.scheduledTimes.indexOf(e) + 1}"),
                      subtitle: Text(_displayTime(e)),
                    ).padYBottom(8);
                  }).toList()),
                  if (bloc.scheduledTimes.length < 5) ...[
                    const YGap(16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text("Add More"),
                        IconButton.filledTonal(
                          onPressed: () => viewOrAddScheduledTime(context),
                          icon: const Icon(Icons.more_time_rounded),
                        ),
                      ],
                    ),
                    SizedBox(height: getScreenY(context) * 0.15),
                  ],
                ],
              );
            },
          ).padXXDefault.padYY(16)
        ],
      ),
    );
  }

  String _displayTime(ScheduleTimeModel e) {
    switch (e.daysBefore) {
      case 0:
        return 'The day of event at ${e.time}';
      default:
        return '${e.daysBefore} day before the event at ${e.time}';
    }
  }

  Future<void> viewOrAddScheduledTime(BuildContext context,
      {ScheduleTimeModel? scheduleTimeModel}) async {
    final TextEditingController daysBeforeController = TextEditingController();
    final FocusNode daysBeforeFocusNode = FocusNode();
    String groupVal = 'same_day';
    TimeOfDay initialTime = TimeOfDay.now();
    if (scheduleTimeModel != null) {
      final parts = scheduleTimeModel.time.split(':');
      initialTime = TimeOfDay(
          hour: int.parse(parts.first), minute: int.parse(parts.last));
      groupVal = scheduleTimeModel.daysBefore == 0 ? 'same_day' : 'days_before';
      daysBeforeController.text = scheduleTimeModel.daysBefore == 0
          ? ''
          : scheduleTimeModel.daysBefore.toString();
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return BlocConsumer<SettingBloc, SettingState>(
            listener: (context, state) {
              if (state is SettingSaved) {
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              final bloc = context.read<SettingBloc>();
              return GestureDetector(
                onTap: () => daysBeforeFocusNode.unfocus(),
                child: SimpleDialog(
                  titlePadding:
                      const EdgeInsets.only(left: 20, top: 8, right: 4),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(scheduleTimeModel != null
                          ? 'Reminder ${bloc.scheduledTimes.indexOf(scheduleTimeModel) + 1}'
                          : "Reminder ${bloc.scheduledTimes.length + 1}"),
                      const CloseButton(),
                    ],
                  ),
                  children: [
                    Column(
                      children: [
                        RadioListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Theme.of(context)
                                    .unselectedWidgetColor
                                    .withOpacity(0.1)),
                          ),
                          visualDensity: VisualDensity.compact,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          value: 'same_day',
                          groupValue: groupVal,
                          onChanged: (val) {
                            setState(() {
                              groupVal = val ?? '';
                            });
                            daysBeforeFocusNode.unfocus();
                          },
                          title: const Text("The day of event"),
                        ),
                        const YGap(8),
                        RadioListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                                color: Theme.of(context)
                                    .unselectedWidgetColor
                                    .withOpacity(0.1)),
                          ),
                          visualDensity: VisualDensity.compact,
                          value: 'days_before',
                          groupValue: groupVal,
                          onChanged: (val) {
                            setState(() {
                              groupVal = val ?? '';
                            });
                            daysBeforeFocusNode.requestFocus();
                          },
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                          title: Row(
                            children: [
                              SizedBox(
                                width: 45,
                                height: 40,
                                child: AppTextField(
                                  controller: daysBeforeController,
                                  focusNode: daysBeforeFocusNode,
                                  maxLength: 2,
                                  fillColor: Colors.red,
                                  onTap: () {
                                    setState(() {
                                      groupVal = 'days_before';
                                    });
                                  },
                                  keyboardType: TextInputType.number,
                                  isCenterAligned: true,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                ),
                              ),
                              const XGap(8),
                              const Text("day before the event"),
                            ],
                          ),
                        ),
                        const YGap(8),
                        Row(
                          children: [
                            OutlinedButton.icon(
                                onPressed: () async {
                                  daysBeforeFocusNode.unfocus();
                                  final TimeOfDay? pickedTime =
                                      await showTimePicker(
                                          context: context,
                                          initialTime: initialTime);
                                  if (pickedTime == null) return;

                                  setState(() {
                                    initialTime = pickedTime;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12))),
                                icon: const Icon(
                                    Icons.access_time_filled_outlined),
                                label: Text(
                                  '${initialTime.hour.toString().padLeft(2, '0')}:${initialTime.minute.toString().padLeft(2, '0')}',
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                )).expand
                          ],
                        ),
                        if (state is SettingSaveError)
                          Text(state.errorMsg,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: kColorScheme.error)),
                        const YGap(12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (bloc.scheduledTimes.length > 1 &&
                                scheduleTimeModel != null)
                              OutlinedButton(
                                onPressed: () => bloc.add(
                                    DeleteScheduledTime(scheduleTimeModel)),
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: kColorScheme.error,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const Text("Delete"),
                              ),
                            const XGap(16),
                            ElevatedButton(
                              onPressed: () {
                                final String selectedTime =
                                    '${initialTime.hour.toString().padLeft(2, '0')}:${initialTime.minute.toString().padLeft(2, '0')}';

                                /// updating
                                if (scheduleTimeModel != null) {
                                  bloc.add(UpdateScheduledTime(
                                    daysBefore: groupVal == 'same_day'
                                        ? '0'
                                        : daysBeforeController.text,
                                    time: selectedTime,
                                    id: scheduleTimeModel.id,
                                  ));
                                } else {
                                  bloc.add(AddScheduledTime(
                                    daysBefore: groupVal == 'same_day'
                                        ? '0'
                                        : daysBeforeController.text,
                                    time: selectedTime,
                                  ));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              child: state is SettingScheduledTimesLoading
                                  ? const CircularProgressIndicator()
                                  : Text(scheduleTimeModel == null
                                      ? "Save"
                                      : "Update"),
                            ),
                          ],
                        ),
                      ],
                    ).padXXDefault
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}
