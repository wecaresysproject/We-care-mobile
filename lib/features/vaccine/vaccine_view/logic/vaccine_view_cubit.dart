import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_view_repo.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';

class VaccineViewCubit extends Cubit<VaccineViewState> {
  VaccineViewCubit(this._vaccinesRepo, this._sharedRepo)
      : super(VaccineViewState.initial());
  final VaccineViewRepo _vaccinesRepo;
  final AppSharedRepo _sharedRepo;

  Future<void> emitUserVaccinesData({String? dateFrom, String? dateTo}) async {
    safeEmit(state.copyWith(
      requestStatus: RequestStatus.loading,
    ));
    final result =
        await _vaccinesRepo.getUserVaccines(dateFrom: dateFrom, dateTo: dateTo);
    result.when(
      success: (data) {
        safeEmit(state.copyWith(
          requestStatus: RequestStatus.success,
          userVaccines: data.userVaccines,
        ));
      },
      failure: (error) {
        safeEmit(state.copyWith(
          requestStatus: RequestStatus.failure,
          message: error.errors.first,
        ));
      },
    );
  }

  Future<void> fetchUserSubmissionDates() async {
    safeEmit(state.copyWith(userSubmissionDatesStatus: RequestStatus.loading));
    final result = await _vaccinesRepo.fetchUserSubmissionDates();
    result.when(
      success: (dates) {
        safeEmit(
          state.copyWith(
            userSubmissionDatesStatus: RequestStatus.success,
            userSubmissionDates: dates,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            userSubmissionDatesStatus: RequestStatus.failure,
            message: error.errors.first,
          ),
        );
      },
    );
  }

  // Future<void> emitVaccineById(String vaccineId) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await _vaccinesRepo.getVaccineById(
  //       AppStrings.arabicLang, 'Patient', vaccineId);

  //   response.when(
  //     success: (response) async {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         selectedVaccine: response,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(
  //         state.copyWith(
  //           message: error.errors.first,
  //           requestStatus: RequestStatus.failure,
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<void> emitFilteredVaccinesList(
  //     {String? vaccineName, String? year}) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await _vaccinesRepo.getFilteredList(
  //       AppStrings.arabicLang, 'Patient', vaccineName, year);

  //   response.when(success: (response) async {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       userVaccines: response.userVaccines,
  //     ));
  //   }, failure: (error) {
  //     emit(state.copyWith(
  //       message: error.errors.first,
  //       requestStatus: RequestStatus.failure,
  //       userVaccines: [],
  //     ));
  //   });
  // }

  // Future<void> deleteVaccineById(String id) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await _vaccinesRepo.deleteVaccineById(
  //       AppStrings.arabicLang, 'Patient', id);

  //   result.when(success: (response) {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       message: response,
  //       isDeleteRequest: true,
  //     ));
  //   }, failure: (error) {
  //     emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //         message: error.errors.first,
  //         isDeleteRequest: true));
  //   });
  // }

  // Future<void> emitVaccinesFilters() async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));

  //   final response = await _vaccinesRepo.getVaccinesFilters(
  //       AppStrings.arabicLang, 'Patient');

  //   response.when(success: (response) async {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       vaccineTypesFilter: response.vaccineNames,
  //       yearsFilter: response.years,
  //     ));
  //   }, failure: (error) {
  //     emit(state.copyWith(
  //       message: error.errors.first,
  //       requestStatus: RequestStatus.failure,
  //     ));
  //   });
  // }

  Future<void> emitModuleGuidance() async {
    final result = await _sharedRepo.getModuleGuidance(
      WeCareMedicalModules.vaccinationsView.name,
    );

    result.when(
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

  Future<void> initialRequests() async {
    await Future.wait([
      emitUserVaccinesData(),
      fetchUserSubmissionDates(),
      emitModuleGuidance(),
    ]);
  }

  safeEmit(VaccineViewState newState) {
    if (!isClosed) {
      emit(newState);
    }
  }
}
