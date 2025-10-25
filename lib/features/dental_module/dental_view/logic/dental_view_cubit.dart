import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/dental_module/data/repos/dental_repo.dart';
import 'package:we_care/features/dental_module/dental_view/logic/dental_view_state.dart';

class DentalViewCubit extends Cubit<DentalViewState> {
  final DentalRepo dentalRepository;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  DentalViewCubit({
    required this.dentalRepository,
  }) : super(const DentalViewState.initial());

  Future<void> getDefectedTooth() async {
    emit(state.copyWith(message: null, requestStatus: RequestStatus.loading));
    final result = await dentalRepository.getDefectedTooth(
        userType: 'Patient', language: 'ar');
    result.when(
      success: (data) {
        emit(state.copyWith(
            defectedToothList: data, requestStatus: RequestStatus.success));
      },
      failure: (error) {
        emit(state.copyWith(
            message: error.errors.first, requestStatus: RequestStatus.failure));
      },
    );
  }

  Future<void> getDocumentsByToothNumber({
    required String toothNumber,
    int? page,
    int? pageSize,
  }) async {
    // If loading more, set the loadingMore flag
    if (page != null && page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    } else {
      emit(state.copyWith(requestStatus: RequestStatus.loading));
      currentPage = 1;
      hasMore = true;
    }

    final result = await dentalRepository.getDocumentsByToothNumber(
      toothNumber: toothNumber,
      userType: 'Patient',
      language: 'ar',
      page: page ?? currentPage,
      pageSize: pageSize ?? this.pageSize,
    );

    result.when(
      success: (data) {
        final newDocuments = data.toothDocuments;

        hasMore = newDocuments.length >= (pageSize ?? this.pageSize);

        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          selectedToothList: page == 1 || page == null
              ? newDocuments
              : state.selectedToothList! + newDocuments,
          isLoadingMore: false,
        ));

        if (page == null || page == 1) {
          currentPage = 1;
        } else {
          currentPage = page;
        }
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          message: error.errors.first,
          isLoadingMore: false,
        ));
      },
    );
  }

  Future<void> loadMoreDocuments(String toothNumber) async {
    if (!hasMore || isLoadingMore) return;

    await getDocumentsByToothNumber(
        toothNumber: toothNumber, page: currentPage + 1);
  }

  Future<void> getToothFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await dentalRepository.getToothFilters(
      userType: 'Patient',
      language: 'ar',
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          yearsFilter: data.years,
          toothNumberFilter: data.teethNumbers,
          procedureTypeFilter: data.subProcedures,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          message: error.errors.first,
        ));
      },
    );
  }

  // Fetch filtered tooth documents based on selected filters
  Future<void> getFilteredToothDocuments({
    int? year,
    String? toothNumber,
    String? procedureType,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await dentalRepository.getFilteredToothDocuments(
      userType: 'Patient',
      language: 'ar',
      year: year,
      toothNumber: toothNumber,
      procedureType: procedureType,
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          filteredDefectedToothList: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          message: error.errors.first,
          filteredDefectedToothList: [],
        ));
      },
    );
  }

  Future<void> getToothOperationDetailsById(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await dentalRepository.getToothOperationDetailsById(
      id: id,
      userType: 'Patient',
      language: 'ar',
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          selectedToothOperationDetails: data,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          requestStatus: RequestStatus.failure,
          message: error.errors.first,
        ));
      },
    );
  }

  Future<void> deleteToothOperationDetailsById(String id) async {
    emit(state.copyWith(
        requestStatus: RequestStatus.loading, isDeleteRequest: true));
    final result = await dentalRepository.deleteToothOperationDetailsById(
      id: id,
      userType: 'Patient',
      language: 'ar',
    );
    result.when(
      success: (message) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          message: message,
          isDeleteRequest: true,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
            requestStatus: RequestStatus.failure,
            message: error.errors.first,
            isDeleteRequest: true));
      },
    );
  }
}
