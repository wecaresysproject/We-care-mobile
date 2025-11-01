class XrayApiConstants {
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
  static const getUserRadiologysData =
      "/RadiologyUserEntryPage/RadiologyGetUserDocuments";
  //{{base_url_app}}/RadiologyUserEntryPage/GetRadiologyUserDocumentViewPerOne/67bd878f716e68b0056d43de?language=ar&UserType=Patient
  static const getSpecificUserRadiologyDocument =
      "/RadiologyUserEntryPage/GetRadiologyUserDocumentViewPerOne";

  static const deleteXraybyid =
      '/RadiologyUserEntryPage/DeleteRadiologyDocument';

  static const updateXrayDocumentDetails =
      '/RadiologyUserEntryPage/UpdateRadiologyDocument';
  static const getAllDoctors = "/Doctor/GetAllDcotors";

  //filters
  static const getFilters = '/RadiologyUserEntryPage/RadiologyGetUserFilters';
  static const getFilteredDataEndpoint =
      "/RadiologyUserEntryPage/RadiologySearchUserDocuments";
}
