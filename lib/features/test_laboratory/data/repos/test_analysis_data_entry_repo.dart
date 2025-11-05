import 'dart:developer';
import 'dart:io';

import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_analysis_request_body_model.dart';
import 'package:we_care/features/test_laboratory/data/models/test_table_model.dart';
import 'package:we_care/features/test_laboratory/test_analysis_services.dart';

class TestAnalysisDataEntryRepo {
  final TestAnalysisSerices _testAnalysisSerices;
  final SharedServices _sharedServices;

  TestAnalysisDataEntryRepo(this._testAnalysisSerices, this._sharedServices);

  Future<ApiResult<List<String>>> getCountriesData({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getCountriesNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final countries = (response['data'] as List)
          .map((country) => country as String)
          .toList();
      log("xxx: countries from repo: $countries");
      return ApiResult.success(countries);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getLabCenters({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getLabCenters(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final labs =
          (response['data'] as List).map((lab) => lab as String).toList();
      log("xxx: labs from repo: $labs");
      return ApiResult.success(labs);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getHospitalNames({
    required String language,
  }) async {
    try {
      final response = await _sharedServices.getHospitalNames(
        UserTypes.patient.name.firstLetterToUpperCase,
        language,
      );
      final hospitals = (response['data'] as List)
          .map((hospital) => hospital as String)
          .toList();
      log("xxx: hospitals from repo: $hospitals");
      return ApiResult.success(hospitals);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

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

  Future<ApiResult<List<String>>> getAllDoctors({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _sharedServices.getDoctorNames(
        userType,
        language,
      );
      final doctors = (response['data'] as List)
          .map<Doctor>((e) => Doctor.fromJson(e))
          .toList();
      final doctorNames = doctors.map((e) => e.fullName).toList();
      return ApiResult.success(doctorNames);
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
