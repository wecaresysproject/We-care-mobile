class ChronicDiseaseApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const postChrconicDiseaseData = "/ChronicDiseases/add-disease";
  static const getChronicDiseasesNames =
      "/ChronicDiseases/all-name-chronic-diseases";

  //View Entry
  static const updatePrescriptionDocumentDetails =
      "/PreDescriptionUserEntryPage/EditPreDescriptionUserDocument";

  static const getAllChronicDiseasesDocuments =
      "/ChronicDiseases/summery-diseases";

  static const getUserChronicDiseaseDetailsById =
      "/ChronicDiseases/disease-by-id";

  static const deleteUserChronicDisease = "/ChronicDiseases/delete-disease";

  static const getFilteredPrescriptionList =
      "/PreDescriptionUserEntryPage/PreDescriptionSearchUserDocuments";

  //filters
  static const getPrescriptionFilters =
      "/PreDescriptionUserEntryPage/PreDescriptionGetUserFilters";
}
