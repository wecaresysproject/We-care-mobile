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
