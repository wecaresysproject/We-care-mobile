bool isLoggedInUser = false;

class SurgeriesApiConstants {
  static const baseUrl = "http://147.93.57.70:5299";
  //Data Entry
  // static const getCountries = "/api/EnterSectionSurgery/countries";
  static const uploadReportEndpoint = "/m2/api/FileUpload/upload-report";
  //View Entry
<<<<<<< HEAD
  static const getAllSurgeries = "/EnterSectionSurgery";
  static const getSingleSurgery = "/ViewSectionSurgery/filter-by-id";
  static const deleteSurgeryById = "/EnterSectionSurgery";
=======
  static const getAllSurgeries = "/api/EnterSectionSurgery";
  static const getSingleSurgery = "/api/ViewSectionSurgery/filter-by-id";
>>>>>>> bbba11a (Upload report image)

  //filters
  static const getSurgeriesFilters = "/api/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/api/ViewSectionSurgery/filter";
}
