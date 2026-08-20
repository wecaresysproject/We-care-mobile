import 'package:json_annotation/json_annotation.dart';

part 'doctor_profile_entries.g.dart';

/// عنصر فى قسم "التعليم والمؤهلات".
@JsonSerializable()
class DoctorQualificationModel {
  /// المؤهل — مثال: "بكالوريوس الطب والجراحة".
  final String title;

  /// الجهة التعليمية — مثال: "جامعة عين شمس".
  final String institution;

  final String country;

  /// سنة الحصول على المؤهل.
  final String year;

  const DoctorQualificationModel({
    required this.title,
    required this.institution,
    required this.country,
    required this.year,
  });

  factory DoctorQualificationModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorQualificationModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorQualificationModelToJson(this);
}

/// عنصر فى قسم "الدورات والشهادات المهنية".
@JsonSerializable()
class DoctorCertificateModel {
  final String title;

  /// الجهة المانحة.
  final String issuer;

  final String country;
  final String year;

  const DoctorCertificateModel({
    required this.title,
    required this.issuer,
    required this.country,
    required this.year,
  });

  factory DoctorCertificateModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorCertificateModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorCertificateModelToJson(this);
}

/// عنصر فى قسم "الجمعيات الطبية".
@JsonSerializable()
class DoctorMembershipModel {
  /// اسم الجمعية.
  final String association;

  /// نوع العضوية — مثال: "عضو عامل".
  final String membershipType;

  /// نطاق الجمعية — مثال: "مصر" أو "أوروبا".
  final String scope;

  /// سنة بداية العضوية.
  final String sinceYear;

  const DoctorMembershipModel({
    required this.association,
    required this.membershipType,
    required this.scope,
    required this.sinceYear,
  });

  factory DoctorMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorMembershipModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorMembershipModelToJson(this);
}

/// عنصر فى قسم "الأبحاث والرسائل العلمية".
@JsonSerializable()
class DoctorResearchModel {
  final String title;

  /// نوع العمل — مثال: "بحث علمى" أو "رسالة دكتوراه".
  final String type;

  final String year;

  /// نص زرار الفتح — مثال: "عرض البحث".
  final String actionLabel;

  /// رابط البحث — لو `null` الزرار مش بيتعرض.
  final String? url;

  const DoctorResearchModel({
    required this.title,
    required this.type,
    required this.year,
    required this.actionLabel,
    this.url,
  });

  factory DoctorResearchModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorResearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorResearchModelToJson(this);
}

/// عنصر فى قسم "الجوائز والتكريمات".
@JsonSerializable()
class DoctorAwardModel {
  final String title;

  /// الجهة المانحة.
  final String issuer;

  final String year;

  const DoctorAwardModel({
    required this.title,
    required this.issuer,
    required this.year,
  });

  factory DoctorAwardModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAwardModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorAwardModelToJson(this);
}

/// عنصر فى قسم "ميديا ومقالات".
@JsonSerializable()
class DoctorMediaModel {
  final String title;

  /// نوع المحتوى — مثال: "فيديو" أو "مقال طبى".
  final String type;

  /// المنصة — مثال: "YouTube". اختيارى.
  final String? platform;

  /// نص زرار الفتح — مثال: "مشاهدة الفيديو".
  final String actionLabel;

  /// رابط المحتوى — لو `null` الزرار مش بيتعرض.
  final String? url;

  const DoctorMediaModel({
    required this.title,
    required this.type,
    required this.actionLabel,
    this.platform,
    this.url,
  });

  factory DoctorMediaModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorMediaModelToJson(this);
}
