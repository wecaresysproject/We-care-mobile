import 'package:hive/hive.dart';

part 'medicine_alarm_model.g.dart';

@HiveType(typeId: 1)
class MedicineAlarmModel {
  @HiveField(0)
  List<int> alarmId;
  @HiveField(1)
  String medicineName;

  MedicineAlarmModel({required this.alarmId, required this.medicineName});
}
