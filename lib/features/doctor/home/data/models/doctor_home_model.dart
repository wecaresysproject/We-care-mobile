import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_comment_model.dart';
import 'package:we_care/features/doctor/home/data/models/doctor_performance_metric_model.dart';

part 'doctor_home_model.g.dart';

@JsonSerializable()
class DoctorHomeModel {
  DoctorHomeModel({
    required this.doctorName,
    required this.specialty,
    required this.doctorPhotoUrl,
    required this.clinicLogoUrl,
    required this.waitingCount,
    required this.followUpsCount,
    required this.currentBookingsCount,
    required this.allowedBookingsCount,
    required this.dataCompletionPercentage,
    required this.achievedExaminationsCount,
    required this.monthlyTargetExaminationsCount,
    required this.yearlyTargetExaminationsCount,
    required this.appearances,
    required this.shares,
    required this.watches,
    required this.adBannerImageUrls,
    required this.commentsCount,
    required this.comments,
    required this.ratingsCount,
  });

  final String doctorName;
  final String specialty;
  final String doctorPhotoUrl;
  final String clinicLogoUrl;

  final int waitingCount;
  final int followUpsCount;
  final int currentBookingsCount;
  final int allowedBookingsCount;

  final int dataCompletionPercentage;
  final int achievedExaminationsCount;
  final int monthlyTargetExaminationsCount;
  final int yearlyTargetExaminationsCount;

  final DoctorPerformanceMetricModel appearances;
  final DoctorPerformanceMetricModel shares;
  final DoctorPerformanceMetricModel watches;

  final List<String> adBannerImageUrls;

  final int commentsCount;
  final List<DoctorCommentModel> comments;
  final int ratingsCount;

  factory DoctorHomeModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorHomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorHomeModelToJson(this);
}
