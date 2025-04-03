import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/surgeries/data/repos/surgeries_repo.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';

class SurgeriesViewCubit extends Cubit<SurgeriesViewState> {
  SurgeriesViewCubit(this._surgeriesViewRepo)
      : super(SurgeriesViewState.initial());
  final SurgeriesViewRepo _surgeriesViewRepo;

  Future<void> getSurgeriesFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await _surgeriesViewRepo.gettFilters(language: AppStrings.arabicLang);

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response.years,
        surgeryNameFilter: response.surgeryNames,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> getUserSurgeriesList() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _surgeriesViewRepo.getUserSurgeriesList(
        language: AppStrings.arabicLang);

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userSurgeries: response.surgeries,
        responseMessage: response.message,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first));
    });
  }

  Future<void> getSurgeryDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _surgeriesViewRepo.getSurgeryDetailsById(
        id: id, language: AppStrings.arabicLang);

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedSurgeryDetails: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> deleteSurgeryById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _surgeriesViewRepo.deleteSurgeryById(
      id: id,
    );

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

  Future<void> getFilteredSurgeryList({int? year, String? surgeryName}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _surgeriesViewRepo.getFilteredSurgeries(
      language: AppStrings.arabicLang,
      surgeryName: surgeryName,
      year: year,
    );

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userSurgeries: response.surgeries,
        responseMessage: response.message,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first));
    });
  }
}
