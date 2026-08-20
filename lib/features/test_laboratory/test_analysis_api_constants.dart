class TestAnalysisApiConstants {
  static const baseUrl = "http://147.93.57.70/api";
  //Data Entry
  static const getCountries = "/countries";

  static const uploadXImageEndpoint = "/FileUpload/upload-image";
  static const uploadXReportEndpoint = "/FileUpload/upload-report";
  static const updateTestAnalysisEndpoint = "/lab-tests/update";

  //View Endpoints

  static const getYearsFilter = "/lab-tests/years";
  static const getAllUserGroupNames = "/lab-tests/UserGroupNames";
  static const getAllUserTestCodes = "/lab-tests/UserCodes";

  static const getUserTests = "/lab-tests/summary";

  static const getFilteredTests = "/lab-tests/filter";

  static const getTestbyId = "/lab-tests/doc";

  static const deleteAnalysisById = '/lab-tests';

  static const getSimilarTests = "/lab-tests/search";

  static const editTestResultByIdAndName = '/lab-tests/updateWrittenPercent';
  static const getAllDoctors = "/Doctor/GetAllDcotors";

  static const getTestByGroupNamesEndpoint =
      "/flutter/SortsAnalysis/group-names";
  static const getTestAnnotationsEndpoint = "/flutter/SortsAnalysis/codes";
  static const getAllEnglishTestNamesEndpoint = "/lab-tests/AllEnglishTestName";
  static const getUserEnglishTestNames = "/lab-tests/UserTestNames";
  static const getTestNamesEndpoint = "/flutter/SortsAnalysis/test-names";

  /// Descriptive result options for a test that has no numeric percentage.
  static const getTestChoices = "/flutter/SortsAnalysis/test-choices";
  static const getTableOfDataEndpoint = "/flutter/SortsAnalysis/test-info";

  static const postTestAnalysisEndpoint = "/lab-tests";

  static const uploadLaboratoryTestImageEndpoint = "/FileUpload/upload-image";
  static const uploadLaboratoryTestReportEndpoint = "/FileUpload/upload-report";
}
