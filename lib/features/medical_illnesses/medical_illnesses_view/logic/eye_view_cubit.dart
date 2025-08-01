import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/eyes/data/repos/eyes_view_repo.dart';

import 'eye_view_state.dart';

class EyeViewCubit extends Cubit<EyeViewState> {
  EyeViewCubit(this._repo) : super(const EyeViewState());
  final EyesViewRepo _repo;

  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  Future<void> getAvailableYears({required String eyePart}) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.getAvailableEyePartDocumentYears(
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
      affectedEyePart: eyePart,
    );
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

  Future<void> getInitialRequests({required String eyePart}) async {
    await getEyePartDocuments(eyePart: eyePart);
    getAvailableYears(eyePart: eyePart);
  }

  Future<void> getEyePartDocuments({int? page, required String eyePart}) async {
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _repo.getEyePartProceduresAndSymptomsDocuments(
      page: page ?? currentPage,
      limit: pageSize,
      affectedEyePart: eyePart,
    );

    result.when(success: (response) {
      final newDocs = response.data;

      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        eyePartDocuments: page == null || page == 1
            ? newDocs
            : [...state.eyePartDocuments, ...newDocs],
        isLoadingMore: false,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        isLoadingMore: false,
      ));
    });
  }

  Future<void> getFilteredEyePartProceduresAndSymptomsDocuments({
    String? year,
    String? category,
    required String eyePart,
  }) async {
    final result = await _repo.getFilteredEyePartProceduresAndSymptomsDocuments(
      year: year,
      category: category,
      affectedEyePart: eyePart,
    );

    result.when(success: (response) {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        eyePartDocuments: response.data,
        isLoadingMore: false,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        isLoadingMore: false,
      ));
    });
  }

  Future<void> getEyePartDocumentDetails(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.getEyePartDocumentDetailsById(
      id: id,
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
    );
    result.when(
      success: (data) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedEyePartDocumentDetails: data,
      )),
      failure: (error) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
      )),
    );
  }

  Future<void> deleteEyePartDocument(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.deleteEyePartDocumentById(
      id: id,
      language: AppStrings.arabicLang,
      userType: UserTypes.patient.name.firstLetterToUpperCase,
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

  Future<void> getEyeGlassesRecords({int? page}) async {
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await _repo.getEyeGlassesRecords(
      page: page ?? currentPage,
      limit: pageSize,
    );

    result.when(
      success: (data) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        eyeGlassesRecords: page == null || page == 1
            ? data
            : [...state.eyeGlassesRecords, ...data],
        isLoadingMore: false,
      )),
      failure: (error) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
        isLoadingMore: false,
      )),
    );
  }

  Future<void> getEyeGlassesDetails(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.getEyeGlassesDetailsById(id: id);
    result.when(
      success: (data) => emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedEyeGlassesDetails: data,
      )),
      failure: (error) => emit(state.copyWith(
        requestStatus: RequestStatus.failure,
        responseMessage: error.errors.first,
      )),
    );
  }

  Future<void> deleteEyeGlassesRecord(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _repo.deleteEyeGlassesRecordById(id: id);
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

  Future<void> loadMoreEyePartDocuments({required String eyePart}) async {
    if (!hasMore || isLoadingMore) return;
    await getEyePartDocuments(
      page: currentPage + 1,
      eyePart: eyePart,
    );
  }

  Future<void> loadMoreEyeGlassesRecords() async {
    if (!hasMore || isLoadingMore) return;
    await getEyeGlassesRecords(page: currentPage + 1);
  }
}
