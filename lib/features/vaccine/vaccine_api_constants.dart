class VaccineApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const postRadiologyDataEntry = "/RadiologyUserEntryPage";
  static const getCountries = "/countries";
  static const getBodyParts = "/ImagingType/GetAllImagingType"; // منطقة الاشعه
  static const getRadiologyTypeByBodyPartId =
      "/ImagingType"; //! to be changed later from backend

  static const uploadXrayImageEndpoint = "/FileUpload/upload-image";
  static const uploadXrayReportEndpoint = "/FileUpload/upload-report";

  //View Entry

  //filters
}
