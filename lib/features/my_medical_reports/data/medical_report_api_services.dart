import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/features/my_medical_reports/data/medical_report_api_constants.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_filter_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_request_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';

part 'medical_report_api_services.g.dart';

@RestApi(baseUrl: MedicalReportApiConstants.baseUrl)
abstract class MedicalReportApiServices {
  factory MedicalReportApiServices(Dio dio, {String? baseUrl}) =
      _MedicalReportApiServices;

  @GET(MedicalReportApiConstants.getPersonalDataFilters)
  Future<MedicalReportFilterResponseModel> getPersonalDataFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getMedicinesFilters)
  Future<MedicalReportFilterResponseModel> getMedicinesFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @POST(MedicalReportApiConstants.fetchData)
  Future<MedicalReportResponseModel> fetchMedicalReportData(
    @Body() MedicalReportRequestModel requestBody,
    @Query('language') String language,
  );
}
