import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_state.dart';
import 'package:we_care/features/prescription/data/repos/prescription_view_repo.dart';

class PrescriptionViewCubit extends Cubit<PrescriptionViewState> {
  PrescriptionViewCubit(this._prescriptionRepo)
      : super(PrescriptionViewState.initial());
  final PrescriptionViewRepo _prescriptionRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

    Future<void> getUserPrescriptionList({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _prescriptionRepo.getUserPrescriptionList(
      language: AppStrings.arabicLang, 
      userType: 'Patient', 
      page: page ?? currentPage, 
      pageSize: pageSize ?? this.pageSize
    );

    result.when(success: (response) {
      final newPrescriptionList = response.prescriptionList;
      
      // Update hasMore based on whether we got a full page of results
      hasMore = newPrescriptionList.length >= (pageSize ?? this.pageSize);
      
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userPrescriptions: page == 1 || page == null 
          ? newPrescriptionList 
          : [...state.userPrescriptions, ...newPrescriptionList],
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
    
    await getUserPrescriptionList(page: currentPage + 1);
  }


  Future<void> getPrescriptionFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _prescriptionRepo.gettFilters(
        language: AppStrings.arabicLang, userType: 'Patient');

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response.years,
        doctorNameFilter: response.doctors,
        specificationsFilter: response.specification,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }


  Future<void> getUserPrescriptionDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _prescriptionRepo.getUserPrescriptionDetailsById(
        id: id, language: AppStrings.arabicLang, userType: 'Patient');

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedPrescriptionDetails: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> deletePrescriptionById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _prescriptionRepo.deletePrescriptionById(
        id: id, language: AppStrings.arabicLang, userType: 'Patient');

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

  Future<void> getFilteredPrescriptionList(
      {int? year, String? doctorName, String? specification}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _prescriptionRepo.getFilteredPrescriptionList(
        language: AppStrings.arabicLang,
        userType: 'Patient',
        year: year,
        doctorName: doctorName,
        specification: specification);

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userPrescriptions: response.prescriptionList,
        responseMessage: response.message,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first));
    });
  }
}
