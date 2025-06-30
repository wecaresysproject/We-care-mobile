class EyesApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  // static const getCountries = "/api/EnterSectionSurgery/countries";
  static const uploadReportEndpoint = "/m2/api/FileUpload/upload-report";
  static const postGlassesEssentialDataEntryEndPoint =
      "/EyesDataEntry/submit-glasses-essential";
  static const postGlassesLensDataEntryEndPoint =
      "/EyesDataEntry/submit-glasses-lens";
  static const getAllLensSurfaces = "/EyesDataEntry/lens-surfaces";
  static const getEyePartSyptomsAndProcedures =
      "/EyesDataEntry/eye-part-details";
  static const getEyePartDescribtion = "/EyesDataEntry/eye-section-description";
  static const getAllLensTypes = "/EyesDataEntry/lens-types";
  static const getAllDoctors = "/Doctor/GetAllDcotors";
  static const getAllCountries = "/countries";

  //View Entry
  static const deleteSurgeryById = "/api/EnterSectionSurgery";
  static const getAllSurgeries = "/api/EnterSectionSurgery";
  static const getSingleSurgery = "/api/ViewSectionSurgery/filter-by-id";
  static const editSurgeryEndpoint = "/api/EnterSectionSurgery";
  //filters
  static const getSurgeriesFilters = "/api/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/api/ViewSectionSurgery/filter";
}
