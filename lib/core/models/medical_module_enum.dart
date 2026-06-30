enum MedicalModule {
  basicInformation,
  vitalSigns,
  medications,
  chronicDiseases,
  urgentComplaints,
  doctorsPrescriptions,
  medicalTests,
  radiology,
  surgeries,
  geneticDiseases,
  allergies,
  eyes,
  dental,
  mentalHealth,
  smartNutritionalAnalyzer,
  sportsActivity,
  supplements,
  medicalEndoscopes,
  tumors,
  kidneyDialysis,
  physicalTherapy,
  vaccinations,
  pregnancyFollowUp,
  reproductiveProblems,
  burns,
  cosmeticSurgeries,
  riskyBehaviors,
  publicHealth,
}

extension MedicalModuleExtension on MedicalModule {
  String get nameAr {
    switch (this) {
      case MedicalModule.basicInformation:
        return "البيانات الأساسية";
      case MedicalModule.vitalSigns:
        return "القياسات الحيوية";
      case MedicalModule.medications:
        return "الأدوية";
      case MedicalModule.chronicDiseases:
        return "الأمراض المزمنة";
      case MedicalModule.urgentComplaints:
        return "الشكاوى الطارئة";
      case MedicalModule.doctorsPrescriptions:
        return "روشتة الأطباء";
      case MedicalModule.medicalTests:
        return "التحاليل الطبية";
      case MedicalModule.radiology:
        return "الأشعة";
      case MedicalModule.surgeries:
        return "العمليات الجراحية";
      case MedicalModule.geneticDiseases:
        return "الأمراض الوراثية";
      case MedicalModule.allergies:
        return "الحساسية";
      case MedicalModule.eyes:
        return "العيون";
      case MedicalModule.dental:
        return "الأسنان";
      case MedicalModule.mentalHealth:
        return "الأمراض النفسية";
      case MedicalModule.smartNutritionalAnalyzer:
        return "المحلل الغذائي الذكي";
      case MedicalModule.sportsActivity:
        return "النشاط الرياضي";
      case MedicalModule.supplements:
        return "المكملات الغذائية";
      case MedicalModule.medicalEndoscopes:
        return "المناظير الطبيه";
      case MedicalModule.tumors:
        return "الأورام";
      case MedicalModule.kidneyDialysis:
        return "الغسيل الكلوى";
      case MedicalModule.physicalTherapy:
        return "العلاج الطبيعى";
      case MedicalModule.vaccinations:
        return "التطعيمات";
      case MedicalModule.pregnancyFollowUp:
        return "متابعة الحمل";
      case MedicalModule.reproductiveProblems:
        return "علاج مشاكل الانجاب";
      case MedicalModule.burns:
        return "الحروق";
      case MedicalModule.cosmeticSurgeries:
        return "الجراحات التجميلية";
      case MedicalModule.riskyBehaviors:
        return "السلوكيات الخاطئة";
      case MedicalModule.publicHealth:
        return "الصحه العامه";
    }
  }

  String get nameEn {
    switch (this) {
      case MedicalModule.basicInformation:
        return "Basic Information Module";
      case MedicalModule.vitalSigns:
        return "Vital Signs Module";
      case MedicalModule.medications:
        return "Medications Module";
      case MedicalModule.chronicDiseases:
        return "Chronic Diseases Module";
      case MedicalModule.urgentComplaints:
        return "Urgent Complaints Module";
      case MedicalModule.doctorsPrescriptions:
        return "Doctors' Prescriptions Module";
      case MedicalModule.medicalTests:
        return "Medical Tests Module";
      case MedicalModule.radiology:
        return "Radiology Module";
      case MedicalModule.surgeries:
        return "Surgeries Module";
      case MedicalModule.geneticDiseases:
        return "Genetic Diseases Module";
      case MedicalModule.allergies:
        return "Allergies Module";
      case MedicalModule.eyes:
        return "Eyes Module";
      case MedicalModule.dental:
        return "Dental Module";
      case MedicalModule.mentalHealth:
        return "Mental Health Module";
      case MedicalModule.smartNutritionalAnalyzer:
        return "Smart Nutritional Analyzer Module";
      case MedicalModule.sportsActivity:
        return "Sports Activity Module";
      case MedicalModule.supplements:
        return "Supplements Module";
      case MedicalModule.medicalEndoscopes:
        return "Medical Endoscopes Module";
      case MedicalModule.tumors:
        return "Tumors Module";
      case MedicalModule.kidneyDialysis:
        return "Kidney Dialysis Module";
      case MedicalModule.physicalTherapy:
        return "Physical Therapy Module";
      case MedicalModule.vaccinations:
        return "Vaccinations Module";
      case MedicalModule.pregnancyFollowUp:
        return "Pregnancy Follow-up Module";
      case MedicalModule.reproductiveProblems:
        return "Reproductive Problems Treatment Module";
      case MedicalModule.burns:
        return "Burns Module";
      case MedicalModule.cosmeticSurgeries:
        return "Cosmetic Surgeries Module";
      case MedicalModule.riskyBehaviors:
        return "Risky Behaviors Module";
      case MedicalModule.publicHealth:
        return "Public Health Module";
    }
  }

  static MedicalModule? fromString(String value) {
    for (var module in MedicalModule.values) {
      if (module.nameAr == value || module.nameEn == value) {
        return module;
      }
    }
    return null;
  }
}

class MedicalModuleMapper {
  /// Converts an Arabic module name to its English equivalent.
  /// Returns the original string if not found.
  static String mapArabicToEnglish(String name) {
    final module = MedicalModuleExtension.fromString(name);
    return module?.nameEn ?? name;
  }

  /// Converts an English module name to its Arabic equivalent.
  /// Returns the original string if not found.
  static String mapEnglishToArabic(String name) {
    final module = MedicalModuleExtension.fromString(name);
    return module?.nameAr ?? name;
  }

  /// Get the localized name based on language code ('ar' or 'en')
  static String getLocalizedName(MedicalModule module, String langCode) {
    return langCode == 'ar' ? module.nameAr : module.nameEn;
  }
}
