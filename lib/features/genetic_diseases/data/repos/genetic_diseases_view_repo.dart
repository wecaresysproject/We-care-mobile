import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatic_disease_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/family_member_genatics_diseases_response_model.dart';
import 'package:we_care/features/genetic_diseases/data/models/get_family_members_names.dart';
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
}
