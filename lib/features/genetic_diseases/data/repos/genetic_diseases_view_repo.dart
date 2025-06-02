import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
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
}
