class TestAnalysisApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const getCountries = "/countries";

  static const uploadXImageEndpoint = "/FileUpload/upload-image";
  static const uploadXReportEndpoint = "/FileUpload/upload-report";
  static const updateTestAnalysisEndpoint = "/lab-tests/update";

  //View Endpoints

  static const getYearsFilter = "/lab-tests/years";

  static const getUserTests = "/lab-tests/summary";

  static const getFilteredTestsByYear = "/lab-tests/filter";

  static const getTestbyId = "/lab-tests/doc";

  static const deleteAnalysisById = '/lab-tests';

  static const getSimilarTests = "/lab-tests/search";

  static const editTestResultByIdAndName = '/lab-tests/updateWrittenPercent';

  static const getTestByGroupNamesEndpoint =
      "/flutter/SortsAnalysis/group-names";
  static const getTestAnnotationsEndpoint = "/flutter/SortsAnalysis/codes";
  static const getTestNamesEndpoint = "/flutter/SortsAnalysis/test-names";
  static const getTableOfDataEndpoint = "/flutter/SortsAnalysis/test-info";

  static const postTestAnalysisEndpoint = "/lab-tests";

  static const uploadLaboratoryTestImageEndpoint = "/FileUpload/upload-image";
  static const uploadLaboratoryTestReportEndpoint = "/FileUpload/upload-report";
}
