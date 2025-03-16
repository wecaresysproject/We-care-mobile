import '../../emergency_complaints_services.dart';

class EmergencyComplaintsDataEntryRepo {
  final EmergencyComplaintsServices _emergencyComplaintsServices;

  EmergencyComplaintsDataEntryRepo(this._emergencyComplaintsServices);

  // Future<ApiResult<String>> postPrescriptionDataEntry(
  //     PrescriptionRequestBodyModel requestBody) async {
  //   try {
  //     final response =
  //         await _prescriptionServices.postPrescriptionDataEntry(requestBody);
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> updatePrescriptionDocumentDetails({
  //   required PrescriptionRequestBodyModel requestBody,
  //   required String documentId,
  // }) async {
  //   try {
  //     final response =
  //         await _prescriptionServices.updatePrescriptionDocumentDetails(
  //       requestBody,
//       requestBody.language,
  //       requestBody.userType,
  //       documentId,
  //     );
  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
