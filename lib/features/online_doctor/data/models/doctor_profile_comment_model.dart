/// A patient's comment shown in the doctor profile's "التعليقات" section —
/// from `latestComments` in `GET /OnlineDoctor/profile` and from
/// `GET /OnlineDoctor/comments` (المزيد).
class DoctorProfileCommentModel {
  const DoctorProfileCommentModel({
    required this.id,
    required this.patientName,
    required this.comment,
    required this.createdAt,
  });

  final String id;
  final String patientName;
  final String comment;

  /// When the comment was written, in device time. `null` when the API sends
  /// no / an invalid date — the row then hides the date.
  final DateTime? createdAt;

  factory DoctorProfileCommentModel.fromJson(Map<String, dynamic> json) {
    final createdAt = json['createdAt'];
    return DoctorProfileCommentModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patientName']?.toString().trim() ?? '',
      comment: json['comment']?.toString().trim() ?? '',
      createdAt:
          createdAt is String ? DateTime.tryParse(createdAt)?.toLocal() : null,
    );
  }

  /// Parses a JSON list, skipping entries that aren't objects or have no text.
  static List<DoctorProfileCommentModel> listFromJson(Object? value) =>
      (value is List ? value : const [])
          .whereType<Map>()
          .map((e) =>
              DoctorProfileCommentModel.fromJson(Map<String, dynamic>.from(e)))
          .where((comment) => comment.comment.isNotEmpty)
          .toList();
}

/// One page of `GET /OnlineDoctor/comments`.
class DoctorCommentsPageModel {
  const DoctorCommentsPageModel({
    required this.totalCount,
    required this.comments,
  });

  final int totalCount;
  final List<DoctorProfileCommentModel> comments;

  factory DoctorCommentsPageModel.fromJson(Map<String, dynamic> json) =>
      DoctorCommentsPageModel(
        totalCount: (json['totalCount'] as num?)?.toInt() ?? 0,
        comments: DoctorProfileCommentModel.listFromJson(json['comments']),
      );
}
