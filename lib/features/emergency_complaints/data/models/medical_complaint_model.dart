import 'package:json_annotation/json_annotation.dart';

part 'medical_complaint_model.g.dart';

@JsonSerializable()
class MedicalComplaint {
  final String symptomsRegion; // الأعراض المرضية - المنطقة

  final String sypmptomsComplaintIssue; // الأعراض المرضية - الشكوى

  final String natureOfComplaint; // طبيعة الشكوى

  final String severityOfComplaint; // حدة الشكوى

  MedicalComplaint({
    required this.symptomsRegion,
    required this.sypmptomsComplaintIssue,
    required this.natureOfComplaint,
    required this.severityOfComplaint,
  });

  Map<String, dynamic> toJson() => _$MedicalComplaintToJson(this);
}
