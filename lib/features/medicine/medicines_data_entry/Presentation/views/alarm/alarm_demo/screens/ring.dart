import 'dart:async';

import 'package:alarm/alarm.dart';
import 'package:alarm/utils/alarm_set.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class MedicineAlarmRingingScreen extends StatefulWidget {
  const MedicineAlarmRingingScreen({required this.alarmSettings, super.key});

  final AlarmSettings alarmSettings;

  @override
  State<MedicineAlarmRingingScreen> createState() =>
      _MedicineAlarmRingingScreenState();
}

class _MedicineAlarmRingingScreenState
    extends State<MedicineAlarmRingingScreen> {
  static final _log = Logger('ExampleAlarmRingScreenState');

  StreamSubscription<AlarmSet>? _ringingSubscription;

  @override
  void initState() {
    super.initState();
    _ringingSubscription = Alarm.ringing.listen((alarms) {
      if (alarms.containsId(widget.alarmSettings.id)) return;
      _log.info('Alarm ${widget.alarmSettings.id} stopped ringing.');
      _ringingSubscription?.cancel();
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    _ringingSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'You alarm (${widget.alarmSettings.id}) is ringing...',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const Text('🔔', style: TextStyle(fontSize: 50)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                RawMaterialButton(
                  onPressed: () async => Alarm.set(
                    alarmSettings: widget.alarmSettings.copyWith(
                      dateTime: DateTime.now().add(const Duration(minutes: 1)),
                    ),
                  ),
                  child: Text(
                    'Snooze',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                RawMaterialButton(
                  onPressed: () async => Alarm.stop(widget.alarmSettings.id),
                  child: Text(
                    'Stop',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
