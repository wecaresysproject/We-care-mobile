import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_profile_entries.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_review_model.dart';
import 'package:we_care/features/online_doctor/data/models/nearest_appointment_model.dart';

//! بيانات وهمية مؤقتة — قايمة الأطباء وملف الطبيب بقوا من الـ API،
//! ودى فاضلة بس لفلو الحجوزات (`doctorFromBookingInfo`) لحد ما endpoints
//! الحجوزات تجهز. الأسماء والتقييمات والصور مش حقيقية — الصور من randomuser.me.

const List<String> _doctorNames = [
  "د/ أحمد محمود مصطفى",
  "د/ عمر حازم محمد",
  "د/ عبدالرحمن عمر أشرف",
  "د/ محمد سيد عبدالله",
  "د/ كريم ياسر إبراهيم",
  "د/ مصطفى علاء الدين",
  "د/ طارق حسن فؤاد",
  "د/ زياد أيمن سليم",
  "د/ هشام رضا صابر",
  "د/ وليد سمير نبيل",
];

const List<String> _degrees = ["استشارى", "أخصائى"];

const List<String> _academicTitles = [
  "أستاذ مساعد",
  "أخصائى",
  "رئيس قسم",
  "ممارس",
  "استشارى",
];

const List<double> _ratings = [
  4.5,
  4.3,
  4.8,
  4.1,
  4.8,
  4.7,
  4.2,
  4.6,
  4.9,
  4.4
];

const List<int> _likesCounts = [15, 24, 18, 30, 20, 20, 12, 32, 28, 16];

const List<int> _commentsCounts = [50, 80, 50, 120, 95, 95, 40, 32, 110, 35];

const List<NearestAppointmentModel> _nearestAppointments = [
  NearestAppointmentModel(date: "2026-05-26", time: "10:30"),
  NearestAppointmentModel(date: "2026-05-27", time: "14:00"),
  NearestAppointmentModel(date: "2026-05-29", time: "11:00"),
  NearestAppointmentModel(date: "2026-05-25", time: "09:00"),
  NearestAppointmentModel(date: "2026-05-31", time: "16:30"),
];

const List<int> _yearsOfExperience = [8, 12, 15, 6, 10, 20, 9, 7, 18, 11];

const List<int> _patientsCounts = [
  150,
  320,
  480,
  90,
  210,
  600,
  175,
  130,
  540,
  260
];

const List<int> _consultationFees = [
  500,
  350,
  700,
  300,
  450,
  800,
  400,
  250,
  650,
  550
];

const List<List<String>> _workingDays = [
  ["الأحد", "الثلاثاء", "الخميس"],
  ["السبت", "الاثنين", "الأربعاء"],
  ["الأحد", "الأربعاء"],
];

const List<List<String>> _workingHours = [
  ["09:00 - 14:00"],
  ["10:00 - 15:00"],
  ["16:00 - 21:00"],
];

const List<DoctorLocationModel> _locations = [
  DoctorLocationModel(country: "مصر", city: "القاهرة"),
  DoctorLocationModel(country: "مصر", city: "الجيزة"),
  DoctorLocationModel(country: "مصر", city: "الإسكندرية"),
];

const List<String> _hospitals = [
  "مستشفى عين شمس التخصصى",
  "مستشفى السلام الدولى",
  "مستشفى القصر العينى",
  "مركز ديرما التخصصى",
  "مستشفى دار الفؤاد",
];

const List<String> _universities = [
  "جامعة القاهرة",
  "جامعة عين شمس",
  "جامعة الإسكندرية",
];

const List<String> _reviewerNames = [
  "مصطفى عبدالله",
  "ندى كمال",
  "عمر حازم",
  "سارة محمود",
  "أحمد فتحى",
];

const List<String> _reviewComments = [
  "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك أن تولد مثل هذا النص أو العديد",
  "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص",
  "هذا النص هو مثال لنص يمكن أن يستبدل في نفس المساحة، لقد تم توليد هذا النص من مولد النص العربي، حيث يمكنك أن تولد مثل هذا النص أو العديد",
];

const List<String> _doctorImageUrls = [
  "https://randomuser.me/api/portraits/men/32.jpg",
  "https://randomuser.me/api/portraits/men/45.jpg",
  "https://randomuser.me/api/portraits/men/52.jpg",
  "https://randomuser.me/api/portraits/men/64.jpg",
  "https://randomuser.me/api/portraits/men/75.jpg",
  "https://randomuser.me/api/portraits/men/83.jpg",
  "https://randomuser.me/api/portraits/men/91.jpg",
  "https://randomuser.me/api/portraits/men/12.jpg",
  "https://randomuser.me/api/portraits/men/22.jpg",
  "https://randomuser.me/api/portraits/men/36.jpg",
];

/// رقم ثابت مشتق من اسم التخصص — عشان كل تخصص يطلع قايمة أطباء مختلفة
/// بس تفضل هى هى فى كل مرة تفتح فيها الشاشة.
int _seedFor(String specialization) =>
    specialization.codeUnits.fold(0, (sum, unit) => sum + unit);

String _aboutText(int position, String specialization) {
  final university = _universities[position % _universities.length];
  final hospital = _hospitals[position % _hospitals.length];
  final academicTitle = _academicTitles[position % _academicTitles.length];
  return "${_degrees[position % _degrees.length]} $specialization "
      "والجراحات الدقيقة المرتبطة بيها. "
      "$academicTitle بـ$university. "
      "خبرة واسعة فى تشخيص وعلاج أمراض $specialization ومتابعة الحالات المزمنة، "
      "ويعمل حاليًا بـ$hospital.";
}

const List<List<String>> _languagesOptions = [
  ["العربية", "الإنجليزية"],
  ["العربية", "الإنجليزية", "الفرنسية"],
  ["العربية", "الإنجليزية", "الألمانية"],
];

/// سنة تخرج تقديرية مبنية على سنين الخبرة — باقى السنين بتتحسب منها.
int _graduationYear(int position) => 2024 - _yearsOfExperience[position] - 5;

List<DoctorQualificationModel> _qualifications(
  int position,
  String specialization,
) {
  final university = _universities[position % _universities.length];
  final graduation = _graduationYear(position);

  return [
    DoctorQualificationModel(
      title: "بكالوريوس الطب والجراحة",
      institution: university,
      country: "مصر",
      year: "$graduation",
    ),
    DoctorQualificationModel(
      title: "ماجستير فى $specialization",
      institution: university,
      country: "مصر",
      year: "${graduation + 5}",
    ),
    DoctorQualificationModel(
      title: "دكتوراه فى $specialization",
      institution: university,
      country: "مصر",
      year: "${graduation + 9}",
    ),
    DoctorQualificationModel(
      title: "زمالة فى $specialization",
      institution: "Royal College",
      country: "المملكة المتحدة",
      year: "${graduation + 12}",
    ),
  ];
}

List<DoctorCertificateModel> _certificates(
  int position,
  String specialization,
) {
  final graduation = _graduationYear(position);

  return [
    DoctorCertificateModel(
      title: "شهادة تخصصية فى ${_subSpecialization(specialization)}",
      issuer: "الأكاديمية الطبية للتعليم المستمر",
      country: "مصر",
      year: "${graduation + 7}",
    ),
    DoctorCertificateModel(
      title: "دورة متقدمة فى الجراحات بالمنظار",
      issuer: "المعهد الأوروبى للتدريب الطبى",
      country: "ألمانيا",
      year: "${graduation + 10}",
    ),
  ];
}

List<DoctorMembershipModel> _medicalAssociations(
  int position,
  String specialization,
) {
  final graduation = _graduationYear(position);

  return [
    DoctorMembershipModel(
      association: "الجمعية المصرية لـ$specialization",
      membershipLevel: "عضو عامل",
      membershipNumber: "EG-${1000 + position}",
      year: "${graduation + 6}",
    ),
    DoctorMembershipModel(
      association: "الجمعية الأوروبية لـ$specialization",
      membershipLevel: "عضو دولى",
      year: "${graduation + 12}",
    ),
  ];
}

List<DoctorResearchModel> _research(int position, String specialization) {
  final graduation = _graduationYear(position);
  final subSpecialization = _subSpecialization(specialization);

  return [
    DoctorResearchModel(
      title: "تأثير $subSpecialization على جودة الحياة",
      type: "بحث علمى",
      year: "${graduation + 16}",
      referenceUrl: "https://scholar.google.com",
    ),
    DoctorResearchModel(
      title: "رسالة دكتوراه: نتائج $subSpecialization",
      type: "رسالة علمية",
      year: "${graduation + 9}",
      referenceUrl: "https://scholar.google.com",
    ),
  ];
}

List<DoctorAwardModel> _awards(int position, String specialization) {
  final university = _universities[position % _universities.length];
  final graduation = _graduationYear(position);

  return [
    DoctorAwardModel(
      title: "جائزة أفضل بحث فى $specialization",
      issuer: university,
      country: "مصر",
      year: "${graduation + 15}",
    ),
    DoctorAwardModel(
      title: "شهادة تقدير للتميز الأكاديمى والمهنى",
      issuer: university,
      country: "مصر",
      year: "${graduation + 13}",
    ),
  ];
}

List<DoctorMediaModel> _mediaAppearances(String specialization) {
  return [
    DoctorMediaModel(
      subject: "نصائح للوقاية من أمراض $specialization",
      type: "فيديو",
      url: "https://www.youtube.com",
    ),
    DoctorMediaModel(
      subject: "متى تحتاج إلى ${_subSpecialization(specialization)}؟",
      type: "مقال",
      url: "https://www.who.int",
    ),
  ];
}

/// التخصص الدقيق لكل تخصص رئيسى — وللتخصصات اللى مش فى القايمة بيتولد نص عام.
const Map<String, String> _subSpecializations = {
  "أنف وأذن وحنجرة": "جراحات الأنف والجيوب الأنفية",
  "جلدية": "الأمراض الجلدية المناعية والتجميل",
  "نساء وتوليد": "الحمل عالى الخطورة والولادة القيصرية",
  "أطفال": "حديثى الولادة والرعاية المركزة",
  "عظام": "جراحات المفاصل والإصابات الرياضية",
  "قلب وأوعية دموية": "قسطرة القلب والشرايين التاجية",
  "مخ وأعصاب": "جراحات العمود الفقرى والأعصاب الطرفية",
  "مسالك بولية": "مناظير المسالك وتفتيت الحصوات",
  "عيون": "جراحات المياه البيضاء وتصحيح الإبصار",
  "أسنان": "زراعة الأسنان وتجميلها",
  "باطنة": "الجهاز الهضمى والكبد",
};

String _subSpecialization(String specialization) =>
    _subSpecializations[specialization] ??
    "الحالات الدقيقة والجراحات المتخصصة فى $specialization";

List<String> _medicalInterests(String specialization) => [
      "تشخيص وعلاج أمراض $specialization",
      "الجراحات الدقيقة والتدخلات المحدودة",
      "المتابعة الدورية للحالات المزمنة",
      "الحالات الطارئة والتدخل السريع",
      "خطط العلاج طويلة المدى",
    ];

List<DoctorExperienceModel> _professionalExperience(
  int position,
  String specialization,
) {
  final graduation = _graduationYear(position);

  return [
    DoctorExperienceModel(
      position: "طبيب مقيم $specialization",
      workplace: _hospitals[position % _hospitals.length],
      fromDate: "$graduation-01-01",
      toDate: "${graduation + 4}-12-31",
      country: "مصر",
    ),
    DoctorExperienceModel(
      position: "أخصائى $specialization",
      workplace: _hospitals[(position + 1) % _hospitals.length],
      fromDate: "${graduation + 5}-01-01",
      toDate: "${graduation + 11}-12-31",
      country: "مصر",
    ),
    DoctorExperienceModel(
      position: "${_degrees[position % _degrees.length]} $specialization",
      workplace: _hospitals[(position + 2) % _hospitals.length],
      fromDate: "${graduation + 12}-01-01",
      country: "مصر",
    ),
  ];
}

List<DoctorReviewModel> _reviewsFor(int position) {
  return List.generate(3, (index) {
    final reviewerIndex = (position + index) % _reviewerNames.length;
    return DoctorReviewModel(
      patientName: _reviewerNames[reviewerIndex],
      comment: _reviewComments[index % _reviewComments.length],
    );
  });
}

/// بيحوّل "مصر - القاهرة" المخزنة مع الحجز لموديل المكان.
DoctorLocationModel _locationFromLabel(String label) {
  final parts = label
      .split(" - ")
      .map((part) => part.trim())
      .where((part) => part.isNotEmpty)
      .toList();
  return DoctorLocationModel(
    country: parts.isNotEmpty ? parts.first : "",
    city: parts.length > 1 ? parts.last : "",
  );
}

DoctorModel _buildDoctor(int position, String specialization) {
  //* الأطباء غير المتاحين أون لاين هما نفسهم اللى مش بيقبلوا حجوزات دلوقتى.
  final isOnline = position % 3 != 2;

  return DoctorModel(
    id: "dummy-doctor-$position",
    name: _doctorNames[position],
    specialty: specialization,
    subSpecialty: [_subSpecialization(specialization)],
    degree: _degrees[position % _degrees.length],
    academicTitle: _academicTitles[position % _academicTitles.length],
    hospital: _hospitals[position % _hospitals.length],
    isVerified: position % 4 != 3,
    location: _locations[position % _locations.length],
    rating: _ratings[position],
    likesCount: _likesCounts[position],
    commentsCount: _commentsCounts[position],
    profileImage: _doctorImageUrls[position],
    yearsOfExperience: _yearsOfExperience[position],
    patientsCount: _patientsCounts[position],
    about: _aboutText(position, specialization),
    consultationFee: _consultationFees[position],
    workingDays: _workingDays[position % _workingDays.length],
    workingHours: _workingHours[position % _workingHours.length],
    medicalInterests: _medicalInterests(specialization),
    professionalExperience: _professionalExperience(position, specialization),
    languages: _languagesOptions[position % _languagesOptions.length],
    education: _qualifications(position, specialization),
    certificates: _certificates(position, specialization),
    medicalAssociations: _medicalAssociations(position, specialization),
    research: _research(position, specialization),
    awards: _awards(position, specialization),
    mediaAppearances: _mediaAppearances(specialization),
    isOnline: isOnline,
    acceptsBookings: isOnline,
    nearestAvailableAppointment:
        _nearestAppointments[position % _nearestAppointments.length],
    reviews: _reviewsFor(position),
  );
}

/// بيبنى موديل طبيب كامل من الملخص المخزن مع الحجز — عشان زرار
/// "حجز موعد جديد مع الطبيب" فى تفاصيل السجل يفتح فلو الحجز
/// لنفس الطبيب مباشرة من غير ما يعدى على البحث.
/// البيانات المعروضة فى الكارت بتيجى من الحجز نفسه، والتفاصيل الناقصة
/// بتتولد بنفس منطق البيانات الوهمية لحد ما endpoints الحجوزات تجهز.
DoctorModel doctorFromBookingInfo(
  BookingDoctorInfo info, {
  int? consultationFee,
  double? rating,
  int? commentsCount,
}) {
  final position = _seedFor(info.name) % _doctorNames.length;
  final specialization = info.specialization;

  return DoctorModel(
    id: "dummy-booking-doctor-$position",
    name: info.name,
    specialty: specialization,
    subSpecialty: [_subSpecialization(specialization)],
    degree: _degrees[position % _degrees.length],
    academicTitle: info.academicTitle,
    hospital: info.hospital,
    isVerified: true,
    location: _locationFromLabel(info.location),
    rating: rating ?? _ratings[position],
    likesCount: _likesCounts[position],
    commentsCount: commentsCount ?? _commentsCounts[position],
    profileImage: info.imageUrl,
    yearsOfExperience: _yearsOfExperience[position],
    patientsCount: _patientsCounts[position],
    about: _aboutText(position, specialization),
    consultationFee: consultationFee ?? _consultationFees[position],
    workingDays: _workingDays[position % _workingDays.length],
    workingHours: _workingHours[position % _workingHours.length],
    medicalInterests: _medicalInterests(specialization),
    professionalExperience: _professionalExperience(position, specialization),
    languages: _languagesOptions[position % _languagesOptions.length],
    education: _qualifications(position, specialization),
    certificates: _certificates(position, specialization),
    medicalAssociations: _medicalAssociations(position, specialization),
    research: _research(position, specialization),
    awards: _awards(position, specialization),
    mediaAppearances: _mediaAppearances(specialization),
    isOnline: info.isOnline,
    acceptsBookings: true,
    nearestAvailableAppointment:
        _nearestAppointments[position % _nearestAppointments.length],
    reviews: _reviewsFor(position),
  );
}

/// بترجّع قايمة أطباء وهمية للتخصص المطلوب — قايمة الأطباء الحقيقية بقت
/// من الـ API، ودى فاضلة للاختبارات المحلية بس.
List<DoctorModel> doctorsForSpecialization(String specialization) {
  final normalizedSpecialization = specialization.replaceAll('\n', ' ');
  final seed = _seedFor(normalizedSpecialization);

  return List.generate(6, (index) {
    final position = (seed + index) % _doctorNames.length;
    return _buildDoctor(position, normalizedSpecialization);
  });
}
