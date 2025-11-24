import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

part 'medicine_data_entry_request_body.g.dart';

@JsonSerializable()
class MedicineDataEntryRequestBody {
  final String startDate;
  final String medicineName;
  final String usageMethod;
  final String dosage;
  final String dosageFrequency;
  final String usageDuration;
  final String timeDuration;
  final String chronicDiseaseMedicine;
  final String doctorName;
  final String reminder;
  @JsonKey(name: 'mainSymptoms')
  final List<MedicalComplaint> userMedicalComplaint;
  final bool reminderStatus;
  final String personalNotes;
  final String selectedDoseAmount;

  MedicineDataEntryRequestBody({
    required this.startDate,
    required this.medicineName,
    required this.usageMethod,
    required this.dosage,
    required this.dosageFrequency,
    required this.usageDuration,
    required this.timeDuration,
    required this.chronicDiseaseMedicine,
    required this.doctorName,
    required this.reminder,
    required this.reminderStatus,
    required this.personalNotes,
    required this.userMedicalComplaint,
    required this.selectedDoseAmount,
  });

  factory MedicineDataEntryRequestBody.fromJson(Map<String, dynamic> json) =>
      _$MedicineDataEntryRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$MedicineDataEntryRequestBodyToJson(this);
}
