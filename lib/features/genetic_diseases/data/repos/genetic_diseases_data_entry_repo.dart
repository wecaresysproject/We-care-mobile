import 'dart:io';

import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/core/models/upload_report_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/dental_module/data/models/doctor_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/add_new_user_to_family_tree_request_body.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_count_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
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
    required String geneticDiseaseName,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.getAllGeneticDiseasesStatus(
        language,
        geneticDiseaseName,
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

  Future<ApiResult<String>> editGenticDiseaseForFamilyMember({
    required FamilyMemberGeneticDiseasesRequestBodyModel requestBody,
    required String oldMembername,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.editGenticDiseaseForFamilyMember(
        requestBody,
        oldMembername,
        requestBody.code,
      );
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

  Future<ApiResult<String>> editPersonalGeneticDiseases({
    required String id,
    required String language,
    required PersonalGeneticDiseaseRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .editPersonalGeneticDiseases(id, language, requestBody);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editGeneticDiseasesForFamilyMember({
    required String memberName,
    required String memberCode,
    required String language,
    required FamilyMemberGeneticsDiseasesResponseModel requestBody,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.editGeneticDiseasesForFamilyMember(
        memberName,
        memberCode,
        language,
        requestBody,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editNoOfFamilyMembers({
    required FamilyMembersModel requestBody,
  }) async {
    try {
      final response = await _geneticDiseasesServices.editNoOfFamilyMembers(
        requestBody,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteFamilyMemberbyNameAndCode(
    String language,
    String userType,
    String code,
    String name,
  ) async {
    try {
      final response =
          await _geneticDiseasesServices.deleteFamilyMemberbyNameAndCode(
        language,
        userType,
        name,
        code,
      );
      return ApiResult.success(response['message']);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<ApiResult<bool>> getIsFirstTimeAnsweredFamilyMembersQuestions() async {
    try {
      final response = await _geneticDiseasesServices
          .getIsFirstTimeAnsweredFamilyMembersQuestions();
      return ApiResult.success(response['isFirstTime']);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }

  Future<ApiResult<String>> addNewUsertoFamilyTree({
    required String language,
    required AddNewUserToFamilyTreeRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _geneticDiseasesServices.addNewUsertoFamilyTree(
        requestBody,
        language,
      );
      return ApiResult.success(response['message']);
    } catch (e) {
      throw ApiErrorHandler.handle(e);
    }
  }
}
