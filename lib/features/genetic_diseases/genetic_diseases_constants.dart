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
  static const editGenticDiseaseForFamilyMember =
      "GeneticDiseasesAPIs/family-tree-name-code";
  static const getFamilyMembersNumbers = "GeneticDiseasesAPIs/family-relation";
  static const editPersonalGeneticDiseases =
      "GeneticDiseasesAPIs/medical-history";
  static const editGeneticDiseasesForFamilyMember =
      "GeneticDiseasesAPIs/family-tree-name-code";
  static const editNoOfFamilyMembers = "GeneticDiseasesAPIs/family-relation";
  static const getIsFirstTimeAnsweredFamilyMembersQuestions =
      "GeneticDiseasesAPIs/family-relation/first-time-check";
  static const addNewUsertoFamilyTree = "GeneticDiseasesAPIs/family-add";
  //View Entry

  //filters

  static const familyMembersName = "GeneticDiseasesAPIs/all-names";
  static const familyMembeberGenaticDisease =
      "GeneticDiseasesAPIs/classifications";
  static const getFamilyMembersGeneticDiseasesDetails =
      "GeneticDiseasesAPIs/genetic-disease-details-by-disease-type";
  static const getpersonalGeneticDiseaseDetails =
      "GeneticDiseasesAPIs/medical-history";
  static const deleteFamilyMemberbyNameAndCode =
      "GeneticDiseasesAPIs/family-tree";
  static const getpersonalGeneticDiseases='GeneticDiseasesAPIs/family-member-recommendations' ; 
  static const deleteFamilyMemberGeneticDiseasebyNameAndCode ="GeneticDiseasesAPIs/family-tree/with-disease";
}
