class PhysicalActivatyApiConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //Data Entry
  static const postPersonalUserInfoData = "PhysicalActivityForUser/user-data";
  static const postDailyDietPlan =
      "PhysicalActivityForUser/physical-activities";
  static const getAllCreatedPlans = "PhysicalActivityForUser/generate-plan";
  static const getPlanActivationStatus = "PhysicalActivityForUser/check";

  static const getAnyActivePlanStatus =
      "PhysicalActivityForUser/check-active"; //! need one specific for this module
  static const deleteDayDietPlan =
      "PhysicalActivityForUser/physical-activities";

  //View Entry
  static const getAvailableYears = "PhysicalActivityForUser/plans/years";
  static const getFollowUpReports =
      "PhysicalActivityForUser/physical-activity/table";
  static const getAvailableDatesBasedOnYear =
      "PhysicalActivityForUser/plans/ranges";
  static const getFilterdDocuments =
      "PhysicalActivityForUser/physical-activity/range";
  static const getPhysicalActivitySlides =
      "PhysicalActivityForUser/physical-activity/metrics";

  // static const getAllNutrationTableData = "SmartNutritionAnalyzer/result-data";
}
