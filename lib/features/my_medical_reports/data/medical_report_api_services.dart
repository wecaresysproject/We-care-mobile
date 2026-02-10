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

  @GET(MedicalReportApiConstants.getVitalSignsFilters)
  Future<MedicalReportFilterResponseModel> getVitalSignsFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getChronicDiseasesFilters)
  Future<MedicalReportFilterResponseModel> getChronicDiseasesFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getUrgentComplaintsFilters)
  Future<MedicalReportFilterResponseModel> getUrgentComplaintsFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getRadiologyFilters)
  Future<MedicalReportFilterResponseModel> getRadiologyFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getMedicalTestsFilters)
  Future<MedicalReportFilterResponseModel> getMedicalTestsFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getPrescriptionsFilters)
  Future<MedicalReportFilterResponseModel> getPrescriptionsFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getSurgeriesFilters)
  Future<MedicalReportFilterResponseModel> getSurgeriesFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getGeneticDiseasesFilters)
  Future<MedicalReportFilterResponseModel> getGeneticDiseasesFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getAllergyFilters)
  Future<MedicalReportFilterResponseModel> getAllergyFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getEyesFilters)
  Future<MedicalReportFilterResponseModel> getEyesFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getTeethFilters)
  Future<MedicalReportFilterResponseModel> getTeethFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getSmartNutritionFilters)
  Future<dynamic> getSmartNutritionFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getSupplementsFilters)
  Future<dynamic> getSupplementsFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getPhysicalActivityFilters)
  Future<dynamic> getPhysicalActivityFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @GET(MedicalReportApiConstants.getMentalDiseasesFilters)
  Future<MedicalReportFilterResponseModel> getMentalDiseasesFilters(
    @Query('language') String language,
    @Query('userType') String userType,
  );

  @POST(MedicalReportApiConstants.fetchData)
  Future<MedicalReportResponseModel> fetchMedicalReportData(
    @Body() MedicalReportRequestModel requestBody,
    @Query('language') String language,
  );
}
