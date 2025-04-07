import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/surgeries/data/models/get_user_surgeries_response_model.dart';
import 'package:we_care/features/surgeries/data/models/surgery_request_body_model.dart';
import 'package:we_care/features/surgeries/surgeries_api_constants.dart';

part 'surgeries_services.g.dart';

@RestApi(baseUrl: SurgeriesApiConstants.baseUrl)
abstract class SurgeriesService {
  factory SurgeriesService(Dio dio, {String baseUrl}) = _SurgeriesService;

  @GET("http://147.93.57.70/api/countries")
  Future<dynamic> getCountries(@Query('language') String language);

  @MultiPart()
  @POST(SurgeriesApiConstants.uploadReportEndpoint)
  Future<UploadReportResponseModel> uploadReportImage(
    @Part() File report,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @GET(SurgeriesApiConstants.getAllSurgeriesRegions)
  Future<dynamic> getAllSurgeriesRegions(
    @Query("language") String language,
  );
  @GET(SurgeriesApiConstants.getSubSurgeriesRegions)
  Future<dynamic> getAllSubSurgeriesRegions(
    @Query("surgeryRegion") String region,
    @Query("language") String language,
  );
  @GET(SurgeriesApiConstants.getAllTechUsed)
  Future<dynamic> getAllTechUsed(
    @Query("surgeryRegion") String region,
    @Query("subSurgeryRegion") String subSurgeryRegion,
    @Query("surgeryName") String surgeryName,
    @Query("language") String language,
  );

  @GET(SurgeriesApiConstants.getSurgeryStatus)
  Future<dynamic> getSurgeryStatus(
    @Query("language") String language,
  );
  @GET(SurgeriesApiConstants.getSurgeryName)
  Future<dynamic> getSurgeryNameBasedOnRegion(
    @Query("surgeryRegion") String region,
    @Query("subSurgeryRegion") String subSurgeryRegion,
    @Query("language") String language,
  );

  @GET(SurgeriesApiConstants.getAllSurgeries)
  Future<GetUserSurgeriesResponseModal> getSurgeries(
    @Query("language") String language,
  );
  @GET(SurgeriesApiConstants.surgeryPurpose)
  Future<dynamic> getSurgeryPurpose(
    @Query("surgeryRegionName") String region,
    @Query("subSurgeryRegionName") String subSurgeryRegion,
    @Query("surgeryNameName") String surgeryName,
    @Query("usedTechniqueName") String techUsed,
    @Query("language") String language,
  );
  @POST(SurgeriesApiConstants.postSurgeryEndpoint)
  Future<dynamic> postSurgeryData(
    @Query("language") String language,
    @Body() SurgeryRequestBodyModel requestBody,
  );

  @GET(SurgeriesApiConstants.getSingleSurgery)
  Future<dynamic> getSurgeryById(
      @Query("id") String id, @Query("language") String language);

  @GET(SurgeriesApiConstants.getSurgeriesFilters)
  Future<dynamic> getFilters(@Query("language") String language);

  @GET(SurgeriesApiConstants.getFilteredSurgeries)
  Future<GetUserSurgeriesResponseModal> getFilteredSurgeries(
      @Query("language") String language,
      @Query("surgeryName") String? surgeryName,
      @Query("year") int? year);

  @DELETE(SurgeriesApiConstants.deleteSurgeryById)
  Future<dynamic> deleteSurgeryById(@Query("id") String id);

  @PUT(SurgeriesApiConstants.editSurgeryEndpoint)
  Future<dynamic> updateSurgeryDocumentById(
    @Query("id") String id,
    @Query("language") String language,
    @Body() SurgeryRequestBodyModel requestBody,
  );
}
