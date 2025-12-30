import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
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
}
