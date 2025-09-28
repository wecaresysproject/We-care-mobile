import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/chronic_disease/data/models/chronic_disease_model.dart';
import 'package:we_care/features/chronic_disease/data/models/post_chronic_disease_model.dart';
import 'package:we_care/features/chronic_disease/data/repos/chronic_disease_view_repo.dart';

part 'chronic_disease_view_state.dart';

class ChronicDiseaseViewCubit extends Cubit<ChronicDiseaseViewState> {
  ChronicDiseaseViewCubit(this._diseaseViewRepo)
      : super(ChronicDiseaseViewState.initial());
  final ChronicDiseaseViewRepo _diseaseViewRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> getAllChronicDiseasesDocuments(
      {int? page, int? pageSize}) async {
    // If loading more, set the flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _diseaseViewRepo.getAllChronicDiseasesDocuments(
        language: AppStrings.arabicLang,
        userType: 'Patient',
        page: page ?? currentPage,
        pageSize: pageSize ?? this.pageSize);

    result.when(success: (response) {
      final newChronicDiseasesList = response;

      // Update hasMore based on whether we got a full page of results
      hasMore = newChronicDiseasesList.length >= (pageSize ?? this.pageSize);

      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        userChronicDisease: page == 1 || page == null
            ? newChronicDiseasesList
            : [...state.userChronicDisease, ...newChronicDiseasesList],
        responseMessage: 'تم العرض بنجاح.',
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

  Future<void> loadMoreChronicDiseases() async {
    if (!hasMore || isLoadingMore) return;

    await getAllChronicDiseasesDocuments(page: currentPage + 1);
  }

  Future<void> getUserChronicDiseaseDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _diseaseViewRepo.getUserChronicDiseaseDetailsById(
        id: id, language: AppStrings.arabicLang, userType: 'Patient');

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedChronicDiseaseDetails: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(requestStatus: RequestStatus.failure));
    });
  }

  Future<void> deleteUserChronicDiseaseById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _diseaseViewRepo.deleteUserChronicDiseaseById(
      id: id,
      language: AppStrings.arabicLang,
      userType: 'Patient',
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
}
