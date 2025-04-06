import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/get_medicines_filters_response_model.dart';
import 'package:we_care/features/medicine/medicines_services.dart';

class MedicinesViewRepo {
  MedicinesViewRepo(
    MedicinesServices medicinesServices,
  ) : _medicinesServices = medicinesServices;

  final MedicinesServices _medicinesServices;

  Future<ApiResult<GetAllUserMedicinesResponseModel>> getAllMedicines({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _medicinesServices.getAllMedicines(
        language,
        userType,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<GetAllUserMedicinesResponseModel>> getFilteredMedicines({
    required String language,
    required String userType,
    int? year,
    String? medicineName,
  }) async {
    try {
      final response = await _medicinesServices.getFilteredMedicines(
        language,
        userType,
        year,
        medicineName,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<String>> deleteMedicineById({
    required String id,
    required String language,
    required String userType,
  }) async {
    try {
      final response =
          await _medicinesServices.deleteMedicineById(id, language, userType);
      return ApiResult.success(response["message"]);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<MedicineModel>> getMedicineById({
    required String id,
    required String language,
    required String userType,
  }) async {
    try {
      final response =
          await _medicinesServices.getSingleMedicine(id, language, userType);
      return ApiResult.success(MedicineModel.fromJson(response["data"]));
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<GetMedicinesFiltersResponseModel>> getMedicinesFilters({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _medicinesServices.getMedicinesFilters(
        language,
        userType,
      );
      return ApiResult.success(
        GetMedicinesFiltersResponseModel.fromJson(response["data"]),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
