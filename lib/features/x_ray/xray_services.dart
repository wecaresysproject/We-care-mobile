import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/features/x_ray/data/models/user_radiology_data_reponse_model.dart';
import 'package:we_care/features/x_ray/data/models/xray_data_entry_request_body_model.dart';
import 'package:we_care/features/x_ray/xray_api_constants.dart';

import '../../core/models/upload_report_response_model.dart';
import 'data/models/body_parts_response_model.dart';

part 'xray_services.g.dart';

@RestApi(baseUrl: XrayApiConstants.baseUrl)
abstract class XRayApiServices {
  factory XRayApiServices(Dio dio, {String? baseUrl}) = _XRayApiServices;

  @GET(XrayApiConstants.getUserRadiologysData)
  Future<UserRadiologyDataResponse> getUserRadiologyData(
      @Query("language") String language, @Query("UserType") String userType,
      {@Query("page") int? page, @Query("pageSize") int? pageSize});

  @GET(XrayApiConstants.getSpecificUserRadiologyDocument)
  Future<dynamic> getSpecificUserRadiologyDocument(
    @Query("documentId") String id,
    @Query("language") String language,
    @Query("UserType") String userType,
  );

  @GET(XrayApiConstants.getFilters)
  Future<dynamic> gettFilters(@Query("language") String language);

  @GET(XrayApiConstants.getFilteredDataEndpoint)
  Future<UserRadiologyDataResponse> getFilteredData(
    @Query("language") String language,
    @Query("year") int? year,
    @Query("radioType") String? radioType,
    @Query("bodyPart") String? bodyPart,
  );

  @DELETE(XrayApiConstants.deleteXraybyid)
  Future<dynamic> deleteRadiologyDocument(
    @Query("documentId") String id,
    @Query("language") String language,
  );

  @PUT(XrayApiConstants.updateXrayDocumentDetails)
  Future<dynamic> updateRadiologyDocumentDetails(
    @Body() XrayDataEntryRequestBodyModel xrayDataEntryRequestBodyModel,
    @Query('language') String language,
    @Query('documentId') String documentId,
  );

  @GET(XrayApiConstants.getBodyParts)
  Future<List<BodyPartsResponseModel>> getBodyPartsData();

  @GET(XrayApiConstants.getRadiologyTypeByBodyPartId)
  Future<dynamic> getRadiologyTypeByBodyPartId(@Query('id') String id);

  @GET(XrayApiConstants.getCountries)
  Future<dynamic> getCountries(@Query('language') String language);

  @POST(XrayApiConstants.postRadiologyDataEntry)
  Future<dynamic> postRadiologyDataEntry(
    @Body() XrayDataEntryRequestBodyModel xrayDataEntryRequestBodyModel,
  );

  @MultiPart()
  @POST(XrayApiConstants.uploadXrayImageEndpoint)
  Future<UploadImageResponseModel> uploadRadiologyImage(
    @Part() File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );

  @MultiPart()
  @POST(XrayApiConstants.uploadXrayReportEndpoint)
  Future<UploadReportResponseModel> uploadRadiologyReportImage(
    @Part(name: 'report') File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
}
