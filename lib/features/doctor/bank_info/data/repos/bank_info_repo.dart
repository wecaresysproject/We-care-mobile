import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/bank_info/data/models/bank_account_model.dart';
import 'package:we_care/features/doctor/bank_info/data/models/bank_info_request_body_model.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/shared/logic/profile_form_edit_helpers.dart';

class BankInfoRepo {
  final DoctorServices _doctorServices;

  BankInfoRepo(this._doctorServices);

  /// The doctor's saved bank accounts; empty when the module wasn't filled yet.
  Future<ApiResult<List<BankAccountModel>>> getBankInfo() async {
    try {
      final response = await _doctorServices.getBankInfo();
      final data = profileResponseData(response);
      if (data is! Map<String, dynamic>) return ApiResult.success(const []);
      return ApiResult.success(
        BankInfoRequestBodyModel.fromJson(data).bankAccounts,
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> submitBankInfo(
    BankInfoRequestBodyModel model,
  ) async {
    try {
      final response = await _doctorServices.postBankInfo(model);
      final message = response is Map ? response['message'] : null;
      return ApiResult.success(
        message is String ? message : 'تم حفظ البيانات بنجاح',
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
