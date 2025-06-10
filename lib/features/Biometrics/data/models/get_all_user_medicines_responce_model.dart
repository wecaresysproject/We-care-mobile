import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/emergency_complaints/data/models/medical_complaint_model.dart';

part 'get_all_user_medicines_responce_model.g.dart';

@JsonSerializable()
class GetAllUserMedicinesResponseModel {
  bool success;
  String message;
  @JsonKey(name: 'data')
  List<MedicineModel> medicineList;

  GetAllUserMedicinesResponseModel({
    required this.success,
    required this.message,
    required this.medicineList,
  });

  factory GetAllUserMedicinesResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$GetAllUserMedicinesResponseModelFromJson(json);
}

@JsonSerializable()
class MedicineModel {
  String id;
  String startDate;
  String medicineName;
  String usageMethod;
  String dosage;
  String dosageFrequency;
  String usageDuration;
  String timeDuration;
  String chronicDiseaseMedicine;
  List<MedicalComplaint> mainSymptoms;
  String doctorName;
  String reminder;
  bool reminderStatus;
  String personalNotes;
  String userId;
  String modifiedAt;

  MedicineModel({
    required this.id,
    required this.startDate,
    required this.medicineName,
    required this.usageMethod,
    required this.dosage,
    required this.dosageFrequency,
    required this.usageDuration,
    required this.timeDuration,
    required this.chronicDiseaseMedicine,
    required this.mainSymptoms,
    required this.doctorName,
    required this.reminder,
    required this.reminderStatus,
    required this.personalNotes,
    required this.userId,
    required this.modifiedAt,
  });
  factory MedicineModel.fromJson(Map<String, dynamic> json) =>
      _$MedicineModelFromJson(json);
}
