import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/delete_analysis_document_response.dart';
import 'package:we_care/features/test_laboratory/data/models/get_analysis_by_id_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_similar_tests_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/get_user_analysis_response_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_analysis_request_body_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_code_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_group_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_name_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_api_constants.dart';

part 'test_analysis_services.g.dart';

@RestApi(baseUrl: TestAnalysisApiConstants.baseUrl)
abstract class TestAnalysisSerices {
  factory TestAnalysisSerices(Dio dio, {String? baseUrl}) =
      _TestAnalysisSerices;

  @GET(TestAnalysisApiConstants.getYearsFilter)
  Future<dynamic> getYearsFilter();

  @GET(TestAnalysisApiConstants.getUserTests)
  Future<GetUserAnalysisReponseModel> getUserTests(
    @Query('language') String language,
  );

  @GET(TestAnalysisApiConstants.getFilteredTestsByYear)
  Future<GetUserAnalysisReponseModel> getFilteredTestsByYear(
    @Query('language') String language,
    @Query('year') int year,
  );

  @GET(TestAnalysisApiConstants.getTestbyId)
  Future<GetAnalysisByIdResponseModel> getTestbyId(
    @Query('id') String id,
    @Query('language') String language,
  );

  @DELETE(TestAnalysisApiConstants.deleteAnalysisById)
  Future<DeleteAnalysisDocumentResponse> deleteAnalysisById(
    @Query('id') String id,
    @Query('language') String language,
  );

  @GET(TestAnalysisApiConstants.getSimilarTests)
  Future<GetSimilarTestsResponseModel> getSimilarTests(
    @Query('language') String language,
    @Query('testName') String testName,
  );

  @GET(TestAnalysisApiConstants.getTestAnnotationsEndpoint)
  Future<TestCodeModel> getListOFTestAnnotations(
    @Query("language") String language,
    @Query("UserType") String userType,
  );
  @GET(TestAnalysisApiConstants.getTestByGroupNamesEndpoint)
  Future<TestGroupModel> getListOfTestGroupNames(
    @Query("language") String language,
    @Query("UserType") String userType,
  );

  @GET(TestAnalysisApiConstants.getTestNamesEndpoint)
  Future<TestNameModel> getListOfTestNames(
    @Query("language") String language,
    @Query("UserType") String userType,
  );

  @GET(TestAnalysisApiConstants.getTableOfDataEndpoint)
  Future<TestTableReponseModel> getTableDetails(
    @Query("language") String language,
    @Query("userType") String? userType,
    @Query("testName") String? testNameQuery,
    @Query("groupName") String? groupNameQuery,
    @Query("code") String? codeQuery,
  );
  @GET("http://147.93.57.70/api/countries")
  Future<dynamic> getCountries(
    @Query('language') String language,
  );
  @MultiPart()
  @POST(TestAnalysisApiConstants.uploadLaboratoryTestImageEndpoint)
  Future<UploadImageResponseModel> uploadLaboratoryTestImage(
    @Part() File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @MultiPart()
  @POST(TestAnalysisApiConstants.uploadLaboratoryTestReportEndpoint)
  Future<UploadReportResponseModel> uploadLaboratoryReportImage(
    @Part(name: 'report') File image,
    @Header("Content-Type") String contentType,
    @Query("language") String language,
  );
  @POST(TestAnalysisApiConstants.postTestAnalysisEndpoint)
  Future<dynamic> postLaboratoryTestDataEntrered(
    @Body() TestAnalysisDataEnteryRequestBodyModel testAnalysisRequestBodyModel,
  );
}
