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
  profile, // البيانات الاساسيه
  vitalSigns,
  medications,
  emergenciesComplaints,
  prescriptions,
  labTests,
  imagingAndRadiology, //الاشعه ✅
  surgeries,
  chronicDiseases,
  geneticDiseases,
  allergies,
  ophthalmology,
  dentistry,
  vaccinations,
  mentalHealth,
  nutrition,
  physicalActivity,
  vitaminsAndSupplements,
  endoscopy,
  oncology,
  renalDialysis,
  physicalTherapy,
  pregnancyMonitoring,
  infertility,
  burns,
  cosmeticSurgery,
  highRiskBehaviors,
  publicHealth,
  drugCheck,
  homeVisit,
  onlineDoctorConsultation,
  aiConsult,
  myGenetics,
  patientSupport,
  myMedicalReports,
  lifeQuality,
  findADoctor,
  doctorRatings,
  dataCompletion,
  healthRiskIndicators,
}
