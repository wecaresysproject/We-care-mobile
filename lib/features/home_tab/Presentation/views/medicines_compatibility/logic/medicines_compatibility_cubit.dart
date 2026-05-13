import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_state.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/deep_seek_services.dart';

class MedicinesCompatibilityCubit extends Cubit<MedicinesCompatibilityState> {
  final MedicalReportRepo _medicalReportRepo;
  final AppSharedRepo sharedRepo;

  MedicinesCompatibilityCubit(this._medicalReportRepo, this.sharedRepo)
      : super(const MedicinesCompatibilityState());

  Future<void> initialRequests() async {
    await Future.wait(
      [
        fetchMedicinesFilters(),
        emitModuleGuidanceData(),
        getUserMedicalHistoryDetails(),
      ],
    );
  }

  void updateSelectedMedicines(List<String> medicines) {
    AppLogger.info("updateSelectedMedicines: $medicines");
    emit(state.copyWith(selectedMedicines: medicines));
  }

  void updateRecentlyExpiredMedicines(List<String> medicines) {
    AppLogger.info("updateRecentlyExpiredMedicines: $medicines");
    emit(state.copyWith(recentlyExpiredMedicines: medicines));
  }

  Future<void> analyseAllMedicinesCompitability() async {
    // if (state.selectedMedicines.isEmpty &&
    //     state.recentlyExpiredMedicines.isEmpty) {
    //   emit(state.copyWith(
    //     analysisStatus: RequestStatus.failure,
    //     message: "برجاء اختيار دواء واحد على الأقل",
    //   ));
    //   return;
    // }

    emit(state.copyWith(analysisStatus: RequestStatus.loading));

    final result = await DeepSeekService
        .analyseAllMedicinesCompitabilityWithUserMedicalHistory(
      currentMedicines: state.selectedMedicines,
      recentlyExpiredMedicines: state.recentlyExpiredMedicines,
      medicalProfile: state.userMedicalProfileHistory,
    );

    if (result != null) {
      emit(
        state.copyWith(
          analysisStatus: RequestStatus.success,
          auditReport: result,
        ),
      );
    } else {
      emit(
        state.copyWith(
          analysisStatus: RequestStatus.failure,
          message:
              "فشل استخراج تقرير التدقيق الإكلينيكي، برجاء المحاولة لاحقاً",
        ),
      );
    }
  }

  Future<void> getUserMedicalHistoryDetails() async {
    emit(state.copyWith(
      medicalHistoryStatus: RequestStatus.loading,
    ));

    final response = await _medicalReportRepo.getUserMedicalHistoryDetails();

    response.when(
      success: (userMedicalProfileHistory) {
        emit(
          state.copyWith(
            userMedicalProfileHistory: userMedicalProfileHistory,
            medicalHistoryStatus: RequestStatus.success,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            userMedicalProfileHistory: null,
            medicalHistoryStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }

  Future<void> emitModuleGuidanceData() async {
    final response = await sharedRepo.getModuleGuidance(
      WeCareMedicalModules.drugCheck.name,
    );

    response.when(
      success: (response) {
        emit(
          state.copyWith(
            moduleGuidanceData: response,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            moduleGuidanceData: null,
          ),
        );
      },
    );
  }

  Future<void> fetchMedicinesFilters() async {
    emit(state.copyWith(status: RequestStatus.loading));

    final result = await _medicalReportRepo.getMedicinesFilters(
      'ar',
      'patient',
    );

    result.when(
      success: (data) {
        emit(state.copyWith(
          status: RequestStatus.success,
          filterData: data,
        ));
      },
      failure: (error) {
        emit(
          state.copyWith(
            status: RequestStatus.failure,
            message: error.errors.firstOrNull ?? 'حدث خطأ أثناء تحميل البيانات',
          ),
        );
      },
    );
  }

  Future<void> fetchMedicinesCompitabilitySystemPrompt() async {
    emit(state.copyWith(fetchSystemPromptStatus: RequestStatus.loading));
    final result =
        await _medicalReportRepo.fetchMedicinesCompitabilitySystemPrompt();
    result.when(
      success: (prompt) {
        emit(
          state.copyWith(
            fetchSystemPromptStatus: RequestStatus.success,
            medicalCompitabilitySystemPrompt: prompt,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            fetchSystemPromptStatus: RequestStatus.failure,
            message: failure.errors.first,
          ),
        );
      },
    );
  }
}
