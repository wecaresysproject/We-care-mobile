import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_view_repo.dart';
import 'package:we_care/features/emergency_complaints/emergency_complaints_view/logic/emergency_complaint_view_state.dart';

class EmergencyComplaintsViewCubit extends Cubit<EmergencyComplaintViewState> {
  EmergencyComplaintsViewCubit(this._emergencyComplaintsViewRepo)
      : super(EmergencyComplaintViewState.initial());
  final EmergencyComplaintsViewRepo _emergencyComplaintsViewRepo;

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

  Future<void> getUserEmergencyComplaintsList() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _emergencyComplaintsViewRepo.getAllEmergencyComplaints(
      language: AppStrings.arabicLang,
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
