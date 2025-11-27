import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/faq/models/faq_model.dart';
import 'package:we_care/features/faq/services/faq_service.dart';

class FAQRepository {
  final FAQService _faqService;

  FAQRepository(this._faqService);

  Future<ApiResult<List<FAQModel>>> getFaq() async {
    try {
      final response = await _faqService.getFaqList(
        userType: 'Patient',
        language: 'en',
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
