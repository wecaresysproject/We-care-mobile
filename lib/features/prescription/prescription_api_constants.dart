class PrescriptionApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const postPrescriptionDataEntry =
      "/PreDescriptionUserEntryPage/AddPreDescriptionUserEntry";
  static const getCountries = "/countries";
  static const getCitiesByCountryName = "/countries/cities";
  static const uploadPrescriptionImageEndpoint = "/FileUpload/upload-image";

  //View Entry

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
