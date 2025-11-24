class SurgeriesApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  // static const getCountries = "/api/EnterSectionSurgery/countries";
  static const uploadReportEndpoint = "/FileUpload/upload-report";
  static const getAllSurgeriesRegions = // العضو
      "/EnterSectionSurgery/surgery-regions";
  static const getSubSurgeriesRegions =
      "/EnterSectionSurgery/sub-surgery-regions-connected";
  static const getAllDoctors = "/Doctor/GetAllDcotors";

  static const getSurgeryName = "/EnterSectionSurgery/surgery-names-connected";
  static const getAllTechUsed =
      "/EnterSectionSurgery/used-techniques-connected"; // التقنيه المستخدمه
  // static const getSurgeryStatus =
  // "/EnterSectionSurgery/status-surgery"; // التقنيه المستخدمه
  static const surgeryPurpose = "/EnterSectionSurgery/purpose";
  static const postSurgeryEndpoint = "/EnterSectionSurgery";
  //View Entry
  static const deleteSurgeryById = "/EnterSectionSurgery";
  static const getAllSurgeries = "/EnterSectionSurgery";
  static const getSingleSurgery = "/ViewSectionSurgery/filter-by-id";
  static const editSurgeryEndpoint = "/EnterSectionSurgery";
  //filters
  static const getSurgeriesFilters = "/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/ViewSectionSurgery/filter";
}
