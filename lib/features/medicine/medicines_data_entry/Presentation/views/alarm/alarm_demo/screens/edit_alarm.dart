import 'dart:developer';

import 'package:alarm/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/data/models/medicine_alarm_model.dart';
import 'package:we_care/features/medicine/medicines_api_constants.dart';

class AlarmEditScreen extends StatefulWidget {
  const AlarmEditScreen({
    super.key,
    this.alarmSettings,
    required this.onSave,
    required this.totalDuration,
    required this.repeatEvery,
    required this.medicineName,
  });

  final AlarmSettings? alarmSettings;
  final void Function(DateTime selectedDateTime) onSave;
  final Duration? totalDuration;
  final Duration? repeatEvery;
  final String? medicineName; //! we should handle it in case its null

  @override
  State<AlarmEditScreen> createState() => _AlarmEditScreenState();
}

class _AlarmEditScreenState extends State<AlarmEditScreen> {
  bool loading = false;

  late bool creating;
  late DateTime selectedDateTime;
  late bool loopAudio;
  late bool vibrate;
  late double? volume;
  late Duration? fadeDuration;
  late bool staircaseFade;
  late String assetAudio;

  /// lustral => 12 , 23 , 45 , etc...
  List<MedicineAlarmModel> alarmsPerMedicine = [];
  List<int> medicineAlarmIds = [];

  @override
  void initState() {
    super.initState();
    creating = widget.alarmSettings == null;

    if (creating) {
      selectedDateTime = DateTime.now().add(const Duration(minutes: 1));
      selectedDateTime = selectedDateTime.copyWith(second: 0, millisecond: 0);
      loopAudio = true;
      vibrate = true;
      volume = null;
      fadeDuration = null;
      staircaseFade = false;
      assetAudio = 'assets/alarm_sounds/marimba.mp3';
    } else {
      selectedDateTime = widget.alarmSettings!.dateTime;
      loopAudio = widget.alarmSettings!.loopAudio;
      vibrate = widget.alarmSettings!.vibrate;
      volume = widget.alarmSettings!.volumeSettings.volume;
      fadeDuration = widget.alarmSettings!.volumeSettings.fadeDuration;
      staircaseFade = widget.alarmSettings!.volumeSettings.fadeSteps.isNotEmpty;
      assetAudio = widget.alarmSettings!.assetAudioPath;
    }
  }

  String getDay() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = selectedDateTime.difference(today).inDays;

    switch (difference) {
      case 0:
        return 'Today';
      case 1:
        return 'Tomorrow';
      case 2:
        return 'After tomorrow';
      default:
        return 'In $difference days';
    }
  }

  Future<void> pickTime() async {
    final res = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      context: context,
    );

    if (res != null) {
      setState(() {
        final now = DateTime.now();
        selectedDateTime = now.copyWith(
          hour: res.hour,
          minute: res.minute,
          second: 0,
          millisecond: 0,
          microsecond: 0,
        );
        if (selectedDateTime.isBefore(now)) {
          selectedDateTime = selectedDateTime.add(const Duration(days: 1));
        }
      });
    }
  }

  AlarmSettings buildAlarmSettingsForTime(DateTime dateTime) {
    final id = DateTime.now().millisecondsSinceEpoch % 100000 +
        dateTime.millisecondsSinceEpoch % 10000;

    medicineAlarmIds.add(id);

    final medicineName = extractFirstMedicineName(widget.medicineName!);

    final VolumeSettings volumeSettings;
    if (staircaseFade) {
      volumeSettings = VolumeSettings.staircaseFade(
        volume: volume,
        fadeSteps: [
          VolumeFadeStep(Duration.zero, 0),
          VolumeFadeStep(const Duration(seconds: 15), 0.03),
          VolumeFadeStep(const Duration(seconds: 20), 0.5),
          VolumeFadeStep(const Duration(seconds: 30), 1),
        ],
      );
    } else if (fadeDuration != null) {
      volumeSettings = VolumeSettings.fade(
        volume: volume,
        fadeDuration: fadeDuration!,
      );
    } else {
      volumeSettings = VolumeSettings.fixed(volume: volume);
    }

    return AlarmSettings(
      id: id,
      dateTime: dateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      assetAudioPath: assetAudio,
      volumeSettings: volumeSettings,
      allowAlarmOverlap: true,
      warningNotificationOnKill: true,
      notificationSettings: NotificationSettings(
        title: 'تنيهة الدواء',
        body: "حان الان موعد تناول $medicineName",
        icon: 'notification_icon',
        stopButton: 'اوقف التنبيه',
      ),
    );
  }

  AlarmSettings buildAlarmSettings() {
    final id = creating
        ? DateTime.now().millisecondsSinceEpoch % 10000 + 1
        : widget.alarmSettings!.id;

    final medicineName = extractFirstMedicineName(widget.medicineName!);

    final VolumeSettings volumeSettings;
    if (staircaseFade) {
      volumeSettings = VolumeSettings.staircaseFade(
        volume: volume,
        fadeSteps: [
          VolumeFadeStep(Duration.zero, 0),
          VolumeFadeStep(const Duration(seconds: 15), 0.03),
          VolumeFadeStep(const Duration(seconds: 20), 0.5),
          VolumeFadeStep(const Duration(seconds: 30), 1),
        ],
      );
    } else if (fadeDuration != null) {
      volumeSettings = VolumeSettings.fade(
        volume: volume,
        fadeDuration: fadeDuration!,
      );
    } else {
      volumeSettings = VolumeSettings.fixed(volume: volume);
    }
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: selectedDateTime,
      loopAudio: loopAudio,
      vibrate: vibrate,
      assetAudioPath: assetAudio,
      volumeSettings: volumeSettings,
      allowAlarmOverlap: true,
      warningNotificationOnKill: true,
      notificationSettings: NotificationSettings(
        title: 'تنيهة الدواء',
        body: "حان الان موعد تناول $medicineName",
        icon: 'notification_icon',
        stopButton: 'اوقف التنبيه',
      ),
    );
    return alarmSettings;
  }

  Future<void> saveAlarm() async {
    await Alarm.stopAll();

    if (loading) return;
    setState(() => loading = true);

    // حدد البداية
    DateTime start = selectedDateTime;

    // اختار الريبيت (مثلا كل 8 ساعات)
    Duration? repeatEvery = widget.repeatEvery;

    // اختار المدة الكلية (مثلا لمدة أسبوع)
    Duration? totalDuration = widget.totalDuration;
    if (repeatEvery.isNull || totalDuration.isNull) {
      Alarm.set(alarmSettings: buildAlarmSettings()).then((res) {
        if (res && mounted) Navigator.pop(context, true);
        setState(() => loading = false);
      });
      return;
    }
    // ولد كل أوقات التنبيه
    final alarmTimes = generateAlarmTimes(
      start: start,
      repeatEvery: repeatEvery!,
      totalDuration: totalDuration!,
    );

    // احجز كل المنبهات
    for (var time in alarmTimes) {
      final settings = buildAlarmSettingsForTime(time);
      await Alarm.set(alarmSettings: settings);
    }

    await saveAlarmsCreatedPerMedicineInLocalStorage();

    if (mounted) {
      widget.onSave(selectedDateTime);
      Navigator.pop(context, true);
    }

    setState(() => loading = false);
  }

  Future<void> saveAlarmsCreatedPerMedicineInLocalStorage() async {
    alarmsPerMedicine.add(
      MedicineAlarmModel(
        alarmId: medicineAlarmIds,
        medicineName: widget.medicineName!,
      ),
    );
    final box = Hive.box<List<MedicineAlarmModel>>(
        MedicinesApiConstants.alarmsScheduledPerMedicineBoxKey);

    if (box.isEmpty) {
      await box.add(alarmsPerMedicine); // First time: use add
    } else {
      await box.putAt(0, alarmsPerMedicine); // Already exists: update
    }

    log('xxx: saveAlarmsCreatedPerMedicineInLocalStorage successfully with Hive');
  }

  void deleteAlarm() {
    Alarm.stop(widget.alarmSettings!.id).then((res) {
      if (res && mounted) Navigator.pop(context, true);
    });
  }

  List<DateTime> generateAlarmTimes({
    required DateTime start,
    required Duration repeatEvery,
    required Duration totalDuration,
  }) {
    List<DateTime> times = [];
    DateTime current = start;
    DateTime end = start.add(totalDuration);

    while (current.isBefore(end)) {
      times.add(current);
      current = current.add(repeatEvery);
    }

    return times;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.font22MainBlueWeight700.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await saveAlarm();
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : Text(
                        'Save',
                        style: AppTextStyles.font22MainBlueWeight700.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
          Text(
            getDay(),
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
          ),
          RawMaterialButton(
            onPressed: pickTime,
            fillColor: AppColorsManager.babyBlueColor,
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  24.r,
                ),
              ),
              child: Text(
                TimeOfDay.fromDateTime(selectedDateTime).format(context),
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                    ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Loop alarm audio',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: loopAudio,
                onChanged: (value) => setState(() => loopAudio = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vibrate',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: vibrate,
                onChanged: (value) => setState(() => vibrate = value),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sound',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton(
                value: assetAudio,
                items: const [
                  DropdownMenuItem<String>(
                    value: 'assets/alarm_sounds/marimba.mp3',
                    child: Text('Marimba'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/alarm_sounds/nokia.mp3',
                    child: Text('Nokia'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/alarm_sounds/mozart.mp3',
                    child: Text('Mozart'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/alarm_sounds/star_wars.mp3',
                    child: Text('Star Wars'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'assets/alarm_sounds/one_piece.mp3',
                    child: Text('One Piece'),
                  ),
                ],
                onChanged: (value) => setState(() => assetAudio = value!),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Custom volume',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: volume != null,
                onChanged: (value) =>
                    setState(() => volume = value ? 0.5 : null),
              ),
            ],
          ),
          if (volume != null)
            SizedBox(
              height: 45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    volume! > 0.7
                        ? Icons.volume_up_rounded
                        : volume! > 0.1
                            ? Icons.volume_down_rounded
                            : Icons.volume_mute_rounded,
                  ),
                  Expanded(
                    child: Slider(
                      value: volume!,
                      onChanged: (value) {
                        setState(() => volume = value);
                      },
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Fade duration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              DropdownButton<int>(
                value: fadeDuration?.inSeconds ?? 0,
                items: List.generate(
                  6,
                  (index) => DropdownMenuItem<int>(
                    value: index * 5,
                    child: Text('${index * 5}s'),
                  ),
                ),
                onChanged: (value) => setState(
                  () => fadeDuration =
                      value != null ? Duration(seconds: value) : null,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Staircase fade',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Switch(
                value: staircaseFade,
                onChanged: (value) => setState(() => staircaseFade = value),
              ),
            ],
          ),
          if (!creating)
            TextButton(
              onPressed: deleteAlarm,
              child: Text(
                'Delete Alarm',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Colors.red),
              ),
            ),
          const SizedBox(),
        ],
      ),
    );
  }
}
