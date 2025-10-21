import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/physical_activaty/data/models/physical_activity_metrics_model.dart';
import 'package:we_care/features/physical_activaty/data/repos/physical_activaty_view_repo.dart';

part 'physical_activaty_view_state.dart';

class PhysicalActivityViewCubit extends Cubit<PhysicalActivatyViewState> {
  PhysicalActivityViewCubit(this.physicalActivatyViewRepo)
      : super(PhysicalActivatyViewState.initial());
  final PhysicalActivatyViewRepo physicalActivatyViewRepo;
  Future<void> getAvailableYears() async {
    final response = await physicalActivatyViewRepo.getAvailableYears(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            availableYears: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            responseMessage: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getAvailableDatesBasedOnYear(String selectedYear) async {
    final response =
        await physicalActivatyViewRepo.getAvailableDatesBasedOnYear(
      language: AppStrings.arabicLang,
      year: selectedYear,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            availableDates: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            responseMessage: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> getIntialRequests() async {
    await Future.wait([
      getPhysicalActivitySlides(),
      getAvailableYears(),
    ]);
  }

  Future<void> getPhysicalActivitySlides() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await physicalActivatyViewRepo.getPhysicalActivitySlides(
      language: AppStrings.arabicLang,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            physicalActivitySLides: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
          ),
        );
      },
    );
  }

  Future<void> getFilterdDocuments(
      {required String year, required String date}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await physicalActivatyViewRepo.getFilterdDocuments(
      language: AppStrings.arabicLang,
      year: year,
      date: date,
    );
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            physicalActivitySLides: data,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            responseMessage: error.errors.first,
          ),
        );
      },
    );
  }
}
