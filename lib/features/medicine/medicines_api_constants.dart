class MedicinesApiConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //Data Entry
  static const getAllPlacesOfComplaints =
      "/EnterEmergencyComplain/Placeofcomplaint";
  static const getRelevantComplaintsToBodyPartName =
      "/EnterEmergencyComplain/SymptomsComplaintsFiltered";

  static const postDataEntryEndpoint = "/EnterEmergencyComplain/EnterComplaint";

  //View Entry
  static const getAllMedicines = "MedicineUserEntryPage/GetUserMedicines";

  //filters
  static const getFilters = "MedicineUserEntryPage/GetUserMedicineFilters";
  static const getFilteredMedicines =
      "MedicineUserEntryPage/SearchUserMedicineDocuments";
}
