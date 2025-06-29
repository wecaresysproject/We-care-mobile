import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_essential_data_request_body_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_lens_data_request_body_model.dart';
import 'package:we_care/features/eyes/eyes_api_constants.dart';
import 'package:we_care/features/surgeries/data/models/surgery_request_body_model.dart';
import 'package:we_care/features/surgeries/surgeries_api_constants.dart';

part 'eyes_services.g.dart';

@RestApi(baseUrl: EyesApiConstants.baseUrl)
abstract class EyesModuleServices {
  factory EyesModuleServices(Dio dio, {String baseUrl}) = _EyesModuleServices;

  @GET("http://147.93.57.70/api/countries")
  Future<dynamic> getCountries(@Query('language') String language);

  @MultiPart()
  @POST(SurgeriesApiConstants.uploadReportEndpoint)
  Future<UploadReportResponseModel> uploadReportImage(
    @Part() File report,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @POST(EyesApiConstants.postGlassesEssentialDataEntryEndPoint)
  Future<dynamic> postGlassesEssentialDataEntryEndPoint(
    @Query("language") String language,
    @Query("UserType") String userType,
    @Body() EyeGlassesEssentialDataRequestBodyModel requestBody,
  );
  @POST(EyesApiConstants.postGlassesLensDataEntryEndPoint)
  Future<dynamic> postGlassesLensDataEntry(
    @Query("language") String language,
    @Query("UserType") String userType,
    @Body() EyeGlassesLensDataRequestBodyModel requestBody,
  );

  @GET(EyesApiConstants.getAllLensSurfaces)
  Future<dynamic> getAllLensSurfaces(
    @Query("language") String language,
    @Query("UserType") String userType,
  );
  @GET(EyesApiConstants.getAllLensTypes)
  Future<dynamic> getAllLensTypes(
    @Query("language") String language,
    @Query("UserType") String userType,
  );
  @GET(EyesApiConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
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

  // @GET(SurgeriesApiConstants.getSurgeriesFilters)
  // Future<dynamic> getFilters(@Query("language") String language);

  // @GET(SurgeriesApiConstants.getFilteredSurgeries)
  // Future<GetUserSurgeriesResponseModal> getFilteredSurgeries(
  //     @Query("language") String language,
  //     @Query("surgeryName") String? surgeryName,
  //     @Query("year") int? year);

  // @DELETE(SurgeriesApiConstants.deleteSurgeryById)
  // Future<dynamic> deleteSurgeryById(@Query("id") String id);

  // @PUT(SurgeriesApiConstants.editSurgeryEndpoint)
  // Future<dynamic> updateSurgeryDocumentById(
  //   @Query("id") String id,
  //   @Query("language") String language,
  //   @Body() SurgeryRequestBodyModel requestBody,
  // );
}
