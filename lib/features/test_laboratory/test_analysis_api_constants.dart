class TestAnalysisApiConstants {
  static const baseUrl = "http://147.93.57.70:5299";
  //Data Entry
  static const getCountries = "/countries";

  static const uploadXImageEndpoint = "/FileUpload/upload-image";
  static const uploadXReportEndpoint = "/FileUpload/upload-report";
  static const updateTestAnalysisEndpoint = "/m2/api/lab-tests/update";

  //View Endpoints

  static const getYearsFilter = "/m2/api/lab-tests/years";

  static const getUserTests = "/m2/api/lab-tests/summary";

  static const getFilteredTestsByYear = "/m2/api//lab-tests/filter";

  static const getTestbyId = "/m2/api/lab-tests/doc";

  static const deleteAnalysisById = '/m2/api/lab-tests';

  static const getSimilarTests = "/m2/api/lab-tests/search";

  static const editTestResultByIdAndName =
      '/api/lab-tests/updateWrittenPercent';

  //Data Entry
  static const getTestAnnotationsEndpoint =
      "/m2/api/flutter/SortsAnalysis/codes";
  static const getTestByGroupNamesEndpoint =
      "/m2/api/flutter/SortsAnalysis/group-names";
  static const getTestNamesEndpoint =
      "/m2/api/flutter/SortsAnalysis/test-names";
  static const getTableOfDataEndpoint = "/api/flutter/SortsAnalysis/test-info";

  static const postTestAnalysisEndpoint = "/m2/api/lab-tests";

  static const uploadLaboratoryTestImageEndpoint =
      "/m2/api/FileUpload/upload-image";
  static const uploadLaboratoryTestReportEndpoint =
      "/m2/api/FileUpload/upload-report";

  //View Entry

  //filters
}
