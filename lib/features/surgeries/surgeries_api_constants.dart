bool isLoggedInUser = false;

class SurgeriesApiConstants {
  static const baseUrl = "http://147.93.57.70:5299";
  //Data Entry
  // static const getCountries = "/api/EnterSectionSurgery/countries";
  static const uploadReportEndpoint = "/m2/api/FileUpload/upload-report";
  static const getAllSurgeriesRegions = // العضو
      "/api/EnterSectionSurgery/surgery-regions";
  static const getSubSurgeriesRegions =
      "/api/EnterSectionSurgery/sub-surgery-regions-connected";

  static const getSurgeryName =
      "/api/EnterSectionSurgery/surgery-names-connected";
  static const getAllTechUsed =
      "/api/EnterSectionSurgery/used-techniques-connected"; // التقنيه المستخدمه
  static const getSurgeryStatus =
      "/api/EnterSectionSurgery/status-surgery"; // التقنيه المستخدمه
  static const surgeryPurpose = "/api/EnterSectionSurgery/purpose";
  static const postSurgeryEndpoint = "/api/EnterSectionSurgery";
  //View Entry
  static const deleteSurgeryById = "/api/EnterSectionSurgery";
  static const getAllSurgeries = "/api/EnterSectionSurgery";
  static const getSingleSurgery = "/api/ViewSectionSurgery/filter-by-id";
  static const editSurgeryEndpoint = "/api/EnterSectionSurgery";
  //filters
  static const getSurgeriesFilters = "/api/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/api/ViewSectionSurgery/filter";
}
