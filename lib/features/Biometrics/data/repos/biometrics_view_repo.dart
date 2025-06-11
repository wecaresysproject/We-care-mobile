import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/Biometrics/biometrics_services.dart';
import 'package:we_care/features/Biometrics/data/models/biometric_filters_model.dart';
import 'package:we_care/features/Biometrics/data/models/biometrics_dataset_model.dart';

class BiometricsViewRepo {
  final BiometricsServices _biometricsServices;

  BiometricsViewRepo({required BiometricsServices biometricsServices})
      : _biometricsServices = biometricsServices;

  Future<ApiResult<List<String>>> getAllAvailableBiometrics({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _biometricsServices.getAllAvailableBiometrics(
        language,
        userType,
      );
      return ApiResult.success(
        List<String>.from(response["data"] as List<dynamic>),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
  Future<ApiResult<BiometricFiltersModel>> getAllFilters({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _biometricsServices.getAllFilters(
        language,
        userType,
      );
      return ApiResult.success(BiometricFiltersModel.fromJson(response["data"]));
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }  

  Future<ApiResult<List<BiometricsDatasetModel>>> getFilteredBiometrics({
    required String language,
    required String userType,
    int? year,
    int? month,
    int? day,
   required List<String> biometricCategories,
  }) async {
    try {
      final response = await _biometricsServices.getFilteredBiometrics(
        language,
        userType,
        year?.toString(),
        month?.toString(),
        day?.toString(),
        biometricCategories,
      );
      return ApiResult.success(
        (response["biometrics"] as List<dynamic>)
            .map((e) => BiometricsDatasetModel.fromJson(e))
            .toList(),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }  

  // Future<ApiResult<GetAllUserMedicinesResponseModel>> getAllMedicines({
  //   required String language,
  //   required String userType,
  //   int page = 1,
  //   int pageSize = 10,
  // }) async {
  //   try {
  //     final response = await _medicinesServices.getAllUserMedicines(
  //       language,
  //       userType,
  //       page,
  //       pageSize,
  //     );
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<GetAllUserMedicinesResponseModel>> getFilteredMedicines({
  //   required String language,
  //   required String userType,
  //   int? year,
  //   String? medicineName,
  // }) async {
  //   try {
  //     final response = await _medicinesServices.getFilteredMedicines(
  //       language,
  //       userType,
  //       year,
  //       medicineName,
  //     );
  //     return ApiResult.success(response);
  //   } catch (e) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e));
  //   }
  // }

  // Future<ApiResult<String>> deleteMedicineById({
  //   required String id,
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response =
  //         await _medicinesServices.deleteMedicineById(id, language, userType);
  //     return ApiResult.success(response["message"]);
  //   } catch (e) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e));
  //   }
  // }

  // Future<ApiResult<MedicineModel>> getMedicineById({
  //   required String id,
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response =
  //         await _medicinesServices.getSingleMedicine(id, language, userType);
  //     return ApiResult.success(MedicineModel.fromJson(response["data"]));
  //   } catch (e) {
  //     return ApiResult.failure(ApiErrorHandler.handle(e));
  //   }
  // }

  // Future<ApiResult<GetMedicinesFiltersResponseModel>> getMedicinesFilters({
  //   required String language,
  //   required String userType,
  // }) async {
  //   try {
  //     final response = await _medicinesServices.getMedicinesFilters(
  //       language,
  //       userType,
  //     );
  //     return ApiResult.success(
  //       GetMedicinesFiltersResponseModel.fromJson(response["data"]),
  //     );
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
