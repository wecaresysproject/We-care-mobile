import 'package:json_annotation/json_annotation.dart';

part 'doctor_profile_summary_model.g.dart';

/// Home header data — `GET /DoctorHome/profile-summary`. Cached on the device
/// so the header shows instantly on later launches.
@JsonSerializable()
class DoctorProfileSummaryModel {
  DoctorProfileSummaryModel({
    required this.name,
    required this.specialty,
    this.profileImage,
  });

  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String specialty;
  final String? profileImage;

  /// The name as shown in the header, with the `د/` prefix the API omits.
  /// Checks for the full prefix (not just `د`) so names that start with the
  /// letter, like داليا, still get it.
  String get displayName =>
      name.startsWith('د/') || name.startsWith('د.') ? name : 'د/$name';

  factory DoctorProfileSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorProfileSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorProfileSummaryModelToJson(this);
}
