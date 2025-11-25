import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_view_repo.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaint_view_state.dart';

class EmergencyComplaintsViewCubit extends Cubit<EmergencyComplaintViewState> {
  EmergencyComplaintsViewCubit(this._emergencyComplaintsViewRepo)
      : super(EmergencyComplaintViewState.initial());
  final EmergencyComplaintsViewRepo _emergencyComplaintsViewRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;
  Future<void> intialRequests() async {
    await Future.wait([
      getUserEmergencyComplaintsList(),
      getFilters(),
    ]);
  }

  Future<void> getUserEmergencyComplaintsList(
      {int? page, int? pageSize}) async {
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      // Clear list before reload
      emit(state.copyWith(
        requestStatus: RequestStatus.loading,
        emergencyComplaints: [],
      ));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _emergencyComplaintsViewRepo.getAllEmergencyComplaints(
      language: AppStrings.arabicLang,
      page: page ?? currentPage,
      pageSize: pageSize ?? this.pageSize,
    );

    result.when(success: (response) {
      final newEmergencyComplaints = response;

      hasMore = newEmergencyComplaints.length >= (pageSize ?? this.pageSize);

      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        emergencyComplaints: page == null || page == 1
            ? List.of(newEmergencyComplaints) // Always new instance
            : [...state.emergencyComplaints, ...newEmergencyComplaints],
        isLoadingMore: false,
      ));

      currentPage = page ?? 1;
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        isLoadingMore: false,
      ));
    });
  }

  // Future<void> getUserEmergencyComplaintsList(
  //     {int? page, int? pageSize}) async {
  //   // If loading more, set the flag
  //   if (page != null && page > 1) {
  //     emit(state.copyWith(isLoadingMore: true));
  //   } else {
  //     emit(state.copyWith(requestStatus: RequestStatus.loading));
  //     currentPage = 1;
  //     hasMore = true;
  //   }

  //   final result = await _emergencyComplaintsViewRepo.getAllEmergencyComplaints(
  //       language: AppStrings.arabicLang,
  //       page: page ?? currentPage,
  //       pageSize: pageSize ?? this.pageSize);

  //   result.when(success: (response) {
  //     final newEmergencyComplaints = response;

  //     // Update hasMore based on whether we got a full page of results
  //     hasMore = newEmergencyComplaints.length >= (pageSize ?? this.pageSize);

  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       emergencyComplaints: page == 1 || page == null
  //           ? newEmergencyComplaints
  //           : [...state.emergencyComplaints, ...newEmergencyComplaints],
  //       isLoadingMore: false,
  //     ));

  //     if (page == null || page == 1) {
  //       currentPage = 1;
  //     } else {
  //       currentPage = page;
  //     }
  //   }, failure: (error) {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.failure,
  //       isLoadingMore: false,
  //     ));
  //   });
  // }

  Future<void> loadMoreMedicines() async {
    if (!hasMore || isLoadingMore) return;

    await getUserEmergencyComplaintsList(page: currentPage + 1);
  }

  Future<void> getYearFilter() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final yearsFilterResult = await _emergencyComplaintsViewRepo.getYearsFilter(
        language: AppStrings.arabicLang);

    yearsFilterResult.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> getPlaceOfComplaintFilter() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final placeOfComplaintResult = await _emergencyComplaintsViewRepo
        .getPlaceOfComplaint(language: AppStrings.arabicLang);

    placeOfComplaintResult.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        bodyPartFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> getFilters() async {
    await getYearFilter();
    await getPlaceOfComplaintFilter();
  }

  Future<void> getEmergencyComplaintDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _emergencyComplaintsViewRepo.getEmergencyComplaintById(
      id: id,
      language: AppStrings.arabicLang,
    );

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedEmergencyComplaint: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> deleteEmergencyComplaintById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await _emergencyComplaintsViewRepo.deleteEmergencyComplaintById(id: id);

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

  Future<void> getFilteredEmergencyComplaintList(
      {String? year, String? placeOfComplaint}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    if (year == "الكل") year = null;
    if (placeOfComplaint == "الكل") placeOfComplaint = null;

    if (year == null && placeOfComplaint == null) {
      await getUserEmergencyComplaintsList();
      return;
    }

    final result =
        await _emergencyComplaintsViewRepo.getFilteredEmergencyComplaints(
      year: year,
      placeOfComplaint: placeOfComplaint,
    );

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        emergencyComplaints: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first));
    });
  }
}
