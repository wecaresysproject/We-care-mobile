import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/prescription/Presentation_view/logic/prescription_view_state.dart';
import 'package:we_care/features/prescription/data/repos/prescription_view_repo.dart';

class PrescriptionViewCubit extends Cubit<PrescriptionViewState> {
  PrescriptionViewCubit(this._prescriptionRepo)
      : super(PrescriptionViewState.initial());
  final PrescriptionViewRepo _prescriptionRepo;

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

  Future<void> getUserPrescriptionList() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _prescriptionRepo.getUserPrescriptionList(
        language: AppStrings.arabicLang);

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
}
