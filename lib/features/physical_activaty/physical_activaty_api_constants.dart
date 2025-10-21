class PhysicalActivatyApiConstants {
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
  static const getAvailableYears = "SmartNutritionAnalyzer/weekly-plans-years";
  static const getAvailableYearsForMonthlyPlan =
      "SmartNutritionAnalyzer/monthly-plans-years";
  static const getAvailableDatesBasedOnYear =
      "SmartNutritionAnalyzer/weekly-plans-dates";
  static const getFilterdDocuments = "SmartNutritionAnalyzer/doc-data-filtered";
  static const getPhysicalActivitySlides =
      "SmartNutritionAnalyzer/getPhysicalActivitySlides";
  static const getFoodAlternatives = "SmartNutritionAnalyzer/food-alternatives";
  static const updateNutrientStandard =
      "SmartNutritionAnalyzer/update-standard";

  static const getElementRecommendations =
      "SmartNutritionAnalyzer/nutrient-status";
  static const getAffectedOrgansList = "SmartNutritionAnalyzer/organ-names";
  static const getOrganNutritionalEffects =
      "SmartNutritionAnalyzer/organ-effects";
  static const getAnyActivePlanStatus = "SmartNutritionAnalyzer/check-active";
  static const deleteDayDietPlan = "SmartNutritionAnalyzer/nutrition-entry";
}
