import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/allergy/data/models/allergy_details_data_model.dart';
import 'package:we_care/features/allergy/data/models/allergy_disease_model.dart';
import 'package:we_care/features/allergy/data/repos/allergy_view_repo.dart';

part 'allergy_view_state.dart';

class AllergyViewCubit extends Cubit<AllergyViewState> {
  AllergyViewCubit(this.allergyViewRepo) : super(AllergyViewState.initial());
  final AllergyViewRepo allergyViewRepo;

  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> getAllergyDiseases({int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await allergyViewRepo.getAllergyDiseases(
        language: AppStrings.arabicLang,
        page: page ?? currentPage,
        pageSize: pageSize ?? this.pageSize);

    result.when(success: (response) {
      final newAllergies = response;

      // Update hasMore based on whether we got a full page of results
      hasMore = newAllergies.length >= (pageSize ?? this.pageSize);

      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userAllergies: page == 1 || page == null
            ? newAllergies
            : [...state.userAllergies, ...newAllergies],
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

  Future<void> loadMoreAllergyDiseases() async {
    if (!hasMore || isLoadingMore) return;

    await getAllergyDiseases(page: currentPage + 1);
  }

  Future<void> getSurgeriesFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await allergyViewRepo.gettFilters(language: AppStrings.arabicLang);

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

  Future<void> getSingleAllergyDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await allergyViewRepo.getSingleAllergyDetailsById(
        id: id, language: AppStrings.arabicLang);

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            selectedAllergyDetails: response,
          ),
        );
      },
      failure: (error) {
        emit(state.copyWith(requestStatus: RequestStatus.failure));
      },
    );
  }

  Future<void> deleteAllergyById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await allergyViewRepo.deleteAllergyById(
      id: id,
      language: AppStrings.arabicLang,
    );

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            responseMessage: response,
            isDeleteRequest: true,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            responseMessage: error.errors.first,
            isDeleteRequest: true,
          ),
        );
      },
    );
  }

  // Future<void> getFilteredSurgeryList({int? year, String? surgeryName}) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await allergyViewRepo.getFilteredSurgeries(
  //     language: AppStrings.arabicLang,
  //     surgeryName: surgeryName,
  //     year: year,
  //   );

  //   result.when(success: (response) {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       userSurgeries: response.surgeries,
  //       responseMessage: response.message,
  //     ));
  //   }, failure: (error) {
  //     emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //         responseMessage: error.errors.first));
  //   });
  // }
}
