import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/screens/edit_alarm.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/screens/ring.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/screens/shortcut_button.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/notifications.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/services/permission.dart';
import 'package:we_care/features/medicine/medicines_data_entry/Presentation/views/alarm/alarm_demo/widgets/tile.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  List<AlarmSettings> alarms = [];
  Notifications? notifications;

  static StreamSubscription<AlarmSet>? ringSubscription;
  static StreamSubscription<AlarmSet>? updateSubscription;

  @override
  void initState() {
    super.initState();
    AlarmPermissions.checkNotificationPermission().then(
      (_) => AlarmPermissions.checkAndroidScheduleExactAlarmPermission(),
    );
    unawaited(loadAlarms());
    ringSubscription ??= Alarm.ringing.listen(onAlarmRingingChanged);
    updateSubscription ??= Alarm.scheduled.listen(
      (_) {
        unawaited(loadAlarms());
      },
    );
    notifications = Notifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   shadowColor: Colors.black,
      //   actions: [
      //     PopupMenuButton<String>(
      //       iconColor: Colors.black,
      //       clipBehavior: Clip.hardEdge,
      //       onSelected: notifications == null
      //           ? null
      //           : (value) async {
      //               if (value == 'Show notification') {
      //                 await notifications?.showNotification();
      //               } else if (value == 'Schedule notification') {
      //                 await notifications?.scheduleNotification();
      //               }
      //             },
      //       itemBuilder: (BuildContext context) =>
      //           {'Show notification', 'Schedule notification'}
      //               .map(
      //                 (String choice) => PopupMenuItem<String>(
      //                   value: choice,
      //                   child: Text(choice),
      //                 ),
      //               )
      //               .toList(),
      //     ),
      //   ],
      // ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: alarms.isNotEmpty
                  ? ListView.separated(
                      itemCount: alarms.length,
                      separatorBuilder: (context, index) =>
                          const Divider(height: 1),
                      itemBuilder: (context, index) {
                        return ExampleAlarmTile(
                          key: Key(alarms[index].id.toString()),
                          title: TimeOfDay(
                            hour: alarms[index].dateTime.hour,
                            minute: alarms[index].dateTime.minute,
                          ).format(context),
                          onPressed: () => openAlarmBottomSheet(
                            alarms[index],
                          ),
                          onDismissed: () async {
                            await Alarm.stop(alarms[index].id);
                            await loadAlarms();
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'لا يوجد موعد محدد مسبق لهذا للدواء',
                        softWrap: true,
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: Colors.black,
                                  fontSize: 20.sp,
                                ),
                      ),
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ExampleAlarmHomeShortcutButton(refreshAlarms: loadAlarms),
            FloatingActionButton(
              onPressed: () async {
                await Alarm.stopAll();
              },
              backgroundColor: Colors.red,
              heroTag: null,
              child: Text(
                'STOP ALL',
                textScaler: TextScaler.linear(0.8),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            FloatingActionButton(
              onPressed: () async {
                await openAlarmBottomSheet(null);
              },
              child: const Icon(
                Icons.alarm_add_rounded,
                size: 33,
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> loadAlarms() async {
    final updatedAlarms = await Alarm.getAlarms();
    updatedAlarms.sort((a, b) => a.dateTime.isBefore(b.dateTime) ? 0 : 1);
    setState(
      () {
        alarms = updatedAlarms;
      },
    );
  }

  ///called immediately after the alarm rings
  Future<void> onAlarmRingingChanged(AlarmSet alarms) async {
    if (alarms.alarms.isEmpty) return;
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => MedicineAlarmRingingScreen(
          alarmSettings: alarms.alarms.first,
        ),
      ),
    );
    unawaited(loadAlarms());
  }

  Future<void> openAlarmBottomSheet(AlarmSettings? settings) async {
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
            onSave: (selectedDateTime) {},
            totalDuration: Duration(),
            repeatEvery: Duration(),
            medicineName: '',
          ),
        );
      },
    );

    if (res != null && res == true) unawaited(loadAlarms());
  }

  @override
  void dispose() {
    ringSubscription?.cancel();
    updateSubscription?.cancel();
    super.dispose();
  }
}
