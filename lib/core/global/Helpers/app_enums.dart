// ignore_for_file: constant_identifier_names

enum RequestStatus { initial, loading, success, failure }

//! user it like this :  UserType.patient.firstLetterToUpperCase
enum UserTypes {
  patient,
}

enum UploadImageRequestStatus {
  initial,
  success,
  failure,
}

enum UploadReportRequestStatus {
  initial,
  success,
  failure,
}

enum OptionsLoadingState {
  loading,
  loaded,
  error,
}

enum FamilyCodes {
  Mam,
  Dad,
  GrandpaFather,
  GrandmaFather,
  GrandpaMother,
  GrandmaMother,
  Bro,
  Sis,
  FatherSideUncle,
  FatherSideAunt,
  MotherSideUncle,
  MotherSideAunt,
}

enum PlanType {
  weekly,
  monthly,
}

enum WeCareMedicalModules {
  profileDataEntry, // 1. البيانات الأساسية (إدخال)
  profileDataView, // 1. البيانات الأساسية (عرض)

  vitalSignsDataEntry, // 2. القياسات الحيوية (إدخال)
  vitalSignsView, // 2. القياسات الحيوية (عرض)

  medicationsDataEntry, // 3. الأدوية (إدخال)
  medicationsView, // 3. الأدوية (عرض)

  emergenciesComplaintsDataEntry, // 4. الشكوى الطارئة (إدخال)
  emergenciesComplaintsView, // 4. الشكوى الطارئة (عرض)

  prescriptionsDataEntry, // 5. روشتة الأطباء (إدخال)
  prescriptionsView, // 5. روشتة الأطباء (عرض)

  labTestsDataEntry, // 6. التحاليل الطبية (إدخال)
  labTestsView, // 6. التحاليل الطبية (عرض)

  imagingRadiologyDataEntry, // 7. الأشعة (إدخال)
  imagingRadiologyView, // 7. الأشعة (عرض)

  surgeriesDataEntry, // 8. العمليات الجراحية (إدخال)
  surgeriesView, // 8. العمليات الجراحية (عرض)

  chronicDiseasesDataEntry, // 9. الأمراض المزمنة (إدخال)
  chronicDiseasesView, // 9. الأمراض المزمنة (عرض)

  geneticDiseasesDataEntry, // 10. الأمراض الوراثية (إدخال)
  geneticDiseasesView, // 10. الأمراض الوراثية (عرض)

  allergiesDataEntry, // 11. الحساسية (إدخال)
  allergiesView, // 11. الحساسية (عرض)

  ophthalmologyDataEntry, // 12. العيون (إدخال)
  ophthalmologyView, // 12. العيون (عرض)

  dentistryDataEntry, // 13. الأسنان (إدخال)
  dentistryView, // 13. الأسنان (عرض)

  vaccinationsDataEntry, // 14. التطعيمات (إدخال)
  vaccinationsView, // 14. التطعيمات (عرض)

  mentalHealthDataEntry, // 15. الأمراض النفسية (إدخال)
  mentalHealthView, // 15. الأمراض النفسية (عرض)

  nutritionDataEntry, // 16. المتابعة الغذائية (إدخال)
  nutritionView, // 16. المتابعة الغذائية (عرض)

  physicalActivityDataEntry, // 17. النشاط الرياضي (إدخال)
  physicalActivityView, // 17. النشاط الرياضي (عرض)

  vitaminsAndSupplementsDataEntry, // 18. الفيتامينات والمكملات الغذائية (إدخال)
  vitaminsAndSupplementsView, // 18. الفيتامينات والمكملات الغذائية (عرض)

  drugCheck, // 19. اختبار توافق ادويتي
  newMedicineCompitability, //20. اختبار توافق دواء جديد
  aiConsult, // 21. استشر الـ AI
  myMedicalReports, // 22. تقاريري الطبية
  medicalNotes, // 23. ملاحظاتي الطبية
  qualityOfLife, // 24. جودة الحياة
  riskyBehaviorsDataEntry, // 25. السلوكيات الخطرة
  riskyBehaviorsView, // 26. السلوكيات الخطرة
}
