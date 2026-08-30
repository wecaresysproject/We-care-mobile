/// تخصصات الأطباء المعروضة فى شاشة "البحث عن طبيب".
///
/// قايمة مستقلة بالكامل عن موديولز الملف الطبي (`dataEntryCategories`) —
/// دى تخصصات طبية للبحث عن طبيب، مش أقسام لتسجيل بيانات.
/// الصور مأخوذة من الـ assets الموجودة فى المشروع.
///
/// `identifierName` هو المفتاح اللى بيتبعت للـ API فى `?specialty=` —
/// الاسم العربى للعرض بس ومينفعش يتبعت (راجع `docs/api/online_doctor_api.md`).
///
/// الترتيب مقصود: من الأكثر شيوعًا للأقل شيوعًا — متغيّرش ترتيب العناصر.
final List<Map<String, dynamic>> doctorSpecializations = [
  {
    "title": "باطنة",
    "identifierName": "internalMedicine",
    "image": "assets/images/digestive_icon.png",
  },
  {
    "title": "جلدية",
    "identifierName": "dermatology",
    "image": "assets/images/hand_icon.png",
  },
  {
    "title": "أطفال",
    "identifierName": "pediatrics",
    "image": "assets/images/baby_icon.png",
  },
  {
    "title": "كبد وجهاز\nهضمي",
    "identifierName": "gastroenterology",
    "image": "assets/images/liver_icon.png",
  },
  {
    "title": "نساء وتوليد",
    "identifierName": "obstetricsGynecology",
    "image": "assets/images/pergenant_woman.png",
  },
  {
    "title": "تجميل وجراحة\nتجميل",
    "identifierName": "plasticSurgery",
    "image": "assets/images/woman.png",
  },
  {
    "title": "تخسيس\n(علاج السمنة)",
    "identifierName": "obesityTreatment",
    "image": "assets/images/BMI.png",
  },
  {
    "title": "تغذية علاجية",
    "identifierName": "clinicalNutrition",
    "image": "assets/images/nutration_speciliazation.png",
  },
  {
    "title": "سكر وغدد\nصماء",
    "identifierName": "endocrinology",
    "image": "assets/images/diabetes_and_metabolism.png",
  },
  {
    "title": "أمراض نفسية\nوعصبية",
    "identifierName": "psychiatry",
    "image": "assets/images/mental_health.png",
  },
  {
    "title": "عقم وحقن\nمجهري",
    "identifierName": "infertility",
    "image": "assets/images/reproductive_icon.png",
  },
  {
    "title": "أنف وأذن\nوحنجرة",
    "identifierName": "ent",
    "image": "assets/images/ear_and_nose_specialization.png",
  },
  {
    "title": "مسالك بولية",
    "identifierName": "urology",
    "image": "assets/images/kidney_icon.png",
  },
  {
    //! مفيش أيقونة تخاطب/نطق فى المشروع — دى مؤقتة لحد ما تتوفر صورة.
    "title": "تخاطب ونطق",
    "identifierName": "speechTherapy",
    "image": "assets/images/Chat.png",
  },
  {
    "title": "عيون",
    "identifierName": "ophthalmology",
    "image": "assets/images/eye_module_pic.png",
  },
  {
    "title": "قلب وأوعية\nدموية",
    "identifierName": "cardiology",
    "image": "assets/images/cardiology_speciliazation.png",
  },
  {
    "title": "مخ وأعصاب",
    "identifierName": "neurology",
    "image": "assets/images/neurology.png",
  },
  {
    "title": "حميات وأمراض\nمعدية",
    "identifierName": "infectiousDiseases",
    "image": "assets/images/temperature_level.png",
  },
  {
    "title": "أمراض الصدرية",
    "identifierName": "pulmonology",
    "image": "assets/images/respiratory_specialization.png",
  },
  {
    "title": "عظام",
    "identifierName": "orthopedics",
    "image": "assets/images/foot_bones.png",
  },
  {
    "title": "أسنان",
    "identifierName": "dentistry",
    "image": "assets/images/teeth_icon.png",
  },
  {
    "title": "روماتيزم\nومفاصل",
    "identifierName": "rheumatology",
    "image": "assets/images/bones_icon.png",
  },
  {
    "title": "جراحة أوعية\nدموية",
    "identifierName": "vascularSurgery",
    "image": "assets/images/heart_organ_icon.png",
  },
  {
    "title": "حساسية ومناعة",
    "identifierName": "allergyImmunology",
    "image": "assets/images/immune_icon.png",
  },
  {
    "title": "أورام",
    "identifierName": "oncology",
    "image": "assets/images/tumor_icon.png",
  },
  {
    "title": "جراحة عامة",
    "identifierName": "generalSurgery",
    "image": "assets/images/surgery_icon.png",
  },
  {
    "title": "كلى",
    "identifierName": "nephrology",
    "image": "assets/images/kidney_wash.png",
  },
  {
    //! نفس أيقونة "أطفال" مؤقتًا — مفيش أيقونة جراحة أطفال مخصصة.
    "title": "جراحة أطفال",
    "identifierName": "pediatricSurgery",
    "image": "assets/images/baby_icon.png",
  },
  {
    "title": "أمراض الدم",
    "identifierName": "hematology",
    "image": "assets/images/blood_icon.png",
  },
  {
    "title": "علاج طبيعي\nوتأهيل",
    "identifierName": "physiotherapy",
    "image": "assets/images/physical_therapy.png",
  },
  {
    //! مفيش أيقونة طب مسنين فى المشروع — دى مؤقتة لحد ما تتوفر صورة.
    "title": "طب المسنين",
    "identifierName": "geriatrics",
    "image": "assets/images/patient.png",
  },
  {
    "title": "طب الرياضة\nواصابات الملاعب",
    "identifierName": "sportsMedicine",
    "image": "assets/images/man_running.png",
  },
];

/// بترجّع صورة التخصص المطابقة للاسم، أو `null` لو التخصص مش فى القايمة.
///
/// الأسماء فى القايمة فيها سطر جديد للعرض، عشان كده بنقارن بعد تنظيفه.
String? doctorSpecializationImage(String specialization) {
  final normalized = specialization.replaceAll('\n', ' ').trim();
  for (final item in doctorSpecializations) {
    if ((item["title"] as String).replaceAll('\n', ' ').trim() == normalized) {
      return item["image"] as String;
    }
  }
  return null;
}
