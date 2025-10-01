class NutrationApiConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //Data Entry
  static const postPersonalUserInfoData = "SmartNutritionAnalyzer/calculate";
  static const postDailyDietPlan = "SmartNutritionAnalyzer/nutrition-entry";
  static const getAllCreatedPlans = "SmartNutritionAnalyzer/generate-plan";
  static const getAllChronicDiseases = "SmartNutritionAnalyzer/names";
  static const getPlanActivationStatus =
      "SmartNutritionAnalyzer/check"; //! change it later

  //View Entry
  static const getAllNutrationTableData = "SmartNutritionAnalyzer/result-data";
  static const getAvailableYearsForWeeklyPlan =
      "SmartNutritionAnalyzer/weekly-plans-years";
  static const getAvailableYearsForMonthlyPlan =
      "SmartNutritionAnalyzer/monthly-plans-years";
  static const getAvailableDateRangesForWeeklyPlan =
      "SmartNutritionAnalyzer/all-weekly-plans";
  static const getAvailableDateRangesForMonthlyPlan =
      "SmartNutritionAnalyzer/all-monthly-plans";
  static const getFilterdNutritionDocuments =
      "SmartNutritionAnalyzer/doc-data-filtered";
  static const getNutrationDocuments = "/SmartNutritionAnalyzer/doc-data";
  static const getFoodAlternatives = "SmartNutritionAnalyzer/food-alternatives";

  //filters
}
