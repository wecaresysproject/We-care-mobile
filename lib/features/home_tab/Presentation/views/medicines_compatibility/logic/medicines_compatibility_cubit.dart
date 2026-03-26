import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_state.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';

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
}
