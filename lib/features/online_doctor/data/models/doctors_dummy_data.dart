import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_model.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_profile_entries.dart';
import 'package:we_care/features/online_doctor/data/models/doctor_review_model.dart';

//! بيانات وهمية مؤقتة لحد ما endpoint البحث عن طبيب يجهز.
//! الأسماء والتقييمات والصور مش حقيقية — الصور من randomuser.me.

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

const List<String> _nearestAppointmentDates = [
  "الأحد 26 مايو",
  "الإثنين 27 مايو",
  "الأربعاء 29 مايو",
  "غدا 25 مايو",
  "الجمعة 31 مايو",
];

const List<String> _nearestAppointmentTimes = [
  "10:30",
  "02:00",
  "11:00",
  "09:00",
  "04:30",
];

const List<String> _nearestAppointmentPeriods = [
  "صباحاً",
  "مساءً",
  "صباحاً",
  "صباحاً",
  "مساءً",
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

const List<String> _workingDays = [
  "الأحد - الثلاثاء - الخميس",
  "السبت - الاثنين - الأربعاء",
  "الأحد - الأربعاء",
];

const List<String> _workingHours = [
  "من 9:00 ص - 2:00 م",
  "من 10:00 ص - 3:00 م",
  "من 4:00 م - 9:00 م",
];

const List<String> _locations = [
  "مصر - القاهرة",
  "مصر - الجيزة",
  "مصر - الإسكندرية",
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
      membershipType: "عضو عامل",
      scope: "مصر",
      sinceYear: "${graduation + 6}",
    ),
    DoctorMembershipModel(
      association: "الجمعية الأوروبية لـ$specialization",
      membershipType: "عضو دولى",
      scope: "أوروبا",
      sinceYear: "${graduation + 12}",
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
      actionLabel: "عرض البحث",
      url: "https://scholar.google.com",
    ),
    DoctorResearchModel(
      title: "رسالة دكتوراه: نتائج $subSpecialization",
      type: "رسالة دكتوراه",
      year: "${graduation + 9}",
      actionLabel: "عرض الرسالة",
      url: "https://scholar.google.com",
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
      year: "${graduation + 15}",
    ),
    DoctorAwardModel(
      title: "شهادة تقدير للتميز الأكاديمى والمهنى",
      issuer: university,
      year: "${graduation + 13}",
    ),
  ];
}

List<DoctorMediaModel> _mediaAppearances(String specialization) {
  return [
    DoctorMediaModel(
      title: "نصائح للوقاية من أمراض $specialization",
      type: "فيديو",
      platform: "YouTube",
      actionLabel: "مشاهدة الفيديو",
      url: "https://www.youtube.com",
    ),
    DoctorMediaModel(
      title: "متى تحتاج إلى ${_subSpecialization(specialization)}؟",
      type: "مقال طبى",
      actionLabel: "قراءة المقال",
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

List<String> _professionalExperience(int position, String specialization) => [
      "${_yearsOfExperience[position]} أعوام خبرة فى $specialization",
      "أكثر من ${_patientsCounts[position]} حالة تمت متابعتها",
      "استشارى زائر بـ${_hospitals[(position + 1) % _hospitals.length]}",
    ];

List<DoctorReviewModel> _reviewsFor(int position) {
  return List.generate(3, (index) {
    final reviewerIndex = (position + index) % _reviewerNames.length;
    return DoctorReviewModel(
      patientName: _reviewerNames[reviewerIndex],
      comment: _reviewComments[index % _reviewComments.length],
    );
  });
}

DoctorModel _buildDoctor(int position, String specialization) {
  //* الأطباء غير المتاحين أون لاين هما نفسهم اللى مش بيقبلوا حجوزات دلوقتى.
  final isOnline = position % 3 != 2;

  return DoctorModel(
    name: _doctorNames[position],
    specialization: specialization,
    subSpecialization: _subSpecialization(specialization),
    degree: _degrees[position % _degrees.length],
    academicTitle: _academicTitles[position % _academicTitles.length],
    hospital: _hospitals[position % _hospitals.length],
    isVerified: position % 4 != 3,
    location: _locations[position % _locations.length],
    rating: _ratings[position],
    likesCount: _likesCounts[position],
    commentsCount: _commentsCounts[position],
    imageUrl: _doctorImageUrls[position],
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
    isAcceptingBookings: isOnline,
    nearestAppointmentDate:
        _nearestAppointmentDates[position % _nearestAppointmentDates.length],
    nearestAppointmentTime:
        _nearestAppointmentTimes[position % _nearestAppointmentTimes.length],
    nearestAppointmentPeriod: _nearestAppointmentPeriods[
        position % _nearestAppointmentPeriods.length],
    reviews: _reviewsFor(position),
  );
}

/// بيبنى موديل طبيب كامل من الملخص المخزن مع الحجز — عشان زرار
/// "حجز موعد جديد مع الطبيب" فى تفاصيل السجل يفتح فلو الحجز
/// لنفس الطبيب مباشرة من غير ما يعدى على البحث.
/// البيانات المعروضة فى الكارت بتيجى من الحجز نفسه، والتفاصيل الناقصة
/// بتتولد بنفس منطق البيانات الوهمية لحد ما الـ API يجهز.
DoctorModel doctorFromBookingInfo(
  BookingDoctorInfo info, {
  int? consultationFee,
  double? rating,
  int? commentsCount,
}) {
  final position = _seedFor(info.name) % _doctorNames.length;
  final specialization = info.specialization;

  return DoctorModel(
    name: info.name,
    specialization: specialization,
    subSpecialization: _subSpecialization(specialization),
    degree: _degrees[position % _degrees.length],
    academicTitle: info.academicTitle,
    hospital: info.hospital,
    isVerified: true,
    location: info.location,
    rating: rating ?? _ratings[position],
    likesCount: _likesCounts[position],
    commentsCount: commentsCount ?? _commentsCounts[position],
    imageUrl: info.imageUrl,
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
    isAcceptingBookings: true,
    nearestAppointmentDate:
        _nearestAppointmentDates[position % _nearestAppointmentDates.length],
    nearestAppointmentTime:
        _nearestAppointmentTimes[position % _nearestAppointmentTimes.length],
    nearestAppointmentPeriod: _nearestAppointmentPeriods[
        position % _nearestAppointmentPeriods.length],
    reviews: _reviewsFor(position),
  );
}

/// بترجّع قايمة أطباء وهمية للتخصص المطلوب.
List<DoctorModel> doctorsForSpecialization(String specialization) {
  final normalizedSpecialization = specialization.replaceAll('\n', ' ');
  final seed = _seedFor(normalizedSpecialization);

  return List.generate(6, (index) {
    final position = (seed + index) % _doctorNames.length;
    return _buildDoctor(position, normalizedSpecialization);
  });
}
