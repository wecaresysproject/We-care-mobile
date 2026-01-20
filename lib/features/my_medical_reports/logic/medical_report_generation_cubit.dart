import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_request_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';

part 'medical_report_generation_state.dart';

class MedicalReportGenerationCubit extends Cubit<MedicalReportGenerationState> {
  final MedicalReportRepo _medicalReportRepo;

  MedicalReportGenerationCubit(this._medicalReportRepo)
      : super(const MedicalReportGenerationState());

  void updateBasicInfoSelection({
    bool? getAll,
    List<String>? selectedValues,
  }) {
    emit(
      state.copyWith(
        basicInfoGetAll: getAll,
        basicInfoSelectedValues: selectedValues,
      ),
    );
  }

  Future<void> emitGenerateReport(String language) async {
    final requestBody = MedicalReportRequestModel(
      selections: MedicalReportSelections(
        basicInformation: BasicInformationSelection(
          getAll: state.basicInfoGetAll,
          selectedValues: state.basicInfoSelectedValues,
        ),
      ),
    );

    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _medicalReportRepo.fetchMedicalReportData(
      requestBody,
      language,
    );

    result.when(
      success: (data) {
        AppLogger.info(
            "Medical report data: ${data.data.basicInformation!.entries.first.value}");
        emit(
          state.copyWith(
            status: RequestStatus.success,
            medicalReportData: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            message: error.errors.firstOrNull ?? 'An error occurred',
          ),
        );
      },
    );
  }
}
