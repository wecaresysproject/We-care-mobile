import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medical_complaint_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class MedicalComplaint {
  @HiveField(0)
  final String symptomsRegion; // الأعراض المرضية - المنطقة

  @HiveField(1)
  final String sypmptomsComplaintIssue; // الأعراض المرضية - الشكوى

  @HiveField(2)
  final String natureOfComplaint; // طبيعة الشكوى

  @HiveField(3)
  final String severityOfComplaint; // حدة الشكوى

  MedicalComplaint({
    required this.symptomsRegion,
    required this.sypmptomsComplaintIssue,
    required this.natureOfComplaint,
    required this.severityOfComplaint,
  });

  // JSON serialization
  Map<String, dynamic> toJson() => _$MedicalComplaintToJson(this);

  // JSON deserialization
  factory MedicalComplaint.fromJson(Map<String, dynamic> json) =>
      _$MedicalComplaintFromJson(json);
}
