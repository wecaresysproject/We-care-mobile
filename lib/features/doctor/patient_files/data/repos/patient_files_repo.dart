import 'package:we_care/core/networking/api_error_handler.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/doctor_services.dart';
import 'package:we_care/features/doctor/patient_files/data/models/patient_file_models.dart';

/// "ملفات المرضى": the open files and the previous patients
/// (docs/doctor_app_ui_updates_backend.md, section 2).
class PatientFilesRepo {
  PatientFilesRepo(this._doctorServices);

  final DoctorServices _doctorServices;

  /// [search] filters by patient name on the server; null = everyone.
  Future<ApiResult<List<OpenPatientFileModel>>> getOpenFiles({
    String? search,
  }) async {
    try {
      final response = await _doctorServices.getOpenPatientFiles(search);
      return ApiResult.success(
        OpenPatientFileModel.listFromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  /// [search] filters by patient name on the server; null = everyone.
  Future<ApiResult<List<PreviousPatientModel>>> getPreviousPatients({
    String? search,
  }) async {
    try {
      final response = await _doctorServices.getPreviousPatients(search);
      return ApiResult.success(
        PreviousPatientModel.listFromJson(_data(response)),
      );
    } catch (error) {
      return ApiResult.failure(ApiErrorHandler.handle(error));
    }
  }

  static Object? _data(dynamic response) =>
      response is Map ? response['data'] : null;
}
