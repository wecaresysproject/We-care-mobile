import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/core/models/module_guidance_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/upload_medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';

part 'ai_consultation_state.dart';

class AIConsultationCubit extends Cubit<AIConsultationState> {
  final AppSharedRepo sharedRepo;
  final MedicalReportRepo medicalReportRepo;

  AIConsultationCubit(this.sharedRepo, this.medicalReportRepo)
      : super(const AIConsultationState());

  Future<void> emitModuleGuidanceData() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.aiConsult.name,
    );

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            status: RequestStatus.success,
            moduleGuidanceData: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            message:
                failure.errors.firstOrNull ?? "Error fetching module guidance",
          ),
        );
      },
    );
  }

  Future<void> getPdfDates() async {
    emit(state.copyWith(pdfDatesStatus: RequestStatus.loading));
    final result = await medicalReportRepo.getPdfDates();

    result.when(
      success: (dates) {
        emit(
          state.copyWith(
            pdfDatesStatus: RequestStatus.success,
            reportDates: dates,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            pdfDatesStatus: RequestStatus.failure,
            message: failure.errors.firstOrNull ?? "Error fetching PDF dates",
          ),
        );
      },
    );
  }

  Future<void> getSpecificPdf(String date) async {
    emit(state.copyWith(fetchPdfStatus: RequestStatus.loading));
    final result = await medicalReportRepo.getSpecificPdf(date);

    result.when(
      success: (data) {
        emit(
          state.copyWith(
            fetchPdfStatus: RequestStatus.success,
            selectedPdf: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            fetchPdfStatus: RequestStatus.failure,
            message:
                failure.errors.firstOrNull ?? "Error fetching specific PDF",
          ),
        );
      },
    );
  }
}
