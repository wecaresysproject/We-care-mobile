import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/medical_illnesses/data/repos/mental_illnesses_view_repo.dart';

import 'mental_illness_data_view_state.dart';

class MentalIllnessDataViewCubit extends Cubit<MentalIllnessDataViewState> {
  MentalIllnessDataViewCubit(this._repo)
      : super(const MentalIllnessDataViewState());
  final MentalIllnessesViewRepo _repo;

  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;
  Future<void> getIsUmbrellaMentalIllnessButtonActivated() async {
    emit(
      state.copyWith(
        requestStatus: RequestStatus.loading,
      ),
    );
    final result = await _repo.getIsUmbrellaMentalIllnessButtonActivated();
    result.when(
      success: (isActivated) => emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          isUmbrellaMentalIllnessButtonActivated: isActivated,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
          isUmbrellaMentalIllnessButtonActivated: false,
        ),
      ),
    );
  }

  Future<void> getMedicalIllnessDocsAvailableYears() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.getMedicalIllnessDocsAvailableYears();
    result.when(
      success: (data) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: data,
      )),
      failure: (error) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
      )),
    );
  }

  Future<void> getMentalIllnessRecords({int? page}) async {
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _repo.getMentalIllnessRecords(
      page: page ?? currentPage,
      limit: pageSize,
    );

    result.when(
      success: (data) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        mentalIllnessRecords: page == null || page == 1
            ? data
            : [...state.mentalIllnessRecords, ...data],
        isLoadingMore: false,
      )),
      failure: (error) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> getFilteredMentalIllnessDocuments({
    String? year,
  }) async {
    final result = await _repo.getFilteredMentalIllnessDocuments(
      year: year,
    );

    result.when(
      success: (response) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            mentalIllnessRecords: response,
            isLoadingMore: false,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  Future<void> loadMoreMentalIllnessRecords() async {
    if (!hasMore || isLoadingMore) return;
    await getMentalIllnessRecords(page: currentPage + 1);
  }

  Future<void> getMentalIllnessDocumentDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.getMentalIllnessDocumentDetailsById(
      id: id,
    );
    result.when(
      success: (data) => emit(
        state.copyWith(
          requestStatus: RequestStatus.success,
          selectedMentalIllnessDocumentDetails: data,
        ),
      ),
      failure: (error) => emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: error.errors.first,
        ),
      ),
    );
  }

  Future<void> deleteMentalIllnessDetailsDocumentById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.deleteMentalIllnessDetailsDocumentById(
      id: id,
    );
    result.when(
      success: (msg) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        responseMessage: msg,
        isDeleteRequest: true,
      )),
      failure: (error) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
        isDeleteRequest: true,
      )),
    );
  }

  Future<void> getInitialRequests() async {
    await Future.wait([
      getMentalIllnessRecords(),
      getMedicalIllnessDocsAvailableYears(),
    ]);
  }

  // Future<void> getFilteredEyePartProceduresAndSymptomsDocuments({
  //   String? year,
  //   String? category,
  //   required String eyePart,
  // }) async {
  //   final result = await _repo.getFilteredEyePartProceduresAndSymptomsDocuments(
  //     year: year,
  //     category: category,
  //     affectedEyePart: eyePart,
  //   );

  //   result.when(success: (response) {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       eyePartDocuments: response.data,
  //       isLoadingMore: false,
  //     ));
  //   }, failure: (error) {
  //     emit(state.copyWith(
  //       requestStatus: RequestStatus.failure,
  //       isLoadingMore: false,
  //     ));
  //   });
  // }

  // Future<void> getEyeGlassesRecords({int? page}) async {
  //   if (page != null && page > 1) {
  //     emit(state.copyWith(isLoadingMore: true));
  //   } else {
  //     emit(state.copyWith(requestStatus: RequestStatus.loading));
  //     currentPage = 1;
  //     hasMore = true;
  //   }

  //   final result = await _repo.getEyeGlassesRecords(
  //     page: page ?? currentPage,
  //     limit: pageSize,
  //   );

  //   result.when(
  //     success: (data) => emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       eyeGlassesRecords: page == null || page == 1
  //           ? data
  //           : [...state.eyeGlassesRecords, ...data],
  //       isLoadingMore: false,
  //     )),
  //     failure: (error) => emit(state.copyWith(
  //       requestStatus: RequestStatus.failure,
  //       responseMessage: error.errors.first,
  //       isLoadingMore: false,
  //     )),
  //   );
  // }

  // Future<void> getEyeGlassesDetails(String id) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await _repo.getEyeGlassesDetailsById(id: id);
  //   result.when(
  //     success: (data) => emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       selectedEyeGlassesDetails: data,
  //     )),
  //     failure: (error) => emit(state.copyWith(
  //       requestStatus: RequestStatus.failure,
  //       responseMessage: error.errors.first,
  //     )),
  //   );
  // }

  // Future<void> deleteEyeGlassesRecord(String id) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await _repo.deleteEyeGlassesRecordById(id: id);
  //   result.when(
  //     success: (msg) => emit(state.copyWith(
  //       requestStatus: RequestStatus.success,
  //       responseMessage: msg,
  //       isDeleteRequest: true,
  //     )),
  //     failure: (error) => emit(state.copyWith(
  //       requestStatus: RequestStatus.failure,
  //       responseMessage: error.errors.first,
  //       isDeleteRequest: true,
  //     )),
  //   );
  // }

  // Future<void> loadMoreEyePartDocuments({required String eyePart}) async {
  //   if (!hasMore || isLoadingMore) return;
  //   await getEyePartDocuments(
  //     page: currentPage + 1,
  //     eyePart: eyePart,
  //   );
  // }

  // Future<void> loadMoreEyeGlassesRecords() async {
  //   if (!hasMore || isLoadingMore) return;
  //   await getEyeGlassesRecords(page: currentPage + 1);
  // }
}
