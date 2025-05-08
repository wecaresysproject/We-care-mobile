import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'medical_complaint_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class MedicalComplaint {
  @HiveField(0)
  @JsonKey(name: 'symptoms_LocationOfPainOrComplaint')
  final String symptomsRegion; // الأعراض المرضية - المنطقة
  @HiveField(1)
  @JsonKey(name: 'partOfPlaceOfComplaints')
  final String partOrOrganOfComplaints; //الأعراض المرضية - الجزء أو العضو
  @HiveField(2)
  @JsonKey(name: 'symptoms_Complaint')
  final String sypmptomsComplaintIssue; // الأعراض المرضية - الشكوى

  @HiveField(3)
  final String natureOfComplaint; // طبيعة الشكوى

  @HiveField(4)
  final String severityOfComplaint; // حدة الشكوى

  MedicalComplaint({
    required this.symptomsRegion,
    required this.sypmptomsComplaintIssue,
    required this.natureOfComplaint,
    required this.severityOfComplaint,
    required this.partOrOrganOfComplaints,
  });

  // JSON serialization
  Map<String, dynamic> toJson() => _$MedicalComplaintToJson(this);

  // JSON deserialization
  factory MedicalComplaint.fromJson(Map<String, dynamic> json) =>
      _$MedicalComplaintFromJson(json);

  MedicalComplaint updateWith({
    String? symptomsRegion,
    String? sypmptomsComplaintIssue,
    String? natureOfComplaint,
    String? severityOfComplaint,
    String? partOrOrganOfComplaints,
  }) {
    return MedicalComplaint(
      symptomsRegion: symptomsRegion ?? this.symptomsRegion,
      sypmptomsComplaintIssue:
          sypmptomsComplaintIssue ?? this.sypmptomsComplaintIssue,
      natureOfComplaint: natureOfComplaint ?? this.natureOfComplaint,
      severityOfComplaint: severityOfComplaint ?? this.severityOfComplaint,
      partOrOrganOfComplaints:
          partOrOrganOfComplaints ?? this.partOrOrganOfComplaints,
    );
  }
}
