class EmergencyComplaintsApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const getAllPlacesOfComplaints =
      "/EnterEmergencyComplain/Placeofcomplaint";
  static const getRelevantComplaintsToBodyPartName =
      "/EnterEmergencyComplain/SymptomsComplaintsFiltered";

  static const postDataEntryEndpoint = "/EnterEmergencyComplain/EnterComplaint";
  static const editSpecificComplaintDocumentDetail =
      "/EnterEmergencyComplain/UpdateComplaint";
  static const getAllMedicineNames =
      "http://147.93.57.70/api/MedicineUserEntryPage/GetAllMedicines";
  //View Entry
  static const getAllEmergencyComplaints =
      "/EnterEmergencyComplain/GetAllComplaints";
  static const getSingleEmergencyComplaintById =
      "/ViewEmergencyComplaint/GetAllComplaintsById";

  static const deleteComplaintById = "/EnterEmergencyComplain/DeleteComplaint";
  //filters
  static const getYearsFiter = "/ViewEmergencyComplaint/years";
  static const getPlaceOfComplaintFilter =
      "/ViewEmergencyComplaint/AllSymptomsLocation";
  static const getFilteredList = "/ViewEmergencyComplaint/filter";
  static const getAllOrganOrPartSymptomsRelativeToMainRegionEndPoint =
      "/EnterEmergencyComplain/BodyPartsByMainArea";

  static const searchBySyptomsEndpoint =
      "/EnterEmergencyComplain/SearchKeywords";
}
