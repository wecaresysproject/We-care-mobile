import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/shared_services.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/essential_info/data/models/user_essential_info_request_body_model.dart';
import 'package:we_care/features/essential_info/essential_info_services.dart';

class EssentialInfoDataEntryRepo {
  final EssentialInfoServices essentialInfoServices;
  final SharedServices sharedServices;

  EssentialInfoDataEntryRepo(this.essentialInfoServices, this.sharedServices);

  Future<ApiResult<String>> postUserEssentialInfo(
    UserEssentialInfoRequestBodyModel requestBody,
    String language,
  ) async {
    try {
      final response = await essentialInfoServices.postUserEssentialInfo(
        requestBody,
        language,
        UserTypes.patient.name.firstLetterToUpperCase,
      );
      return ApiResult.success(
        response['message'],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> updateUserEssentialInfo(
    UserEssentialInfoRequestBodyModel requestBody,
    String language,
    String documentId,
  ) async {
    try {
      final response = await essentialInfoServices.updateUserEssentialInfo(
        requestBody,
        language,
        UserTypes.patient.name.firstLetterToUpperCase,
        documentId,
      );
      return ApiResult.success(
        response['message'],
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
