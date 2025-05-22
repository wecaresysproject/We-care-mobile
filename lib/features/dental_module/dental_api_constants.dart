bool isLoggedInUser = false;

class DentalApiConstants {
  static const baseUrl = "http://147.93.57.70/api";

  //Data Entry
  static const uploadReportEndpoint = "/FileUpload/upload-report"; //! to change
  static const getAllCountries = "/countries";
  static const getAllMainMedicalProcedures =
      "/TeethDataEntry/GetAllMainProcedures";
  static const getAllsecondaryMedicalProcedure =
      "/TeethDataEntry/GetAllSubProcedureNames";
  static const getAllDoctors = "/Doctor/GetAllDcotors";
  static const getAllComplainTypes = "/TeethDataEntry/GetAllComplaintTypes";
  static const getAllComplainNatures = "/TeethDataEntry/GetAllComplaintNatures";
  static const getAllComplainsDurations =
      "/TeethDataEntry/GetAllComplaintDurations";
  //View Entry

  //filters
}
