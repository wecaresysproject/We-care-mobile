bool isLoggedInUser = false;

class DentalApiConstants {
  static const baseUrl = "http://147.93.57.70/api";

  //Data Entry
  static const uploadReportEndpoint = "/FileUpload/upload-report"; //! to change
  static const uploadXrayImageEndpoint =
      "/FileUpload/upload-image"; // الاشعه السينيه
  static const uploadLymphAnalysisImage =
      "/FileUpload/upload-image"; // التحاليل الطبيه الفمويه
  static const postOneTeethReportDetails =
      "/TeethDataEntry/AddTeethPerUser"; // Post Single Teeth Report

  static const getAllCountries = "/countries";
  static const getAllMainMedicalProcedures =
      "/TeethDataEntry/GetAllMainProcedures";
  static const getAllsecondaryMedicalProcedure =
      "/TeethDataEntry/GetAllSubProcedureNames";
  static const getAllDoctors = "/Doctor/GetAllDcotors";
  static const getAllComplainTypes = "/TeethDataEntry/GetAllComplaintTypes";
  static const getAllComplainNatures = "/TeethDataEntry/GetAllComplaintNatures";
  static const getAllOralMedicalTests =
      "/TeethDataEntry/GetAllOralMedicalTests";
  static const getAllGumsconditions = "//TeethDataEntry/GetAllGumConditions";
  static const getAllComplainsDurations =
      "/TeethDataEntry/GetAllComplaintDurations";
  //View Entry
  static const getDefectedTooth = "/TeethDataEntry/GetAllTeethNumbersForUser";
  static const getDocumentsByToothNumber =
      "/TeethDataEntry/GetTeethDocumentsByNumber";

  static const getToothOperationDetailsById =
      "/TeethDataEntry/GetTeethDocumentById";  

  static const deleteToothOperationDetailsById =
      "/TeethDataEntry/DeleteTeethDocument";      

  //filters
}
