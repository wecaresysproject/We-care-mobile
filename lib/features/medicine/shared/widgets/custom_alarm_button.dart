import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/screens/edit_alarm.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';

class CustomAlarmButton extends StatefulWidget {
  final String containerHintText;
  const CustomAlarmButton({
    super.key,
    required this.containerHintText,
  });

  @override
  CustomAlarmButtonState createState() => CustomAlarmButtonState();
}

class CustomAlarmButtonState extends State<CustomAlarmButton> {
  String? _selectedTime;
  String? medicineName;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final cubit = context.read<MedicinesDataEntryCubit>();
        final repeatEvery =
            cubit.getRepeatDurationFromText(cubit.state.selectedNoOfDose!);
        final totalDuartion =
            cubit.getTotalDurationFromText(cubit.state.timePeriods!);
        medicineName = cubit.state.selectedMedicineName;
        //!handle null values here later
        await openAlarmBottomSheet(
          null,
          repeatEvery: repeatEvery!,
          totalDuration: totalDuartion!,
          medicineName: medicineName!,
        );
        // await context.pushNamed(Routes.alarmHomeView);
      },
      child: Container(
        width: double.infinity,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColorsManager.textfieldOutsideBorderColor,
            width: 0.8,
          ),
          color: AppColorsManager.textfieldInsideColor.withAlpha(100),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Row to include SVG icon and text
            Row(
              children: [
                Image.asset(
                  "assets/images/alarm_icon.png",
                  height: 28,
                  width: 28,
                  color: AppColorsManager.mainDarkBlue,
                ),
                Text(
                  _selectedTime ?? widget.containerHintText,
                  style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                    color: _selectedTime.isNotNull
                        ? AppColorsManager.textColor
                        : AppColorsManager.placeHolderColor,
                  ),
                ),
              ],
            ),

            IconButton(
              icon: Icon(
                Icons.delete,
                size: 28,
              ),
              onPressed: () async {
                await cancelAlarmsCreatedBeforePerMedicine(medicineName!);
              },
              color: AppColorsManager.mainDarkBlue,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openAlarmBottomSheet(
    AlarmSettings? settings, {
    required Duration repeatEvery,
    required Duration totalDuration,
    required String medicineName,
  }) async {
    String? selectedAlarmTime;
    final res = await showModalBottomSheet<bool?>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.85,
          child: AlarmEditScreen(
            alarmSettings: settings,
            onSave: (selectedDateTime) {
              selectedAlarmTime = selectedDateTime.toArabicTime();
            },
            repeatEvery: repeatEvery,
            totalDuration: totalDuration,
            medicineName: medicineName,
          ),
        );
      },
    );

    if (res != null && res == true && mounted) {
      await context.read<MedicinesDataEntryCubit>().loadAlarms();
      if (!mounted) return;
      context.read<MedicinesDataEntryCubit>().updateSelectedAlarmTime(
            selectedAlarmTime!,
          );
    }
  }

  Future<void> cancelAlarmsCreatedBeforePerMedicine(String medicineName) async {
    final alarmsId = getAlarmsForMedicine(medicineName);
    for (final id in alarmsId) {
      await Alarm.stop(id);
      log('xxx: cancelAlarmsCreatedBeforePerMedicine successfully');
    }
    await removeMedicineAlarms(medicineName);
    if (!mounted) return;
    context.read<MedicinesDataEntryCubit>().updateSelectedAlarmTime(
          "",
        );
  }

  List<int> getAlarmsForMedicine(String medicineName) {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    final medicineAlarms =
        List<MedicineAlarmModel>.from(box.get('medicines') ?? []);

    if (medicineAlarms.isEmpty) return [];

    try {
      final match = medicineAlarms.firstWhere(
        (m) => m.medicineName == medicineName,
      );
      return match.alarmId;
    } catch (e) {
      return [];
    }
  }

  Future<void> removeMedicineAlarms(String medicineName) async {
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    final alarms = List<MedicineAlarmModel>.from(box.get('medicines') ?? []);

    alarms.removeWhere((model) => model.medicineName == medicineName);

    await box.put('medicines', alarms);
    log('Removed alarms for $medicineName');
  }
}
