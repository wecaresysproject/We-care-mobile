/// تخصصات الأطباء المعروضة فى شاشة "البحث عن طبيب".
///
/// قايمة مستقلة بالكامل عن موديولز الملف الطبي (`dataEntryCategories`) —
/// دى تخصصات طبية للبحث عن طبيب، مش أقسام لتسجيل بيانات.
/// الصور مأخوذة من الـ assets الموجودة فى المشروع.
///
/// الترتيب مقصود: من الأكثر شيوعًا للأقل شيوعًا — متغيّرش ترتيب العناصر.
final List<Map<String, dynamic>> doctorSpecializations = [
  {
    "title": "باطنة",
    "image": "assets/images/digestive_icon.png",
  },
  {
    "title": "جلدية",
    "image": "assets/images/hand_icon.png",
  },
  {
    "title": "أطفال",
    "image": "assets/images/baby_icon.png",
  },
  {
    "title": "كبد وجهاز\nهضمي",
    "image": "assets/images/liver_icon.png",
  },
  {
    "title": "نساء وتوليد",
    "image": "assets/images/pergenant_woman.png",
  },
  {
    "title": "تجميل وجراحة\nتجميل",
    "image": "assets/images/woman.png",
  },
  {
    "title": "تخسيس\n(علاج السمنة)",
    "image": "assets/images/BMI.png",
  },
  {
    "title": "تغذية علاجية",
    "image": "assets/images/nutration_speciliazation.png",
  },
  {
    "title": "سكر وغدد\nصماء",
    "image": "assets/images/diabetes_and_metabolism.png",
  },
  {
    "title": "أمراض نفسية\nوعصبية",
    "image": "assets/images/mental_health.png",
  },
  {
    "title": "عقم وحقن\nمجهري",
    "image": "assets/images/reproductive_icon.png",
  },
  {
    "title": "أنف وأذن\nوحنجرة",
    "image": "assets/images/ear_and_nose_specialization.png",
  },
  {
    "title": "مسالك بولية",
    "image": "assets/images/kidney_icon.png",
  },
  {
    //! مفيش أيقونة تخاطب/نطق فى المشروع — دى مؤقتة لحد ما تتوفر صورة.
    "title": "تخاطب ونطق",
    "image": "assets/images/Chat.png",
  },
  {
    "title": "عيون",
    "image": "assets/images/eye_module_pic.png",
  },
  {
    "title": "قلب وأوعية\nدموية",
    "image": "assets/images/cardiology_speciliazation.png",
  },
  {
    "title": "مخ وأعصاب",
    "image": "assets/images/neurology.png",
  },
  {
    "title": "حميات وأمراض\nمعدية",
    "image": "assets/images/temperature_level.png",
  },
  {
    "title": "أمراض الصدرية",
    "image": "assets/images/respiratory_specialization.png",
  },
  {
    "title": "عظام",
    "image": "assets/images/foot_bones.png",
  },
  {
    "title": "أسنان",
    "image": "assets/images/teeth_icon.png",
  },
  {
    "title": "روماتيزم\nومفاصل",
    "image": "assets/images/bones_icon.png",
  },
  {
    "title": "جراحة أوعية\nدموية",
    "image": "assets/images/heart_organ_icon.png",
  },
  {
    "title": "حساسية ومناعة",
    "image": "assets/images/immune_icon.png",
  },
  {
    "title": "أورام",
    "image": "assets/images/tumor_icon.png",
  },
  {
    "title": "جراحة عامة",
    "image": "assets/images/surgery_icon.png",
  },
  {
    "title": "كلى",
    "image": "assets/images/kidney_wash.png",
  },
  {
    //! نفس أيقونة "أطفال" مؤقتًا — مفيش أيقونة جراحة أطفال مخصصة.
    "title": "جراحة أطفال",
    "image": "assets/images/baby_icon.png",
  },
  {
    "title": "أمراض الدم",
    "image": "assets/images/blood_icon.png",
  },
  {
    "title": "علاج طبيعي\nوتأهيل",
    "image": "assets/images/physical_therapy.png",
  },
  {
    //! مفيش أيقونة طب مسنين فى المشروع — دى مؤقتة لحد ما تتوفر صورة.
    "title": "طب المسنين",
    "image": "assets/images/patient.png",
  },
  {
    "title": "طب الرياضة\nواصابات الملاعب",
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
