import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_services.dart';
import 'package:we_care/features/medicine/data/models/basic_medicine_info_model.dart';
import 'package:we_care/features/medicine/data/models/matched_medicines_model.dart';
import 'package:we_care/features/medicine/data/models/medicine_data_entry_request_body.dart';
import 'package:we_care/features/medicine/data/models/medicine_details_model.dart';

class GeneticDiseasesDataEntryRepo {
  final GeneticDiseasesServices _geneticDiseasesServices;

  GeneticDiseasesDataEntryRepo(this._geneticDiseasesServices);

  Future<ApiResult<List<String>>> getAllPlacesOfComplaints(
      {required String language}) async {
    try {
      final response =
          await _geneticDiseasesServices.getAllPlacesOfComplaints(language);
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedcineForms({
    required String language,
    required String userType,
    required String medicineId,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getMedcineForms(
        language,
        userType,
        medicineId,
      );
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getMedcineDosesByForms({
    required String language,
    required String userType,
    required String medicineId,
    required String medicineForm,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getMedcineDosesByForms(
        medicineForm,
        language,
        userType,
        medicineId,
      );
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllComplaintsRelevantToBodyPartName({
    required String bodyPartName,
  }) async {
    try {
      final response = await _geneticDiseasesServices
          .getAllComplaintsRelevantToBodyPartName(bodyPartName);
      final complaints =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(complaints);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// عدد مرات الجرعه
  Future<ApiResult<List<String>>> getAllDosageFrequencies({
    required String langauge,
    required String userType,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getAllDosageFrequencies(
        langauge,
        userType,
      );
      final data = (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// مدة الاستخدام
  Future<ApiResult<List<String>>> getAllUsageCategories({
    required String langauge,
    required String userType,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getAllUsageCategories(
        langauge,
        userType,
      );
      final data = (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// المدد الزمنيه
  Future<ApiResult<List<String>>> getAllDurationsForCategory({
    required String langauge,
    required String userType,
    required String category,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.getAllDurationsForCategory(
        langauge,
        userType,
        category,
      );
      final data = (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(data);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<MatchedMedicineModel>>> getMatchedMedicines({
    required String language,
    required String userType,
    required String medicineName,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getMatchedMedicines(
        medicineName,
        language,
        userType,
      );
      // Assuming response['data'] is a List of medicine items
      final List<dynamic> dataList = response['data'];
      final List<MatchedMedicineModel> matchedMedicines =
          dataList.map((item) => MatchedMedicineModel.fromJson(item)).toList();

      return ApiResult.success(matchedMedicines);
    } catch (e) {
      return ApiResult.failure(ApiErrorHandler.handle(e));
    }
  }

  Future<ApiResult<List<MedicineBasicInfoModel>>> getAllMedicinesNames({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getAllMedicinesNames(
        language,
        userType,
      );
      final medicines = (response['data'] as List)
          .map((e) => MedicineBasicInfoModel.fromJson(e))
          .toList();
      return ApiResult.success(medicines);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<MedicineDetailsModel>> getMedicineDetailsById({
    required String language,
    required String userType,
    required String medicineId,
  }) async {
    try {
      final response = await _geneticDiseasesServices.getMedicineDetailsById(
        language,
        userType,
        medicineId,
      );
      final medicineDetails = MedicineDetailsModel.fromJson(response['data']);

      return ApiResult.success(medicineDetails);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postMedicinesDataEntry({
    required MedicineDataEntryRequestBody requestBody,
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _geneticDiseasesServices.postMedicineDataEntry(
        requestBody,
        language,
        userType,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> editSpecifcMedicineDataDetails({
    required MedicineDataEntryRequestBody requestBody,
    required String language,
    required String medicineId,
    required String userType,
  }) async {
    try {
      final response =
          await _geneticDiseasesServices.editSpecifcMedicineDataDetails(
        requestBody,
        language,
        medicineId,
        userType,
      );
      return ApiResult.success(response['message']);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
}
