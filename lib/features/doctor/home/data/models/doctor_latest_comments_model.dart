import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_comment_model.dart';

part 'doctor_latest_comments_model.g.dart';

/// Total comments count + the newest few — `GET /DoctorHome/latest-comments`.
@JsonSerializable(createToJson: false)
class DoctorLatestCommentsModel {
  DoctorLatestCommentsModel({
    required this.totalCount,
    required this.comments,
  });

  @JsonKey(defaultValue: 0)
  final int totalCount;
  @JsonKey(defaultValue: <DoctorCommentModel>[])
  final List<DoctorCommentModel> comments;

  factory DoctorLatestCommentsModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorLatestCommentsModelFromJson(json);
}
