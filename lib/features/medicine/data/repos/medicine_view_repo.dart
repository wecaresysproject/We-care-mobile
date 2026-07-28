import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medicine/data/models/get_all_user_medicines_responce_model.dart';
import 'package:we_care/features/medicine/data/models/get_medicines_filters_response_model.dart';
import 'package:we_care/features/medicine/medicines_services.dart';

/// The medicine continuity status plus, when the backend provides it, the date
/// the medicine ended ('yyyy-MM-dd'). [endDate] is null when unknown.
typedef MedicineStatusResult = ({bool isActiveMedicine, String? endDate});

class MedicinesViewRepo {
  MedicinesViewRepo(
    MedicinesServices medicinesServices,
  ) : _medicinesServices = medicinesServices;

  final MedicinesServices _medicinesServices;

  Future<ApiResult<GetAllUserMedicinesResponseModel>> getAllMedicines({
    required String language,
    required String userType,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final response = await _medicinesServices.getAllUserMedicines(
        language,
        userType,
        page,
        pageSize,
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

  Future<ApiResult<MedicineStatusResult>> getMedicineActiveStatus({
    required String medicineId,
    required String userType,
    required String language,
  }) async {
    try {
      final response = await _medicinesServices.getMedicineActiveStatus(
        medicineId,
        userType,
        language,
      );
      return ApiResult.success(_medicineStatusFrom(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Updates the medicine continuity status. When ending a medicine, [endDate]
  /// is the user-picked end date ('yyyy-MM-dd'), sent under the `endDate` body
  /// key and echoed back under the same key.
  Future<ApiResult<MedicineStatusResult>> updateMedicineStatus({
    required String medicineId,
    required String userType,
    required String language,
    required bool isActiveMedicine,
    required String endDate,
  }) async {
    try {
      final response = await _medicinesServices.updateMedicineStatus(
        medicineId,
        userType,
        language,
        {
          "endDate": endDate,
          "isActiveMedicine": isActiveMedicine,
        },
      );
      return ApiResult.success(_medicineStatusFrom(response));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// Reads `isActiveMedicine` and `endDate` from the response, tolerating both
  /// shapes these two endpoints return (fields at the root, or wrapped in a
  /// `data` envelope) and always taking the pair from the same payload. A
  /// missing or empty `endDate` yields null instead of throwing.
  MedicineStatusResult _medicineStatusFrom(dynamic response) {
    final Map root = response is Map ? response : const {};
    final data = root['data'];
    final Map source = data is Map ? data : root;
    final rawEndDate = source['endDate'] ?? root['endDate'];
    return (
      isActiveMedicine:
          (source['isActiveMedicine'] ?? root['isActiveMedicine']) == true,
      endDate: (rawEndDate is String && rawEndDate.isNotEmpty)
          ? rawEndDate.split('T').first
          : null,
    );
  }
}
