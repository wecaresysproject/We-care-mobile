import 'package:equatable/equatable.dart';

/// One medicine row in the doctor's prescription.
class PrescriptionMedicineModel extends Equatable {
  const PrescriptionMedicineModel({
    this.medicineId,
    required this.name,
    required this.medicalForm,
    required this.doseAmount,
    required this.doseFrequency,
    required this.duration,
    this.instructions = '',
  });

  factory PrescriptionMedicineModel.fromJson(Map<String, dynamic> json) {
    final medicineId = json['medicineId']?.toString() ?? '';
    return PrescriptionMedicineModel(
      medicineId: medicineId.isEmpty ? null : medicineId,
      name: json['name']?.toString() ?? '',
      medicalForm: json['medicalForm']?.toString() ?? '',
      doseAmount: json['doseAmount']?.toString() ?? '',
      doseFrequency: json['doseFrequency']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      instructions: json['instructions']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'medicineId': medicineId,
        'name': name,
        'medicalForm': medicalForm,
        'doseAmount': doseAmount,
        'doseFrequency': doseFrequency,
        'duration': duration,
        'instructions': instructions,
      };

  /// Null when the doctor typed a name that isn't in the medicines list.
  final String? medicineId;

  /// اسم الدواء
  final String name;

  /// طريقة الاستخدام (الشكل الدوائي)
  final String medicalForm;

  /// كمية الدواء
  final String doseAmount;

  /// عدد مرات الجرعة
  final String doseFrequency;

  /// مدة الاستخدام — free text written by the doctor.
  final String duration;

  /// تعليمات — optional free text, empty when not written.
  final String instructions;

  @override
  List<Object?> get props => [
        medicineId,
        name,
        medicalForm,
        doseAmount,
        doseFrequency,
        duration,
        instructions,
      ];
}
