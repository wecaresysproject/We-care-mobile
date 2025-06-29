import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_essential_data_request_body_model.dart';
import 'package:we_care/features/eyes/data/models/eye_glasses_lens_data_request_body_model.dart';
import 'package:we_care/features/eyes/eyes_services.dart';

class GlassesDataEntryRepo {
  final EyesModuleServices _eyesModuleServices;

  GlassesDataEntryRepo({required EyesModuleServices eyesModuleServices})
      : _eyesModuleServices = eyesModuleServices;

  Future<ApiResult<String>> postGlassesEssentialDataEntryEndPoint({
    required String language,
    required String userType,
    required EyeGlassesEssentialDataRequestBodyModel requestBody,
  }) async {
    try {
      final response =
          await _eyesModuleServices.postGlassesEssentialDataEntryEndPoint(
        language,
        userType,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> postGlassesLensDataEntry({
    required String language,
    required String userType,
    required EyeGlassesLensDataRequestBodyModel requestBody,
  }) async {
    try {
      final response = await _eyesModuleServices.postGlassesLensDataEntry(
        language,
        userType,
        requestBody,
      );
      return ApiResult.success(response["message"]);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }
  // Future<ApiResult<List<CountryModel>>> getCountriesData(
  //     {required String language}) async {
  //   try {
  //     final response = await eyesService.getCountries(language);
  //     final countries = (response['data'] as List)
  //         .map<CountryModel>((e) => CountryModel.fromJson(e))
  //         .toList();
  //     return ApiResult.success(countries);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<UploadReportResponseModel>> uploadReportImage({
  //   required String language,
  //   required String contentType,
  //   required File image,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.uploadReportImage(
  //       image,
  //       contentType,
  //       language,
  //     );
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<List<String>>> getAllSurgeriesRegions({
  //   required String language,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.getAllSurgeriesRegions(
  //       language,
  //     );
  //     final partRegions =
  //         (response['data'] as List).map((e) => e as String).toList();
  //     return ApiResult.success(partRegions);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  Future<ApiResult<List<String>>> getAllLensSurfaces({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _eyesModuleServices.getAllLensSurfaces(
        language,
        userType,
      );
      final lensSurfaces =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(lensSurfaces);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<String>>> getAllLensTypes({
    required String language,
    required String userType,
  }) async {
    try {
      final response = await _eyesModuleServices.getAllLensTypes(
        language,
        userType,
      );
      final lensTypes =
          (response['data'] as List).map((e) => e as String).toList();
      return ApiResult.success(lensTypes);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<List<String>>> getSurgeryNamesBasedOnRegion({
  //   required String language,
  //   required String region,
  //   required String subRegion,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.getSurgeryNameBasedOnRegion(
  //       region,
  //       subRegion,
  //       language,
  //     );
  //     final data = (response['data'] as List).map((e) => e as String).toList();
  //     return ApiResult.success(data);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<List<String>>> getAllTechUsed({
  //   required String language,
  //   required String region,
  //   required String subRegion,
  //   required String surgeryName,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.getAllTechUsed(
  //       region,
  //       subRegion,
  //       surgeryName,
  //       language,
  //     );
  //     final data = (response['data'] as List).map((e) => e as String).toList();

  //     return ApiResult.success(data);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<List<String>>> getSurgeryStatus({
  //   required String language,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.getSurgeryStatus(
  //       language,
  //     );
  //     final data = (response['data'] as List).map((e) => e as String).toList();

  //     return ApiResult.success(data);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> getSurgeryPurpose({
  //   required String language,
  //   required String region,
  //   required String subRegion,
  //   required String surgeryName,
  //   required String techUsed,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.getSurgeryPurpose(
  //       region,
  //       subRegion,
  //       surgeryName,
  //       techUsed,
  //       language,
  //     );
  //     final data = (response['data'][0] as String);

  //     return ApiResult.success(data);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> updateSurgeryDocumentById({
  //   required String id,
  //   required String langauge,
  //   required SurgeryRequestBodyModel requestBody,
  // }) async {
  //   try {
  //     final response = await _surgeriesService.updateSurgeryDocumentById(
  //       id,
  //       langauge,
  //       requestBody,
  //     );
  //     return ApiResult.success(response["message"]);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
