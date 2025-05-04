import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/vaccine/data/repos/vaccine_view_repo.dart';
import 'package:we_care/features/vaccine/vaccine_view/logic/vaccne_view_state.dart';

class VaccineViewCubit extends Cubit<VaccineViewState> {
  VaccineViewCubit(this._vaccinesRepo) : super(VaccineViewState.initial());
  final VaccineViewRepo _vaccinesRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

    Future<void> emitUserVaccinesData({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _vaccinesRepo.getUserVaccines(
      language: AppStrings.arabicLang, 
      userType: 'Patient', 
      page: page ?? currentPage, 
      pageSize: pageSize ?? this.pageSize
    );

    result.when(success: (response) {
      final newVaccines = response.userVaccines;
      
      // Update hasMore based on whether we got a full page of results
      hasMore = newVaccines.length >= (pageSize ?? this.pageSize);
      
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userVaccines: page == 1 || page == null 
          ? newVaccines 
          : [...state.userVaccines, ...newVaccines],
        responseMessage: response.message,
        isLoadingMore: false,
      ));
      
      if (page == null || page == 1) {
        currentPage = 1;
      } else {
        currentPage = page;
      }
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
        isLoadingMore: false,
      ));
    });
  }

  Future<void> loadMoreMedicines() async {
    if (!hasMore || isLoadingMore) return;
    
    await emitUserVaccinesData(page: currentPage + 1);
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
