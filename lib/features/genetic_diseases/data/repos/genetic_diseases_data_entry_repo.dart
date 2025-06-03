import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_count_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genetic_diseases_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_members_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_request_body_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_services.dart';

class GeneticDiseasesDataEntryRepo {
  final GeneticDiseasesServices _geneticDiseasesServices;

  GeneticDiseasesDataEntryRepo(this._geneticDiseasesServices);
  Future<ApiResult<List<String>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _geneticDiseasesServices.getCountries(language);
      final countries = (response['data'] as List)
          .map<CountryModel>((e) => CountryModel.fromJson(e))
          .toList();
      final countriesNames = countries.map((e) => e.name).toList();
      return ApiResult.success(countriesNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllDoctors({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getAllDoctors(
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

  Future<ApiResult<List<String>>> getAllGeneticDiseasesClassfications({
    required String language,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.getAllGeneticDiseasesClassfications(
        language,
      );
      final classifications =
          (response['data'] as List).map<String>((e) => e.toString()).toList();

      return ApiResult.success(classifications);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllGeneticDiseasesStatus({
    required String language,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.getAllGeneticDiseasesStatus(
        language,
      );
      final diseaseStatuses =
          (response['data'] as List).map<String>((e) => e.toString()).toList();

      return ApiResult.success(diseaseStatuses);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getGeneticDiseasesBasedOnClassification({
    required String language,
    required String diseaseClassification,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .getGeneticDiseasesBasedOnClassification(
        language,
        diseaseClassification,
      );
      final diseaseStatuses =
          (response['data'] as List).map<String>((e) => e.toString()).toList();

      return ApiResult.success(diseaseStatuses);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadFirstImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _geneticDiseasesServices.uploadFirstImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadImageResponseModel>> uploadSecondImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _geneticDiseasesServices.uploadSecondImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<UploadReportResponseModel>> uploadReportImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _geneticDiseasesServices.uploadReportImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitPersonalGeneticDiseaseRequest({
    required PersonalGeneticDiseaseRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .postGeneticDiseasesDataEntry(requestBody);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> uploadFamilyMemebersNumber({
    required FamilyMembersModel requestBody,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .uploadFamilyMemebersNumber(requestBody);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postGenticDiseaseForFamilyMember({
    required FamilyMemberGeneticDiseasesRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .postGenticDiseaseForFamilyMember(requestBody);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<FamilyMemberCount>> getFamilyMembersNumbers({
    required String language,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getFamilyMembersNumbers(
        language,
      );
      return ApiResult.success(FamilyMemberCount.fromJson(response['data']));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
