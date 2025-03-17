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
      ));
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
