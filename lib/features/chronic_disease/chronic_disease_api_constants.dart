class ChronicDiseaseApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const postChrconicDiseaseData = "/ChronicDiseases/add-disease";
  static const getChronicDiseasesNames =
      "/ChronicDiseases/all-name-chronic-diseases";

  //View Entry
  static const updatePrescriptionDocumentDetails =
      "/PreDescriptionUserEntryPage/EditPreDescriptionUserDocument";

  static const getUserPrescriptionList =
      "/PreDescriptionUserEntryPage/PreDescriptionGetUserDocuments";

  static const getUserPrescriptionDetailsById =
      "/PreDescriptionUserEntryPage/GetPreDescriptionPerOne";

  static const deletePrescriptionById =
      "/PreDescriptionUserEntryPage/DeletePreDescriptionUserDocument";

  static const getFilteredPrescriptionList =
      "/PreDescriptionUserEntryPage/PreDescriptionSearchUserDocuments";

  //filters
  static const getPrescriptionFilters =
      "/PreDescriptionUserEntryPage/PreDescriptionGetUserFilters";
}
