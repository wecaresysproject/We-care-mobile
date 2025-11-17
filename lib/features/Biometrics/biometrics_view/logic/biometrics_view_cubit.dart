import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/Biometrics/biometrics_view/logic/biometrics_view_state.dart';
import 'package:we_care/features/Biometrics/data/repos/biometrics_view_repo.dart';

class BiometricsViewCubit extends Cubit<BiometricsViewState> {
  BiometricsViewCubit(this.biometricsViewRepo)
      : super(BiometricsViewState.initial());
  final BiometricsViewRepo biometricsViewRepo;

  Future<void> getAllAvailableBiometrics() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await biometricsViewRepo.getAllAvailableBiometrics(
        language: 'ar', userType: 'Patient');
    response.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          availableBiometricNames: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
        ));
      },
    );
  }

  Future<void> getAllFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await biometricsViewRepo.getAllFilters(
        language: 'ar', userType: 'Patient');
    response.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          yearsFilter: data.years,
          daysFilter: data.days,
          monthFilter: data.months,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
        ));
      },
    );
  }

  Future<void> getFilteredBiometrics({
    int? year,
    int? month,
    int? day,
    required List<String> biometricCategories,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await biometricsViewRepo.getFilteredBiometrics(
        language: 'ar',
        userType: 'Patient',
        year: year,
        month: month,
        day: day,
        biometricCategories: biometricCategories);
    response.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          biometricsData: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
        ));
      },
    );
  }

  Future<void> getCurrentBiometricData() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await biometricsViewRepo.getCurrentBiometricData(
        language: 'ar', userType: 'Patient');
    response.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          currentBiometricsData: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
        ));
      },
    );
  }

  Future<void> deleteBiometricDataOfSpecificCategory({
    required String date,
    required String biometricName,
  }) async {
    emit(state.copyWith(deleteRequestStatus: RequestStatus.loading));

    final response =
        await biometricsViewRepo.deleteBiometricDataOfSpecifcCategory(
            language: 'ar',
            userType: 'Patient',
            date: date,
            biometricName: biometricName);
    response.when(
      success: (data) {
        emit(state.copyWith(
          deleteRequestStatus: RequestStatus.success,
          responseMessage: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          deleteRequestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
        ));
      },
    );
  }

  Future<void> editBiometricDataOfSpecificCategory({
    required String minValue,
    required String? maxValue,
    required String date,
    required String biometricName,
  }) async {
    emit(state.copyWith(editRequestStatus: RequestStatus.loading));

    final response = await biometricsViewRepo
        .editBiometricDataOfSpecifcCategory(
            requestBody: {
          "minValue": minValue,
          "maxValue": maxValue,
        },
            language: 'ar',
            userType: 'Patient',
            date: date,
            biometricName: biometricName);
    response.when(
      success: (data) {
        emit(state.copyWith(
          editRequestStatus: RequestStatus.success,
          responseMessage: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          editRequestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
        ));
      },
    );
  }
}
