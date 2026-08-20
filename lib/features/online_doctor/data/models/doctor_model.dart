import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_profile_entries.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_review_model.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class DoctorModel {
  final String name;

  /// التخصص الرئيسى بالعربى زى ما بيتعرض تحت اسم الطبيب.
  final String specialization;

  /// التخصص الدقيق — مثال: "جراحات الأنف والجيوب الأنفية".
  final String subSpecialization;

  /// الدرجة العلمية — "استشارى" أو "أخصائى".
  final String degree;

  /// الدرجة الوظيفية — مثال: "أستاذ مساعد".
  final String academicTitle;

  /// جهة العمل — مثال: "مستشفى عين شمس التخصصى".
  final String hospital;

  /// الطبيب موثّق من إدارة التطبيق.
  final bool isVerified;

  /// مكان الممارسة — مثال: "مصر - القاهرة".
  final String location;

  /// متوسط التقييم من 5 — مثال: 4.8.
  final double rating;

  final int likesCount;

  final int commentsCount;

  /// رابط صورة الطبيب — بيتعرض بـ `CachedNetworkImage`.
  final String imageUrl;

  final int yearsOfExperience;
  final int patientsCount;

  /// نبذة "تعرف على الطبيب".
  final String about;

  /// تكلفة الكشف بالجنيه.
  final int consultationFee;

  /// أيام العمل الأسبوعية — مثال: "الأحد - الثلاثاء - الخميس".
  final String workingDays;

  /// ساعات العمل — مثال: "من 9:00 ص - 2:00 م".
  final String workingHours;

  /// التخصص والاهتمامات الطبية.
  final List<String> medicalInterests;

  /// الخبرة المهنية.
  final List<String> professionalExperience;

  /// اللغات اللى الطبيب بيتكلمها.
  final List<String> languages;

  /// التعليم والمؤهلات.
  final List<DoctorQualificationModel> education;

  /// الدورات والشهادات المهنية.
  final List<DoctorCertificateModel> certificates;

  /// الجمعيات الطبية.
  final List<DoctorMembershipModel> medicalAssociations;

  /// الأبحاث والرسائل العلمية.
  final List<DoctorResearchModel> research;

  /// الجوائز والتكريمات.
  final List<DoctorAwardModel> awards;

  /// ميديا ومقالات.
  final List<DoctorMediaModel> mediaAppearances;

  /// الطبيب متاح أون لاين دلوقتى ولا لأ.
  final bool isOnline;

  /// بيقبل حجوزات حاليًا ولا لأ.
  final bool isAcceptingBookings;

  /// أقرب موعد متاح — مثال: "الأحد 26 مايو".
  final String nearestAppointmentDate;

  /// ميعاد أقرب موعد متاح — مثال: "10:30".
  final String nearestAppointmentTime;

  /// الفترة — "صباحاً" أو "مساءً".
  final String nearestAppointmentPeriod;

  final List<DoctorReviewModel> reviews;

  const DoctorModel({
    required this.name,
    required this.specialization,
    required this.subSpecialization,
    required this.degree,
    required this.academicTitle,
    required this.hospital,
    required this.isVerified,
    required this.location,
    required this.rating,
    required this.likesCount,
    required this.commentsCount,
    required this.imageUrl,
    required this.yearsOfExperience,
    required this.patientsCount,
    required this.about,
    required this.consultationFee,
    required this.workingDays,
    required this.workingHours,
    required this.medicalInterests,
    required this.professionalExperience,
    required this.languages,
    required this.education,
    required this.certificates,
    required this.medicalAssociations,
    required this.research,
    required this.awards,
    required this.mediaAppearances,
    required this.isOnline,
    required this.isAcceptingBookings,
    required this.nearestAppointmentDate,
    required this.nearestAppointmentTime,
    required this.nearestAppointmentPeriod,
    required this.reviews,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);
}
