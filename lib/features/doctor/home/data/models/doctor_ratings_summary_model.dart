import 'package:json_annotation/json_annotation.dart';

part 'doctor_ratings_summary_model.g.dart';

/// Raters count + average rating (0–5) — `GET /DoctorHome/ratings-summary`.
@JsonSerializable(createToJson: false)
class DoctorRatingsSummaryModel {
  DoctorRatingsSummaryModel({
    required this.ratingsCount,
    required this.averageRating,
  });

  @JsonKey(defaultValue: 0)
  final int ratingsCount;

  /// May arrive as an int (e.g. `0`), hence `num` → `double`.
  @JsonKey(fromJson: _parseAverage)
  final double averageRating;

  factory DoctorRatingsSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorRatingsSummaryModelFromJson(json);
}

double _parseAverage(Object? value) =>
    value is num ? value.toDouble().clamp(0, 5).toDouble() : 0;
