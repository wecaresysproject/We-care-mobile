import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/dental_module/dental_api_constants.dart';

part 'dental_services.g.dart';

@RestApi(baseUrl: DentalApiConstants.baseUrl)
abstract class DentalService {
  factory DentalService(Dio dio, {String? baseUrl}) = _DentalService;

  @GET(DentalApiConstants.getAllCountries)
  Future<dynamic> getCountries(
    @Query('language') String language,
  );

  @MultiPart()
  @POST(DentalApiConstants.uploadReportEndpoint)
  Future<UploadReportResponseModel> uploadTeethReport(
    @Part() File report,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );

  @GET(DentalApiConstants.getAllMainMedicalProcedures)
  Future<dynamic> getAllMainMedicalProcedures(
    @Query("usertype") String userType,
    @Query("language") String language,
  );
  @GET(DentalApiConstants.getAllsecondaryMedicalProcedure)
  Future<dynamic> getAllSecondaryMedicalProcedure(
    @Query("MainProcedure") String mainProcedure,
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
  @GET(DentalApiConstants.getAllDoctors)
  Future<dynamic> getAllDoctors(
    @Query("usertype") String userType,
    @Query("Language") String language,
  );
}
