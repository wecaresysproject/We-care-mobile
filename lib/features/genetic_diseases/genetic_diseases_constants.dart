class GeneticDiseasesConstants {
  static const baseUrl = "http://147.93.57.70/api/";
  //http://147.93.57.70:5299/api/EnterEmergencyComplain/SymptomsComplaints
  //Data Entry

  static const editDataEntryEndpoint = "";

  static const getAllDoctors = "Doctor/GetAllDcotors";
  static const getAllCountries = "countries";

  static const getAllGeneticDiseasesClassfications =
      "GeneticDiseasesAPIs/medical-classifications";

  static const getAllGeneticDiseasesStatus =
      "GeneticDiseasesAPIs/DiseaseStatus";
  static const getGeneticDiseasesBasedOnClassification =
      "GeneticDiseasesAPIs/arabic-names";

  static const postGeneticDiseasesDataEntry =
      "GeneticDiseasesAPIs/medical-history";
  static const uploadFamilyMemebersNumber =
      "GeneticDiseasesAPIs/family-relation";
  static const postGenticDiseaseForFamilyMember =
      "GeneticDiseasesAPIs/family-tree";
  static const getFamilyMembersNumbers = "GeneticDiseasesAPIs/family-relation";
  static const editPersonalGeneticDiseases =
      "GeneticDiseasesAPIs/medical-history";
  static const editGeneticDiseasesForFamilyMember =
      "GeneticDiseasesAPIs/family-tree-name-code";
  static const editNoOfFamilyMembers = "GeneticDiseasesAPIs/family-relation";
  //View Entry

  //filters

  static const familyMembersName = "GeneticDiseasesAPIs/all-names";
  static const familyMembeberGenaticDisease =
      "GeneticDiseasesAPIs/classifications";
  static const getFamilyMembersGeneticDiseasesDetails =
      "GeneticDiseasesAPIs/genetic-disease-details-by-disease-type";
}
