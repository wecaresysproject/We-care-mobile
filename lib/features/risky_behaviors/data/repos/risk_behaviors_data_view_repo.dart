import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/risk_behaviors_service.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behavior_models.dart';
import 'package:we_care/features/risky_behaviors/data/models/risky_behaviors_view_response_model.dart';

class RiskBehaviorsDataViewRepo {
  final RiskBehaviorsServices _riskBehaviorsServices;

  RiskBehaviorsDataViewRepo(this._riskBehaviorsServices);

  /// Fetches user risky behaviors submissions from backend.
  /// Maps the grouped API response (sections → types) into a flat list
  /// of [RiskyBehaviorDetailsModel] for the view layer.
  Future<ApiResult<List<RiskyBehaviorDetailsModel>>>
      getUserRiskBehaviorsData() async {
    try {
      final response = await _riskBehaviorsServices.getUserRiskBehaviorsData();
      final dataList = response['data'] as List;

      final List<RiskyBehaviorSectionResponse> sections = dataList
          .map((e) =>
              RiskyBehaviorSectionResponse.fromJson(e as Map<String, dynamic>))
          .toList();

      // Flatten sections → types into a flat list of RiskyBehaviorDetailsModel
      final List<RiskyBehaviorDetailsModel> flatBehaviors = [];

      for (final section in sections) {
        for (final typeEntry in section.types) {
          flatBehaviors.add(
            RiskyBehaviorDetailsModel(
              id: typeEntry.id,
              section: section.section,
              type: typeEntry.type,
              records: typeEntry.records,
              attachToDrugInteractionModules:
                  typeEntry.attachToDrugInteractionModules,
            ),
          );
        }
      }

      return ApiResult.success(flatBehaviors);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
