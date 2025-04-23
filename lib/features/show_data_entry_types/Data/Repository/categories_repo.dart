import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/show_data_entry_types/Data/Models/all_categories_tickets_count.dart';
import 'package:we_care/features/show_data_entry_types/Data/Service/categories_services.dart';


class CategoriesRepository {
  final CategoriesServices _categoriesService;

  CategoriesRepository(this._categoriesService);


  Future<CategoriesTicketsCount> getAllCategoriesTicketsCount(
      String language, String userType) async {
    try {
      final response = await _categoriesService.getAllCategoriesTicketsCount(
          language, userType);
     return CategoriesTicketsCount.fromJson(response["data"]);
    } catch (e) {
      rethrow;
    }
  }
}