import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';
import 'package:we_care/features/supplements/supplements_services.dart';

class SupplementsDataEntryRepo {
  final SupplementsServices services;

  SupplementsDataEntryRepo({required this.services});

  Future<ApiResult<List<String>>> retrieveAvailableVitamins({
    required String language,
  }) async {
    try {
      final response = await services.retrieveAvailableVitamins(language);
      final data = (response['data'] as List).map<String>((e) => e).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitSelectedSupplements({
    required List<SupplementEntry> supplements,
  }) async {
    try {
      final response = await services.submitSelectedSupplements(supplements);
      return ApiResult.success(response['message'] as String);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
