class MentalIllnessesConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry

  static const getAllDoctors = "/Doctor/GetAllDcotors";
  static const getAllCountries = "/countries";
  //!New
  static const postMentalIlnessDataEntryEndPoint = "/v1/submit-medical-illness";
  static const postQuestionnaireAnswers = "/MentalAssessment/submit-answers";
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
  static const getMedicalIllnessDocsAvailableYears = "/v1/available-years";
  static const getMentalIllnessRecords = "/v1/medicalIllnessDocuments";
  static const getFilteredMentalIllnessDocuments = "/v1/documents/filter";
  static const getMentalIllnessDocumentDetailsById = "/v1/document";
  static const postActivationOfUmbrella = "/MentalAssessment/activate-umbrella";
  static const getActivationOfUmbrella = "/MentalAssessment/umbrella-status";

  static const deleteMentalIllnessDetailsDocumentById = "/v1/document";
  static const getMedicalIllnessUmbrellaDocs =
      "/api/getMedicalIllnessUmbrellaDocs";
  static const getAllAnsweredQuestions = "/v1/lookup/getAllAnsweredQuestions";
  static const getFollowUpReportsAvailableYears =
      "/psych/available-years";
  static const getAllFollowUpReportsRecords =
     "/psych/follow-up-reports";
  static const getFilteredFollowUpReports =
      "/psych/reports/filter";
  static const editSurgeryEndpoint = "/api/EnterSectionSurgery";
  static const getFollowUpDocumentDetailsById =
      "/psych/follow-up-report";
}
