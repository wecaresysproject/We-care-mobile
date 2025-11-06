import 'dart:developer';
import 'dart:io';

import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/test_laboratory/data/models/test_analysis_request_body_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_services.dart';

class TestAnalysisDataEntryRepo {
  final TestAnalysisSerices _testAnalysisSerices;

  TestAnalysisDataEntryRepo(this._testAnalysisSerices);

  Future<ApiResult<UploadImageResponseModel>> uploadLaboratoryTestImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _testAnalysisSerices.uploadLaboratoryTestImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadReportResponseModel>> uploadLaboratoryReportImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _testAnalysisSerices.uploadLaboratoryReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getListOFTestAnnotations(
      {required String language, required String userType}) async {
    try {
      final response = await _testAnalysisSerices.getListOFTestAnnotations(
        language,
        userType,
      );
      return ApiResult.success(response.codesData);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getListOfTestGroupNames(
      {required String language, required String userType}) async {
    try {
      final response = await _testAnalysisSerices.getListOfTestGroupNames(
        language,
        userType,
      );
      return ApiResult.success(response.groupNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getListOfTestNames(
      {required String language, required String userType}) async {
    try {
      final response = await _testAnalysisSerices.getListOfTestNames(
        language,
        userType,
      );
      return ApiResult.success(response.testNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<TableRowReponseModel>>> getTableDetails({
    required String language,
    required String userType,
    String? testNameQuery,
    String? groupNameQuery,
    String? codeQuery,
  }) async {
    try {
      final response = await _testAnalysisSerices.getTableDetails(
        language,
        userType,
        testNameQuery,
        groupNameQuery,
        codeQuery,
      );
      log(" xxx getTableDetails response : $response");
      return ApiResult.success(response.testTableRowsData);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postLaboratoryTestDataEntrered(
      {required TestAnalysisDataEnteryRequestBodyModel
          testAnalysisRequestBodyModel}) async {
    try {
      final response = await _testAnalysisSerices
          .postLaboratoryTestDataEntrered(testAnalysisRequestBodyModel);
      log('postData response : $response');
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editLaboratoryTestData({
    required EditTestAnalysisDataEnteryRequestBodyModel requestBodyModel,
    required String language,
    required String testId,
  }) async {
    try {
      final response = await _testAnalysisSerices.updateTestAnalysis(
        requestBodyModel,
        language,
        testId,
      ) as Map<String, dynamic>;
      log('postData response : $response');
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
