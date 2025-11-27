import 'package:we_care/core/networking/dio_serices.dart';
import 'package:we_care/features/faq/models/faq_model.dart';

class FAQService {
  Future<List<FAQModel>> getFaqList({
    required String userType,
    required String language,
  }) async {
    try {
      final response = await DioServices.getDio().get(
        'http://147.93.57.70/api/faq/lookup/faq',
        queryParameters: {
          'userType': userType,
          'language': language,
        },
      );

      if (response.data['success'] == true && response.data['data'] != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((e) => FAQModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      rethrow;
    }
  }
}
