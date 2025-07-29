class MentalIllnessesConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry

  static const getAllDoctors = "/Doctor/GetAllDcotors";
  static const getAllCountries = "/countries";
  //!New
  static const postMentalIlnessDataEntryEndPoint = "/v1/submit-medical-illness";
  static const editMentalIlnessDataEntryEndPoint = "/v1/update-medical-illness";
  static const getMentalIllnessTypes = "/v1/lookup/mental-illness-types";
  static const getIncidentTypes = "/v1/lookup/incident-types";
  static const getMedicationImpactOnDailyLife = "/v1/lookup/daily-life-impacts";
  static const getPsychologicalEmergencies =
      '/v1/lookup/psychological-emergencies';
  static const getMedicationSideEffects = '/v1/lookup/medication-side-effects';
  static const getPreferredActivitiesForPsychologicalImprovement =
      '/v1/lookup/preferred-activities';

  //View Entry
  //!New
  static const getIsUmbrellaMentalIllnessButtonActivated =
      "/v1/lookup/mental-illness-umbrella-activated";
  static const getMedicalIllnessDocsAvailableYears =
      "/v1/lookup/getMedicalIllnessDocsAvailableYears";
  static const getMentalIllnessRecords = "/v1/lookup/getMentalIllnessRecords";
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
