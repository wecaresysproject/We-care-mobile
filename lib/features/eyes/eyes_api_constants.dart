class EyesApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  // static const getCountries = "/api/EnterSectionSurgery/countries";
  static const uploadReportEndpoint = "/m2/api/FileUpload/upload-report";
  static const postGlassesEssentialDataEntryEndPoint =
      "/EyesDataEntry/submit-glasses-essential";

  static const getAllLensSurfaces = "/EyesDataEntry/lens-surfaces";
  static const getEyePartSyptomsAndProcedures =
      "/EyesDataEntry/eye-part-details";
  static const getEyePartDescribtion = "/EyesDataEntry/eye-section-description";
  static const getAllLensTypes = "/EyesDataEntry/lens-types";
  static const getAllDoctors = "/Doctor/GetAllDcotors";
  static const getAllCountries = "/countries";
  static const postEyeDataEntry = "/EyesDataEntry/submit-eye-entry";
  static const editEyeDataEntered = "/EyesDataEntry/update-eye-entry";
  static const editGlassesDataEntered = "/EyesDataEntry/edit-glasses-essential";

  //View Entry
  static const deleteSurgeryById = "/api/EnterSectionSurgery";
  static const getAllSurgeries = "/api/EnterSectionSurgery";
  static const getSingleSurgery = "/api/ViewSectionSurgery/filter-by-id";
  static const editSurgeryEndpoint = "/api/EnterSectionSurgery";
  //filters
  static const getSurgeriesFilters = "/api/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/api/ViewSectionSurgery/filter";

  // -------------------------------
  // 🔹 Procedures and Symptoms
  // Figma Screen: 12.choose Procedures and symptoms (all)
  // -------------------------------
  static const getAvailableYears = "/EyesDataEntry/lens/available-years";
  static const getAllDocuments = "/EyesDataEntry/lens/documents";
  static const getFilteredDocuments = "/EyesDataEntry/lens/documents/filter";
  static const getDocumentDetailsById = "/EyesDataEntry/lens/document";
  static const deleteDocumentById = "/EyesDataEntry/lens/document";

  // -------------------------------
  // 🔹 Glasses
  // Figma Screen: 14.choose eye glasses to view, 15.view eye glasses ...
  // -------------------------------
  static const getGlassesRecords = "/EyesDataEntry/glasses";
  static const getGlassesDetailsById = "/EyesDataEntry/glasses/details";
  static const deleteGlassesById = "/EyesDataEntry/glasses";
}
