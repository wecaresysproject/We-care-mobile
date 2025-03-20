class VaccineApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const getCountries = "/countries";
  static const getvaccineCategories =
      "/VaccineUserEntryPage/GetAllVaccineCategories";
  static const getSpecificVaccinesResultsUsingSelectedCategory =
      "/VaccineUserEntryPage/GetVaccinesByCategory";
  static const postVaccineDataEntry =
      "/VaccineUserEntryPage/AddVaccineUserEntry";
  static const updateVaccineDataEntry =
      "/VaccineUserEntryPage/EditUserVaccineDocument";
  //View Entry

  static const getUserVaccines = "/VaccineUserEntryPage/GetUserVaccines";
  static const getVaccineById = "/VaccineUserEntryPage/GetVaccineById";
  static const deleteVaccineById = "/VaccineUserEntryPage/DeleteUserVaccine";

  //filters
  static const getVaccinesFilters =
      "/VaccineUserEntryPage/GetUserVaccineFilters";

  static const getFilteredList =
      "/VaccineUserEntryPage/SearchUserVaccineDocuments";
}
