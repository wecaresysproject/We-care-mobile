import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_view_repo.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';

class VaccineViewCubit extends Cubit<VaccineViewState> {
  VaccineViewCubit(this._vaccinesRepo) : super(VaccineViewState.initial());
  final VaccineViewRepo _vaccinesRepo;

  Future<void> emitUserVaccinesData() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response =
        await _vaccinesRepo.getUserVaccines(AppStrings.arabicLang, 'Patient');

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userVaccines: response.userVaccines,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
        userVaccines: [],
      ));
    });
  }

  Future<void> emitVaccineById(String vaccineId) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await _vaccinesRepo.getVaccineById(
        AppStrings.arabicLang, 'Patient', vaccineId);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedVaccine: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitFilteredVaccinesList(
      {String? vaccineName, String? year}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await _vaccinesRepo.getFilteredList(
        AppStrings.arabicLang, 'Patient', vaccineName, year);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userVaccines: response.userVaccines,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
        userVaccines: [],
      ));
    });
  }

  Future<void> deleteVaccineById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _vaccinesRepo.deleteVaccineById(
        AppStrings.arabicLang, 'Patient', id);

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        responseMessage: response,
        isDeleteRequest: true,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
          isDeleteRequest: true));
    });
  }

  Future<void> emitVaccinesFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await _vaccinesRepo.getVaccinesFilters(
        AppStrings.arabicLang, 'Patient');

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        vaccineTypesFilter: response.vaccineNames,
        yearsFilter: response.years,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        responseMessage: error.errors.first,
        requestStatus: RequestStatus.failure,
      ));
    });
  }
}
