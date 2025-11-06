import 'dart:io';

import 'package:we_care/core/models/upload_image_response_model.dart';
import 'package:we_care/features/prescription/data/models/prescription_request_body_model.dart';
import 'package:we_care/features/prescription/prescription_services.dart';

import '../../../../core/networking/api_error_handler.dart';
import '../../../../core/networking/api_result.dart';

class PrescriptionDataEntryRepo {
  final PrescriptionServices _prescriptionServices;

  PrescriptionDataEntryRepo(this._prescriptionServices);

  Future<ApiResult<UploadImageResponseModel>> uploadPrescriptionImage({
    required String language,
    required String contentType,
    required File image,
  }) async {
    try {
      final response = await _prescriptionServices.uploadPrescriptionImage(
        image,
        contentType,
        language,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postPrescriptionDataEntry(
      PrescriptionRequestBodyModel requestBody) async {
    try {
      final response =
          await _prescriptionServices.postPrescriptionDataEntry(requestBody);
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> updatePrescriptionDocumentDetails({
    required PrescriptionRequestBodyModel requestBody,
    required String documentId,
  }) async {
    try {
      final response =
          await _prescriptionServices.updatePrescriptionDocumentDetails(
        requestBody,
        requestBody.language,
        requestBody.userType,
        documentId,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
