class AllergyApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  // static const getCountries = "/api/EnterSectionSurgery/countries";
  static const uploadReportEndpoint = "/FileUpload/upload-report";
  static const getAllSurgeriesRegions = // العضو
      "/EnterSectionSurgery/surgery-regions";
  static const getAllAllergyTypes = "/v1/lookup/allergy-types";

  static const getSurgeryName = "/EnterSectionSurgery/surgery-names-connected";
  static const getAllTechUsed =
      "/EnterSectionSurgery/used-techniques-connected"; // التقنيه المستخدمه
  static const getAllergyTriggers = "/v1/lookup/allergy-triggers";
  static const surgeryPurpose = "/EnterSectionSurgery/purpose";
  static const postAllergyModuleData = "/v1/allergy-data";
  //View Entry
  static const deleteAllergyById = "/v1/allergy-data";
  static const getAllergyDiseases = "/v1/All-allergies";
  static const getSingleAllergyDetailsById = "/v1/user-allergies";
  static const editSurgeryEndpoint = "/EnterSectionSurgery";
  //filters
  static const getSurgeriesFilters = "/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/ViewSectionSurgery/filter";
}
