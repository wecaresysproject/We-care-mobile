import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/genetic_diseases/data/models/current_personal_genetic_diseases.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatic_disease_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_disease_detaills.dart';
import 'package:we_care/features/genetic_diseases/data/models/personal_genetic_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_services.dart';

class GeneticDiseasesViewRepo {
  final GeneticDiseasesServices _geneticDiseasesServices;
  GeneticDiseasesViewRepo(this._geneticDiseasesServices);

  Future<ApiResult<GetFamilyMembersNames>> getFamilyMembersNames(
    String language,
    String userType,
  ) async {
    try {
      final response = await _geneticDiseasesServices.getFamilyMembersNames(
        language,
        userType,
      );
      return ApiResult.success(
        GetFamilyMembersNames.fromJson(
            response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<FamilyMemberGeneticsDiseasesResponseModel>>
      getFamilyMembersGeneticDiseases(
    String language,
    String userType,
    String familyMemberCode,
    String familyMemberName,
  ) async {
    try {
      final response =
          await _geneticDiseasesServices.getFamilyMemberGeneticDisease(
        language,
        userType,
        familyMemberName,
        familyMemberCode,
      );
      return ApiResult.success(
        FamilyMemberGeneticsDiseasesResponseModel.fromJson(
            response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  //get family members genetic disease details
  Future<ApiResult<FamilyNameGeneticDiseaseDetialsResponseModel>>
      getFamilyMemberGeneticDiseaseDetails(
    String language,
    String userType,
    String disease,
  ) async {
    try {
      final response =
          await _geneticDiseasesServices.getFamilyMembersGeneticDiseasesDetails(
        language,
        userType,
        disease,
      );
      return ApiResult.success(
        FamilyNameGeneticDiseaseDetialsResponseModel.fromJson(
            response as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<PersonalGeneticDiseasDetails>>
      getPersonalGeneticDiseaseDetails(
    String language,
    String userType,
    String id,
  ) async {
    try {
      final response =
          await _geneticDiseasesServices.getpersonalGeneticDiseaseDetails(
        language,
        userType,
        id,
      );
      return ApiResult.success(
        PersonalGeneticDiseasDetails.fromJson(
            response['data'] as Map<String, dynamic>),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
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
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<String>>
      deleteFamilyMemberSpecificDiseasebyNameAndCodeAndDiseaseName(
    String language,
    String userType,
    String code,
    String name,
    String diseaseName,
  ) async {
    try {
      final response = await _geneticDiseasesServices
          .deleteFamilyMemberGeneticDiseasebyNameAndCode(
        language,
        userType,
        name,
        code,
        diseaseName,
      );
      return ApiResult.success(response['message']);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<PersonalGeneticDiseasesResponseModel>>
      getPersonalGeneticDiseases(
    String language,
    String userType,
  ) async {
    try {
      final response =
          await _geneticDiseasesServices.getpersonalGeneticDiseases(
        language,
        userType,
      );
      return ApiResult.success(
        PersonalGeneticDiseasesResponseModel.fromJson(response),
      );
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<CurrentPersonalGeneticDiseasesResponseModel>>>
      getCurrentPersonalGeneticDiseases({
    required String language,
    required String userType,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.getCurrentPersonalGeneticDiseases(
        language,
        userType,
      );
      return ApiResult.success(
        (response['data'] as List)
            .map((e) => CurrentPersonalGeneticDiseasesResponseModel.fromJson(
                e as Map<String, dynamic>))
            .toList(),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> deleteSpecificCurrentPersonalGeneticDiseaseById({
    required String language,
    required String userType,
    required String id,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .deleteSpecificCurrentPersonalGeneticDiseaseById(
        language,
        userType,
        id,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
