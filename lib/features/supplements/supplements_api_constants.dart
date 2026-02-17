class SupplementsApiConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //Data Entry
  static const retrieveAvailableVitamins = "SupplementsAndVitamins/names";
  static const submitSelectedSupplements =
      "SupplementsAndVitamins/SupplementsAndVitamins";
  static const getTrackedSupplementsAndVitamins =
      "SupplementsAndVitamins/SupplementsAndVitamins";
  static const deleteSubmittedSupplementOnSpecificDate =
      "SupplementsAndVitamins/DailyIntakeRecordByDate";
  static const submitDailyUserTakenSupplement =
      "SupplementsAndVitamins/DailyIntakeRecord";
  static const retrieveDailyFollowUpTable =
      "SupplementsAndVitamins/result-data";
  //! change these to relative endpoints  later
  static const getAllCreatedPlans = "SupplementsAndVitamins/generate-plan";
  static const getAnyActivePlanStatus = "SupplementsAndVitamins/check-active";
  static const getPlanActivationStatus = "SupplementsAndVitamins/check";
  //View Entry

  //filters
  static const getAvailableDateRanges =
      "SupplementsAndVitamins/available-date-ranges";
  static const getEffectsOnNutrients =
      "SupplementsAndVitamins/EffectsSupplementsAndVitaminsTable";
  static const getVitaminsAndSupplements =
      "SupplementsAndVitamins/supplements-elements";
}
