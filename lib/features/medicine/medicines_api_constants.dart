class MedicinesApiConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //http://147.93.57.70:5299/api/EnterEmergencyComplain/SymptomsComplaints
  //Data Entry
  static const getAllPlacesOfComplaints =
      "/EnterEmergencyComplain/SymptomsComplaints";
  static const getRelevantComplaintsToBodyPartName =
      "EnterEmergencyComplain/SymptomsComplaintsFiltered";
  static const getAllMedicinesNames = "MedicineUserEntryPage/GetAllMedicines";
  static const getMedicineDetailsById =
      "MedicineUserEntryPage/GetMedicineDetailsById";

  static const postDataEntryEndpoint = "";
  static const getMedcineForms = "MedicineUserEntryPage/GetMedicineFormsOnly";

  static const getMedcineDosesByForms =
      "MedicineUserEntryPage/GetMedicineDosesByForm";
  static const getAllDosageFrequencies =
      "MedicineUserEntryPage/GetAllDosageFrequencies";

  static const getMedicineUsageDurationCategroies =
      "MedicineUserEntryPage/GetAllUsageCategories";

  static const getAllDurationsForCategory =
      "MedicineUserEntryPage/GetDurationsForCategory";
  //View Entry
  static const getSingleMedicine = "MedicineUserEntryPage/GetMedicineById";
  static const deletemedicineById = "MedicineUserEntryPage/DeleteUserMedicine";
  static const getAllUserMedicines = "MedicineUserEntryPage/GetUserMedicines";

  //filters
  static const getFilters = "MedicineUserEntryPage/GetUserMedicineFilters";
  static const getFilteredMedicines =
      "MedicineUserEntryPage/SearchUserMedicineDocuments";
}
