import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_new_medicine_model.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class AddNewMedicineModel {
  @HiveField(0)
  final String medicineName; // اسم الدواء

  @HiveField(1)
  final String? startDate; // تاريخ بدء الدواء

  @HiveField(2)
  final String? medicalForm; // شكل الدواء (أقراص، شراب، ..)

  @HiveField(3)
  final String? dose; // الجرعة

  @HiveField(4)
  final String? numberOfDoses; // عدد الجرعات في اليوم

  AddNewMedicineModel({
    required this.medicineName,
    required this.startDate,
    required this.medicalForm,
    required this.dose,
    required this.numberOfDoses,
  });

  AddNewMedicineModel updateWith({
    String? medicineName,
    String? startDate,
    String? medicalForm,
    String? dose,
    String? numberOfDoses,
  }) {
    return AddNewMedicineModel(
      medicineName: medicineName ?? this.medicineName,
      startDate: startDate ?? this.startDate,
      medicalForm: medicalForm ?? this.medicalForm,
      dose: dose ?? this.dose,
      numberOfDoses: numberOfDoses ?? this.numberOfDoses,
    );
  }

  factory AddNewMedicineModel.fromJson(Map<String, dynamic> json) =>
      _$AddNewMedicineModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddNewMedicineModelToJson(this);
}
