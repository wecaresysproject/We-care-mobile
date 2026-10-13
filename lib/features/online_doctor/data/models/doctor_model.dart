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

  /// بيحوّل رد `GET /OnlineDoctor/profile` المتقسّم لأقسام (`basicData`،
  /// `medicalSpecialty`، `booking`...) للشكل المسطّح اللى الـ UI بيستخدمه.
  factory DoctorModel.fromProfileJson(Map<String, dynamic> json) {
    final basicData = _mapOf(json['basicData']);
    final medicalSpecialty = _mapOf(json['medicalSpecialty']);
    final booking = _mapOf(json['booking']);
    final servicePrices = _mapOf(json['servicePrices']);
    final certificates = _mapOf(json['certificates']);
    final enabledDays = _listOfMaps(booking['weeklySchedule'])
        .where((day) => day['isEnabled'] == true)
        .toList();
    final nearestAppointment = booking['nearestAppointment'];

    return DoctorModel(
      id: _stringOf(json['doctorId']),
      name: _stringOf(json['fullName']),
      isFavorite: json['isFavorite'] as bool? ?? false,
      profileImage: _nullableStringOf(basicData['personalPhotoUrl']),
      isVerified: json['isVerified'] as bool? ?? false,
      isOnline: booking['isOnline'] as bool? ?? false,
      acceptsBookings: booking['acceptsBookings'] as bool? ?? false,
      specialty: _nullableStringOf(medicalSpecialty['mainSpecialtyName']) ??
          _stringOf(medicalSpecialty['mainSpecialty']),
      subSpecialty: _singleOrEmpty(medicalSpecialty['subSpecialty']),
      degree: _stringOf(basicData['academicDegree']),
      academicTitle: _stringOf(basicData['jobGrade']),
      hospital: '',
      location: DoctorLocationModel(
        country: _stringOf(basicData['country']),
        governorate: _stringOf(basicData['governorate']),
        city: _stringOf(basicData['city']),
      ),
      yearsOfExperience: (json['yearsOfExperience'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      likesCount: (json['likes'] as num?)?.toInt() ?? 0,
      commentsCount: (json['comments'] as num?)?.toInt() ?? 0,
      patientsCount: (json['patientsCount'] as num?)?.toInt() ?? 0,
      nearestAvailableAppointment: nearestAppointment is Map
          ? NearestAppointmentModel.fromJson(
              Map<String, dynamic>.from(nearestAppointment))
          : null,
      workingDays: enabledDays
          .map((day) =>
              _nullableStringOf(day['arabicDay']) ?? _stringOf(day['day']))
          .toList(),
      workingHours: enabledDays
          .expand((day) => _listOfMaps(day['timeRanges']))
          .map((range) =>
              "${_stringOf(range['startTime'])} - ${_stringOf(range['endTime'])}")
          .toSet()
          .toList(),
      consultationFee:
          (servicePrices['examinationPriceInsideEgypt'] as num?)?.toInt() ?? 0,
      about: _stringOf(basicData['shortBio']),
      medicalInterests: _singleOrEmpty(medicalSpecialty['clinicalInterests']),
      professionalExperience: _listOfMaps(json['experiences'])
          .map((e) => DoctorExperienceModel(
                position: _stringOf(e['position']),
                workplace: _stringOf(e['workPlace']),
                fromDate: _stringOf(e['fromDate']),
                toDate: _stringOf(e['toDate']),
                country: _stringOf(e['countryName']),
              ))
          .toList(),
      languages: (basicData['spokenLanguages'] as List? ?? const [])
          .map(_stringOf)
          .toList(),
      education: _degreeKeys
          .expand((key) => _listOfMaps(certificates[key]))
          .map((e) => DoctorQualificationModel(
                title: _stringOf(e['degreeTitle']),
                institution: _stringOf(e['grantingBody']),
                country: _stringOf(e['countryName']),
                year: _yearOf(_stringOf(e['obtainedDate'])),
              ))
          .toList(),
      medicalAssociations: _listOfMaps(json['memberships'])
          .map((e) => DoctorMembershipModel(
                association: _stringOf(e['associationName']),
                membershipLevel: _stringOf(e['membershipLevel']),
                membershipNumber: _nullableStringOf(e['membershipNumber']),
                year: _stringOf(e['year']),
              ))
          .toList(),
      research: _listOfMaps(json['researchPapers'])
          .map((e) => DoctorResearchModel(
                title: _stringOf(e['title']),
                type: '',
                year: _stringOf(e['year']),
                referenceUrl: _nullableStringOf(e['doiOrLink']),
              ))
          .toList(),
      awards: _listOfMaps(json['awards'])
          .map((e) => DoctorAwardModel(
                title: _stringOf(e['awardName']),
                issuer: _stringOf(e['grantingBody']),
                country: _nullableStringOf(e['countryName']),
                year: _stringOf(e['year']),
              ))
          .toList(),
      mediaAppearances: _listOfMaps(json['mediaArticles'])
          .map((e) => DoctorMediaModel(
                subject:
                    _nullableStringOf(e['title']) ?? _stringOf(e['subject']),
                type: '',
                url: _nullableStringOf(e['mediaLink']),
              ))
          .toList(),
    );
  }

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

/// مفاتيح الدرجات العلمية جوه `certificates` بترتيب عرضها.
const List<String> _degreeKeys = [
  'bachelor',
  'diploma',
  'master',
  'doctorate',
  'fellowship',
  'boardCertification',
];

Map<String, dynamic> _mapOf(dynamic value) =>
    value is Map ? Map<String, dynamic>.from(value) : const {};

List<Map<String, dynamic>> _listOfMaps(dynamic value) => value is List
    ? value.whereType<Map>().map(Map<String, dynamic>.from).toList()
    : const [];

String _stringOf(dynamic value) => value?.toString().trim() ?? '';

/// `null` لو القيمة مش موجودة أو فاضية.
String? _nullableStringOf(dynamic value) {
  final text = _stringOf(value);
  return text.isEmpty ? null : text;
}

List<String> _singleOrEmpty(dynamic value) {
  final text = _stringOf(value);
  return text.isEmpty ? const [] : [text];
}

String _yearOf(String date) => date.length >= 4 ? date.substring(0, 4) : date;
