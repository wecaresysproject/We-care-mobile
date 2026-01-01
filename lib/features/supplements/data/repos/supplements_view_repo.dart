import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/supplements/data/models/effects_on_nutrients_model.dart';
import 'package:we_care/features/supplements/data/models/vitamins_and_supplements_models.dart';
import 'package:we_care/features/supplements/supplements_services.dart';

class SupplementsViewRepo {
  final SupplementsServices services;

  SupplementsViewRepo({required this.services});

  Future<ApiResult<List<String>>> getAvailableDateRanges({
    required String language,
  }) async {
    try {
      final response = await services.getAvailableDateRanges(
        language,
      );
      final years = (response['data'] as List).map<String>((e) => e).toList();
      return ApiResult.success(years);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<EffectsOnNutrientsModel>>> getEffectsOnNutrients({
    required String language,
    String? range,
  }) async {
    try {
      final response = await services.getEffectsOnNutrients(
        language,
        range: range,
      );
      final data = (response['data'] as List)
          .map((e) => EffectsOnNutrientsModel.fromJson(e))
          .toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<VitaminsAndSupplementsModel>> getVitaminsAndSupplements({
    required String language,
    String? range,
  }) async {
    try {
      final response =
          await services.getVitaminsAndSupplements(language, range: range);
      final data = VitaminsAndSupplementsModel.fromJson(response['data']);
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
