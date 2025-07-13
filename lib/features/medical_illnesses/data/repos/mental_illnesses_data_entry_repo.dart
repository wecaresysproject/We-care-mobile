import 'package:we_care/core/models/country_response_model.dart';
import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/medical_illnesses/mental_illnesses_services.dart';

class MentalIllnessesDataEntryRepo {
  final MentalIllnessesServices _illnessesServices;

  MentalIllnessesDataEntryRepo(
      {required MentalIllnessesServices illnessesServices})
      : _illnessesServices = illnessesServices;

  Future<ApiResult<List<String>>> getCountriesData(
      {required String language}) async {
    try {
      final response = await _illnessesServices.getCountries(language);
      final countriesNames = (response['data'] as List)
          .map((e) => CountryModel.fromJson(e).name)
          .toList();
      return ApiResult.success(countriesNames);
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  // Future<ApiResult<UploadReportResponseModel>> uploadReportImage({
  //   required String language,
  //   required String contentType,
  //   required File image,
  // }) async {
  //   try {
  //     final response = await _illnessesServices.uploadReportImage(
  //       image,
  //       contentType,
  //       language,
  //     );
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<UploadImageResponseModel>> uploadMedicalExaminationImage({
  //   required String language,
  //   required String contentType,
  //   required File image,
  // }) async {
  //   try {
  //     final response = await _eyesService.uploadMedicalExaminationImage(
  //       image,
  //       contentType,
  //       language,
  //     );
  //     return ApiResult.success(response);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> getEyePartDescribtion({
  //   required String language,
  //   required String userType,
  //   required String selectedEyePart,
  // }) async {
  //   try {
  //     final response = await _eyesService.getEyePartDescribtion(
  //       language,
  //       userType,
  //       selectedEyePart,
  //     );

  //     return ApiResult.success(response['data']['description']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> postEyeDataEntry({
  //   required String language,
  //   required String userType,
  //   required EyeDataEntryRequestBody requestBody,
  // }) async {
  //   try {
  //     final response = await _eyesService.postEyeDataEntry(
  //       language,
  //       userType,
  //       requestBody,
  //     );

  //     return ApiResult.success(response['message']);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<EyePartSyptomsAndProceduresResponseModel>>
  //     getEyePartSyptomsAndProcedures({
  //   required String language,
  //   required String userType,
  //   required String selectedEyePart,
  // }) async {
  //   try {
  //     final response = await _eyesService.getEyePartSyptomsAndProcedures(
  //       language,
  //       userType,
  //       selectedEyePart,
  //     );

  //     return ApiResult.success(
  //       EyePartSyptomsAndProceduresResponseModel.fromJson(response['data']),
  //     );
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }

  // Future<ApiResult<String>> editEyeDataEntered({
  //   required String id,
  //   required String language,
  //   required EyeDataEntryRequestBody requestBody,
  // }) async {
  //   try {
  //     final response = await _eyesService.editEyeDataEntered(
  //       language,
  //       id,
  //       UserTypes.patient.name.firstLetterToUpperCase,
  //       requestBody,
  //     );
  //     return ApiResult.success(response["message"]);
  //   } catch (error) {
  //     return ApiResult.failure(ApiErrorHandler.handle(error));
  //   }
  // }
}
