import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_profile_entries.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_review_model.dart';
import 'package:we_care/features/online_doctor/data/models/nearest_appointment_model.dart';

part 'doctor_model.g.dart';

/// ملف الطبيب الكامل زى ما بيرجع من `GET /OnlineDoctor/profile?doctorId=` —
/// بيتعرض فى شاشة "ملف الطبيب" وبيتبعت لفلو الحجز.
@JsonSerializable()
class DoctorModel {
  final String id;
  final String name;

  /// رابط صورة الطبيب — `null` لو مفيش صورة.
  final String? profileImage;

  /// الطبيب موثّق من إدارة التطبيق.
  @JsonKey(defaultValue: false)
  final bool isVerified;

  /// المستخدم الحالى مضيف الطبيب للمفضلة.
  final bool isFavorite;

  /// الطبيب متاح أون لاين دلوقتى ولا لأ.
  @JsonKey(defaultValue: false)
  final bool isOnline;

  /// بيقبل حجوزات حاليًا ولا لأ.
  @JsonKey(defaultValue: false)
  final bool acceptsBookings;

  /// التخصص الرئيسى بالعربى زى ما بيتعرض تحت اسم الطبيب — مثال: "أمراض القلب".
  @JsonKey(defaultValue: '')
  final String specialty;

  /// التخصصات الدقيقة — مثال: ["القسطرة القلبية", "كهرباء القلب"].
  final List<String> subSpecialty;

  /// الدرجة العلمية — "استشارى" أو "أخصائى".
  @JsonKey(defaultValue: '')
  final String degree;

  /// الدرجة الوظيفية — مثال: "أستاذ مساعد".
  @JsonKey(defaultValue: '')
  final String academicTitle;

  /// جهة العمل — مثال: "مستشفى عين شمس التخصصى".
  @JsonKey(defaultValue: '')
  final String hospital;

  /// مكان الممارسة — `null` لو مش متسجل.
  final DoctorLocationModel? location;

  @JsonKey(defaultValue: 0)
  final int yearsOfExperience;

  /// متوسط التقييم من 5 — مثال: 4.8.
  @JsonKey(defaultValue: 0.0)
  final double rating;

  @JsonKey(defaultValue: 0)
  final int likesCount;

  @JsonKey(defaultValue: 0)
  final int commentsCount;

  @JsonKey(defaultValue: 0)
  final int patientsCount;

  /// أقرب موعد متاح — `null` لو مفيش.
  final NearestAppointmentModel? nearestAvailableAppointment;

  /// أيام العمل الأسبوعية — مثال: ["السبت", "الثلاثاء"].
  final List<String> workingDays;

  /// فترات العمل — مثال: ["17:00 - 21:00", "16:00 - 20:00"].
  final List<String> workingHours;

  /// تكلفة الكشف بالجنيه.
  @JsonKey(defaultValue: 0)
  final int consultationFee;

  /// نبذة "تعرف على الطبيب".
  @JsonKey(defaultValue: '')
  final String about;

  /// التخصص والاهتمامات الطبية.
  final List<String> medicalInterests;

  /// الخبرة المهنية.
  final List<DoctorExperienceModel> professionalExperience;

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

  final List<DoctorReviewModel> reviews;

  /// العيادات الخاصة — لسه مش معروضة فى الـ UI.
  final List<DoctorPracticeLocationModel> clinics;

  /// المستشفيات والمراكز — لسه مش معروضة فى الـ UI.
  final List<DoctorPracticeLocationModel> hospitalsCenters;

  const DoctorModel({
    required this.id,
    required this.name,
    required this.specialty,
    required this.degree,
    required this.academicTitle,
    required this.hospital,
    required this.isVerified,
    required this.isOnline,
    required this.acceptsBookings,
    required this.rating,
    required this.likesCount,
    required this.commentsCount,
    required this.yearsOfExperience,
    required this.patientsCount,
    required this.consultationFee,
    required this.about,
    this.profileImage,
    this.isFavorite = false,
    this.subSpecialty = const [],
    this.location,
    this.nearestAvailableAppointment,
    this.workingDays = const [],
    this.workingHours = const [],
    this.medicalInterests = const [],
    this.professionalExperience = const [],
    this.languages = const [],
    this.education = const [],
    this.certificates = const [],
    this.medicalAssociations = const [],
    this.research = const [],
    this.awards = const [],
    this.mediaAppearances = const [],
    this.reviews = const [],
    this.clinics = const [],
    this.hospitalsCenters = const [],
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);

  /// رابط الصورة للـ `CachedNetworkImage` — فاضى لو مفيش صورة عشان يعرض البديل.
  String get imageUrl => profileImage ?? '';

  /// "مصر - القاهرة" — فاضى لو المكان مش متسجل.
  String get locationLabel => location?.label ?? '';

  /// التخصصات الدقيقة فى سطر واحد.
  String get subSpecialtyLabel => subSpecialty.join(" - ");

  /// "السبت - الثلاثاء - الأحد".
  String get workingDaysLabel => workingDays.join(" - ");

  /// "17:00 - 21:00 / 16:00 - 20:00".
  String get workingHoursLabel => workingHours.join(" / ");
}
