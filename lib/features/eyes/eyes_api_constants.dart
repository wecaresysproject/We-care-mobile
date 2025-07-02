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
  static const getAvailableYears = "/api/lens/available-years";
  static const getAllDocuments = "/api/lens/documents";
  static const getFilteredDocuments = "/api/lens/documents/filter";
  static const getDocumentDetailsById = "/api/lens/document";
  static const deleteDocumentById = "/api/lens/document";

  // -------------------------------
  // 🔹 Glasses
  // Figma Screen: 14.choose eye glasses to view, 15.view eye glasses ...
  // -------------------------------
  static const getGlassesRecords = "/api/glasses";
  static const getGlassesDetailsById = "/api/glasses/details";
  static const deleteGlassesById = "/api/glasses";
}
