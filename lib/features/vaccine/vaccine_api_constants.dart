class VaccineApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const getCountries = "/countries";
  static const getvaccineCategories =
      "/VaccineUserEntryPage/GetAllVaccineCategories";

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
