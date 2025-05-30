import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/surgeries/data/repos/surgeries_repo.dart';
import 'package:we_care/features/surgeries/surgeries_view/logic/surgeries_view_state.dart';

class SurgeriesViewCubit extends Cubit<SurgeriesViewState> {
  SurgeriesViewCubit(this._surgeriesViewRepo)
      : super(SurgeriesViewState.initial());
  final SurgeriesViewRepo _surgeriesViewRepo;

  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

    Future<void> getUserSurgeriesList({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _surgeriesViewRepo.getUserSurgeriesList(
      language: AppStrings.arabicLang,
      page: page ?? currentPage, 
      pageSize: pageSize ?? this.pageSize
    );

    result.when(success: (response) {
      final newSurgeriesList = response.surgeries;
      
      // Update hasMore based on whether we got a full page of results
      hasMore = newSurgeriesList.length >= (pageSize ?? this.pageSize);
      
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userSurgeries: page == 1 || page == null 
          ? newSurgeriesList 
          : [...state.userSurgeries, ...newSurgeriesList],
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
        isLoadingMore: false,
      ));
    });
  }

  Future<void> loadMoreMedicines() async {
    if (!hasMore || isLoadingMore) return;
    
    await getUserSurgeriesList(page: currentPage + 1);
  }

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
