import 'package:json_annotation/json_annotation.dart';

part 'doctor_profile_entries.g.dart';

/// مكان ممارسة الطبيب زى ما بيرجع من الـ API — الدولة والمحافظة والمدينة.
@JsonSerializable()
class DoctorLocationModel {
  final String country;

  final String governorate;

  final String city;

  const DoctorLocationModel({
    this.country = '',
    this.governorate = '',
    this.city = '',
  });

  factory DoctorLocationModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorLocationModelToJson(this);

  /// "مصر - القاهرة" — الأجزاء الفاضية أو المتكررة بتتشال.
  String get label {
    final parts = <String>[];
    for (final part in [country, governorate, city]) {
      final trimmed = part.trim();
      if (trimmed.isNotEmpty && !parts.contains(trimmed)) parts.add(trimmed);
    }
    return parts.join(" - ");
  }
}

/// عنصر فى قسم "الخبرة المهنية".
@JsonSerializable()
class DoctorExperienceModel {
  /// الوظيفة — مثال: "أخصائي أمراض القلب".
  @JsonKey(defaultValue: '')
  final String position;

  @JsonKey(defaultValue: '')
  final String workplace;

  /// `YYYY-MM-DD`.
  final String fromDate;

  /// `YYYY-MM-DD` — فاضى لو لسه شغال هناك.
  final String toDate;

  final String country;

  const DoctorExperienceModel({
    required this.position,
    required this.workplace,
    this.fromDate = '',
    this.toDate = '',
    this.country = '',
  });

  factory DoctorExperienceModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorExperienceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorExperienceModelToJson(this);

  /// "2007 - 2014" أو "2014 - حتى الآن" — فاضى لو مفيش تواريخ.
  String get periodLabel {
    final from = _yearOf(fromDate);
    final to = _yearOf(toDate);
    if (from.isEmpty && to.isEmpty) return '';
    return "$from - ${to.isEmpty ? 'حتى الآن' : to}";
  }

  /// "استشاري أمراض القلب — مستشفى دار الفؤاد (2014 - حتى الآن)".
  String get label {
    final headline = [position, workplace]
        .where((part) => part.trim().isNotEmpty)
        .join(" — ");
    final period = periodLabel;
    return period.isEmpty ? headline : "$headline ($period)";
  }
}

String _yearOf(String date) =>
    date.length >= 4 ? date.substring(0, 4) : date.trim();

/// عنصر فى قسم "التعليم والمؤهلات".
@JsonSerializable()
class DoctorQualificationModel {
  /// المؤهل — مثال: "بكالوريوس الطب والجراحة".
  final String title;

  /// الجهة التعليمية — مثال: "جامعة عين شمس".
  @JsonKey(defaultValue: '')
  final String institution;

  @JsonKey(defaultValue: '')
  final String country;

  /// سنة الحصول على المؤهل.
  @JsonKey(defaultValue: '')
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
  @JsonKey(defaultValue: '')
  final String issuer;

  @JsonKey(defaultValue: '')
  final String country;

  @JsonKey(defaultValue: '')
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

  /// مستوى العضوية — مثال: "عضو عامل".
  @JsonKey(defaultValue: '')
  final String membershipLevel;

  /// رقم العضوية — اختيارى.
  final String? membershipNumber;

  /// سنة بداية العضوية.
  @JsonKey(defaultValue: '')
  final String year;

  const DoctorMembershipModel({
    required this.association,
    required this.membershipLevel,
    required this.year,
    this.membershipNumber,
  });

  factory DoctorMembershipModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorMembershipModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorMembershipModelToJson(this);
}

/// عنصر فى قسم "الأبحاث والرسائل العلمية".
@JsonSerializable()
class DoctorResearchModel {
  final String title;

  /// نوع العمل — مثال: "بحث علمي" أو "رسالة علمية".
  @JsonKey(defaultValue: '')
  final String type;

  @JsonKey(defaultValue: '')
  final String year;

  /// رابط البحث — لو `null` زرار العرض مش بيتعرض.
  final String? referenceUrl;

  final String? doi;
  final String? pubmedId;

  const DoctorResearchModel({
    required this.title,
    required this.type,
    required this.year,
    this.referenceUrl,
    this.doi,
    this.pubmedId,
  });

  factory DoctorResearchModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorResearchModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorResearchModelToJson(this);

  /// نص زرار الفتح حسب نوع العمل.
  String get actionLabel =>
      type.contains("رسالة") ? "عرض الرسالة" : "عرض البحث";
}

/// عنصر فى قسم "الجوائز والتكريمات".
@JsonSerializable()
class DoctorAwardModel {
  final String title;

  /// الجهة المانحة.
  @JsonKey(defaultValue: '')
  final String issuer;

  final String? country;

  @JsonKey(defaultValue: '')
  final String year;

  /// رابط الجائزة — لو `null` زرار العرض مش بيتعرض.
  final String? referenceUrl;

  const DoctorAwardModel({
    required this.title,
    required this.issuer,
    required this.year,
    this.country,
    this.referenceUrl,
  });

  factory DoctorAwardModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorAwardModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorAwardModelToJson(this);
}

/// عنصر فى قسم "ميديا ومقالات".
@JsonSerializable()
class DoctorMediaModel {
  /// موضوع المحتوى — بيتعرض كعنوان.
  final String subject;

  /// نوع المحتوى — مثال: "فيديو" أو "مقال".
  @JsonKey(defaultValue: '')
  final String type;

  /// رابط المحتوى — لو `null` الزرار مش بيتعرض.
  final String? url;

  const DoctorMediaModel({
    required this.subject,
    required this.type,
    this.url,
  });

  factory DoctorMediaModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorMediaModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorMediaModelToJson(this);

  /// نص زرار الفتح حسب نوع المحتوى.
  String get actionLabel =>
      type.contains("فيديو") ? "مشاهدة الفيديو" : "قراءة المقال";
}

/// عيادة أو مستشفى/مركز بيكشف فيه الطبيب — `name` بيرجع للمستشفيات والمراكز بس.
///
/// بيرجع من endpoint البروفايل فى `clinics[]` و`hospitalsCenters[]` —
/// لسه مش معروض فى الـ UI.
@JsonSerializable()
class DoctorPracticeLocationModel {
  final String? name;

  final String address;

  final String phone;

  final int consultationFee;

  final List<String> workingDays;

  final String workingHours;

  final String? googleMap;

  const DoctorPracticeLocationModel({
    this.name,
    this.address = '',
    this.phone = '',
    this.consultationFee = 0,
    this.workingDays = const [],
    this.workingHours = '',
    this.googleMap,
  });

  factory DoctorPracticeLocationModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorPracticeLocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorPracticeLocationModelToJson(this);
}
