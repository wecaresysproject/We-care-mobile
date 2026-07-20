import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/core/networking/auth_service.dart';
import 'package:we_care/features/home_tab/models/message_notification_model.dart';
import 'package:we_care/features/home_tab/services/home_service.dart';

class HomeRepository {
  final HomeService _homeService;
  final AuthApiServices _authApiServices;

  HomeRepository(this._homeService, this._authApiServices);

  Future<ApiResult<List<CrausalMessageModel>>> getMessageNotifications() async {
    try {
      final response = await _homeService.getMessageNotifications(
        'Patient',
        'ar',
      );

      if (response['success'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        final notifications =
            data.map((e) => CrausalMessageModel.fromJson(e)).toList();
        return ApiResult.success(notifications);
      } else {
        return ApiResult.success([]);
      }
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAds() async {
    try {
      final response = await _homeService.getAds(
        'Patient',
        'ar',
      );

      return ApiResult.success(List<String>.from(response['data'] ?? []));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<dynamic>> logout() async {
    try {
      final response = await _authApiServices.logout();
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
