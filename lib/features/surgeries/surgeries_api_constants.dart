bool isLoggedInUser = false;

class SurgeriesApiConstants {
  static const baseUrl = "http://147.93.57.70:5299/api";
  //Data Entry

  //View Entry
  static const getAllSurgeries = "/EnterSectionSurgery";
  static const getSingleSurgery = "/ViewSectionSurgery/filter-by-id";
  static const deleteSurgeryById = "/EnterSectionSurgery";

  //filters
  static const getSurgeriesFilters = "/ViewSectionSurgery/surgery-info";
  static const getFilteredSurgeries = "/ViewSectionSurgery/filter";
}
