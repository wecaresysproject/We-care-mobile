class VaccineApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const getCountries = "/countries";
  static const getvaccineCategories =
      "/VaccineUserEntryPage/GetAllVaccineCategories";
  static const getSpecificVaccinesResultsUsingSelectedCategory =
      "/VaccineUserEntryPage/GetVaccinesByCategory";
  static const postVaccineDataEntry = "/Vaccine/vaccine-user-entry";
  static const updateVaccineDataEntry =
      "/VaccineUserEntryPage/EditUserVaccineDocument";

  static const getBirthGenerations = "/Vaccine/generations";
  static const getTargetGroupsByBirthGeneration = "/Vaccine/target-ages";
  static const getVaccineNamesByTargetGroup = "/Vaccine/vaccine-names";
  static const getVaccineDetailsByName = "/Vaccine/vaccine-details";
  //View Entry

  static const getUserVaccines = "/Vaccine/user-vaccines";
  static const getUserSubmissionDates = "/Vaccine/years";
  static const getVaccineById = "/VaccineUserEntryPage/GetVaccineById";
  static const deleteVaccineById = "/VaccineUserEntryPage/DeleteUserVaccine";

  //filters
  static const getVaccinesFilters =
      "/VaccineUserEntryPage/GetUserVaccineFilters";

  static const getFilteredList =
      "/VaccineUserEntryPage/SearchUserVaccineDocuments";
}
