import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/add_new_user_to_family_tree_request_body.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genetic_diseases_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_members_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_constants.dart';

part 'genetic_diseases_services.g.dart';

@RestApi(baseUrl: GeneticDiseasesConstants.baseUrl)
abstract class GeneticDiseasesServices {
  factory GeneticDiseasesServices(Dio dio, {String? baseUrl}) =
      _GeneticDiseasesServices;

  @GET(GeneticDiseasesConstants.getAllCountries)
  Future<dynamic> getCountries(
    @Query('language') String language,
  );
  @GET(GeneticDiseasesConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(GeneticDiseasesConstants.getAllGeneticDiseasesClassfications)
  Future<dynamic> getAllGeneticDiseasesClassfications(
    @Query("language") String language,
  );
  @GET(GeneticDiseasesConstants.getAllGeneticDiseasesStatus)
  Future<dynamic> getAllGeneticDiseasesStatus(
    @Query("language") String language,
  );
  @GET(GeneticDiseasesConstants.getGeneticDiseasesBasedOnClassification)
  Future<dynamic> getGeneticDiseasesBasedOnClassification(
    @Query("language") String language,
    @Query("medicalClassification") String medicalClassification,
  );

  @MultiPart()
  @POST("http://147.93.57.70:5299/m2/api/FileUpload/upload-image")
  Future<UploadImageResponseModel> uploadFirstImage(
    @Part(name: "image") File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @MultiPart()
  @POST("http://147.93.57.70/api/FileUpload/upload-image")
  Future<UploadImageResponseModel> uploadSecondImage(
    @Part(name: "image") File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @MultiPart()
  @POST("http://147.93.57.70:5299/m2/api/FileUpload/upload-report")
  Future<UploadReportResponseModel> uploadReportImage(
    @Part(name: 'report') File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );

  @POST(GeneticDiseasesConstants.postGeneticDiseasesDataEntry)
  Future<dynamic> postGeneticDiseasesDataEntry(
    @Body() PersonalGeneticDiseaseRequestBodyModel requestBodyModel,
  );

  @GET(GeneticDiseasesConstants.familyMembersName)
  Future<dynamic> getFamilyMembersNames(
    @Query("language") String language,
    @Query("userType") String userType,
  );

  @GET(GeneticDiseasesConstants.familyMembeberGenaticDisease)
  Future<dynamic> getFamilyMemberGeneticDisease(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("name") String familyMemberName,
    @Query("code") String code,
  );

  @GET(GeneticDiseasesConstants.getFamilyMembersGeneticDiseasesDetails)
  Future<dynamic> getFamilyMembersGeneticDiseasesDetails(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("diseaseType") String diseaseType,
  );
  @PUT(GeneticDiseasesConstants.editGenticDiseaseForFamilyMember)
  Future<dynamic> editGenticDiseaseForFamilyMember(
    @Body() FamilyMemberGeneticDiseasesRequestBodyModel requestBody,
    @Query("name") String familyMemberName,
    @Query("code") String code,
  );
  @GET(GeneticDiseasesConstants.getFamilyMembersNumbers)
  Future<dynamic> getFamilyMembersNumbers(
    @Query("language") String language,
  );
  @PUT(GeneticDiseasesConstants.editPersonalGeneticDiseases)
  Future<dynamic> editPersonalGeneticDiseases(
    @Query("id") String id,
    @Query("language") String language,
    @Body() PersonalGeneticDiseaseRequestBodyModel requestBody,
  );
  @PUT(GeneticDiseasesConstants.editGeneticDiseasesForFamilyMember)
  Future<dynamic> editGeneticDiseasesForFamilyMember(
    @Query("name") String memberName,
    @Query("code") String memberCode,
    @Query("language") String language,
    @Body() FamilyMemberGeneticsDiseasesResponseModel requestBody,
  );
  @PUT(GeneticDiseasesConstants.editNoOfFamilyMembers)
  Future<dynamic> editNoOfFamilyMembers(
    @Body() FamilyMembersModel requestBody,
  );

  @GET(GeneticDiseasesConstants.getpersonalGeneticDiseaseDetails)
  Future<dynamic> getpersonalGeneticDiseaseDetails(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("geneticDisease") String diseaseType,
  );

  @DELETE(GeneticDiseasesConstants.deleteFamilyMemberbyNameAndCode)
  Future<dynamic> deleteFamilyMemberbyNameAndCode(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("name") String name,
    @Query("code") String code,
  );

  @GET(GeneticDiseasesConstants.getpersonalGeneticDiseases)
  Future<dynamic> getpersonalGeneticDiseases(
    @Query("language") String language,
    @Query("userType") String userType,
  );

  @DELETE(
      GeneticDiseasesConstants.deleteFamilyMemberGeneticDiseasebyNameAndCode)
  Future<dynamic> deleteFamilyMemberGeneticDiseasebyNameAndCode(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("name") String name,
    @Query("code") String code,
    @Query("geneticDisease") String geneticDisease,
  );
  @GET(GeneticDiseasesConstants.getIsFirstTimeAnsweredFamilyMembersQuestions)
  Future<dynamic> getIsFirstTimeAnsweredFamilyMembersQuestions();

  @POST(GeneticDiseasesConstants.addNewUsertoFamilyTree)
  Future<dynamic> addNewUsertoFamilyTree(
    @Body() AddNewUserToFamilyTreeRequestBodyModel requestBody,
    @Query("language") String language,
  );
}
