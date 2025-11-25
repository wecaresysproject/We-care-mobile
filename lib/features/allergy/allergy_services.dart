import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/allergy/allergy_api_constants.dart';
import 'package:we_care/features/allergy/data/models/post_allergy_module_data_model.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';

part 'allergy_services.g.dart';

@RestApi(baseUrl: AllergyApiConstants.baseUrl)
abstract class AllergyServices {
  factory AllergyServices(Dio dio, {String baseUrl}) = _AllergyServices;

  @GET("http://147.93.57.70/api/countries")
  Future<dynamic> getCountries(@Query('language') String language);

  @MultiPart()
  @POST(AllergyApiConstants.uploadReportEndpoint)
  Future<UploadReportResponseModel> uploadReportImage(
    @Part() File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @GET(AllergyApiConstants.getAllSurgeriesRegions)
  Future<dynamic> getAllSurgeriesRegions(
    @Query("language") String language,
  );
  @GET(AllergyApiConstants.getAllAllergyTypes)
  Future<dynamic> getAllAllergyTypes(
    @Query("language") String language,
    @Query("userType") String userType,
  );
  @GET(AllergyApiConstants.getExpectedSideEffects)
  Future<dynamic> getExpectedSideEffects(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("allergyType") String allergyType,
  );
  @GET(AllergyApiConstants.getAllTechUsed)
  Future<dynamic> getAllTechUsed(
    @Query("surgeryRegion") String region,
    @Query("subSurgeryRegion") String subSurgeryRegion,
    @Query("surgeryName") String surgeryName,
    @Query("language") String language,
  );

  @GET(AllergyApiConstants.getAllergyTriggers)
  Future<dynamic> getAllergyTriggers(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("allergyType") String allergyType,
  );
  @GET(AllergyApiConstants.getSurgeryName)
  Future<dynamic> getSurgeryNameBasedOnRegion(
    @Query("surgeryRegion") String region,
    @Query("subSurgeryRegion") String subSurgeryRegion,
    @Query("language") String language,
  );

  @GET(AllergyApiConstants.getAllergyDiseases)
  Future<dynamic> getAllergyDiseases(
    @Query("language") String language,
    @Query("userType") String userType,
    @Query("page") int page,
    @Query("pageSize") int pageSize,
  );
  @GET(AllergyApiConstants.surgeryPurpose)
  Future<dynamic> getSurgeryPurpose(
    @Query("surgeryRegionName") String region,
    @Query("subSurgeryRegionName") String subSurgeryRegion,
    @Query("surgeryNameName") String surgeryName,
    @Query("usedTechniqueName") String techUsed,
    @Query("language") String language,
  );
  @POST(AllergyApiConstants.postAllergyModuleData)
  Future<dynamic> postAllergyModuleData(
    @Query("language") String language,
    @Body() PostAllergyModuleDataModel requestBody,
    @Query("userType") String userType,
  );

  @GET(AllergyApiConstants.getSingleAllergyDetailsById)
  Future<dynamic> getSingleAllergyDetailsById(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
  );

  @GET(AllergyApiConstants.getSurgeriesFilters)
  Future<dynamic> getFilters(@Query("language") String language);

  @GET(AllergyApiConstants.getFilteredSurgeries)
  Future<GetUserSurgeriesResponseModal> getFilteredSurgeries(
      @Query("language") String language,
      @Query("surgeryName") String? surgeryName,
      @Query("year") int? year);

  @DELETE(AllergyApiConstants.deleteAllergyById)
  Future<dynamic> deleteAllergyById(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
  );

  @PUT(AllergyApiConstants.updateAllergyDocumentById)
  Future<dynamic> updateAllergyDocumentById(
    @Query("id") String id,
    @Query("language") String language,
    @Query("userType") String userType,
    @Body() PostAllergyModuleDataModel requestBody,
  );
}
