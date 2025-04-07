class MedicinesApiConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //Data Entry
  static const getAllPlacesOfComplaints =
      "/EnterEmergencyComplain/Placeofcomplaint";
  static const getRelevantComplaintsToBodyPartName =
      "/EnterEmergencyComplain/SymptomsComplaintsFiltered";
  static const getAllMedicinesNames = "MedicineUserEntryPage/GetAllMedicines";
  static const getMedicineDetailsById =
      "MedicineUserEntryPage/GetMedicineDetailsById";

  static const postDataEntryEndpoint = "";

  //View Entry
  static const getSingleMedicine = "MedicineUserEntryPage/GetMedicineById";
  static const deletemedicineById = "MedicineUserEntryPage/DeleteUserMedicine";
  static const getAllUserMedicines = "MedicineUserEntryPage/GetUserMedicines";

  //filters
  static const getFilters = "MedicineUserEntryPage/GetUserMedicineFilters";
  static const getFilteredMedicines =
      "MedicineUserEntryPage/SearchUserMedicineDocuments";
}
