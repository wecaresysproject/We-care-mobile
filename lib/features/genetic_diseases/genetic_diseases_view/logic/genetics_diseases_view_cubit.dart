import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_view_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class GeneticsDiseasesViewCubit extends Cubit<GeneticsDiseasesViewState> {
  final GeneticDiseasesViewRepo geneticDiseasesViewRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  GeneticsDiseasesViewCubit({
    required this.geneticDiseasesViewRepo,
  }) : super(const GeneticsDiseasesViewState.initial());

  Future<void> getFamilyMembersNames() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await geneticDiseasesViewRepo.getFamilyMembersNames(
      'ar',
      'Patient',
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          familyMembersNames: data,
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

  Future<void> getFamilyMembersGeneticDiseases({
    required String familyMemberCode,
    required String familyMemberName,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.getFamilyMembersGeneticDiseases(
      'ar',
      'Patient',
      familyMemberCode,
      familyMemberName,
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          familyMemberGeneticDiseases: data,
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

  Future<void> getFamilyMemberGeneticDiseaseDetails({
    required String disease,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.getFamilyMemberGeneticDiseaseDetails(
      'ar',
      'Patient',
      disease,
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          familyMemberGeneticDiseaseDetails: data,
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

  Future<void> getPersonalGeneticDiseaseDetails({
    required String disease,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.getPersonalGeneticDiseaseDetails(
      'ar',
      'Patient',
      disease,
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          personalGeneticDiseaseDetails: data,
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

  Future<void> deleteFamilyMemberbyNameAndCode({
    required String name,
    required String code,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.deleteFamilyMemberbyNameAndCode(
      'ar',
      'Patient',
      code,
      name,
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          message: data,
          requestStatus: RequestStatus.success,
          isDeleteRequest: true,
        ));
        return true;
      },
      failure: (error) {
        emit(state.copyWith(
          message: error.errors.first,
          requestStatus: RequestStatus.failure,
          isDeleteRequest: true,
        ));
      },
    );
  }

  Future<void> getPersonalGeneticDiseases() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await geneticDiseasesViewRepo.getPersonalGeneticDiseases(
      'ar',
      'Patient',
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          personalGeneticDiseases: data.personalGenaticDisease,
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

  Future<void> deleteFamilyMemberSpecificDiseasebyNameAndCodeAndDiseaseName({
    required String name,
    required String code,
    required String diseaseName,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.deleteFamilyMemberSpecificDiseasebyNameAndCodeAndDiseaseName(
      'ar',
      'Patient',
      code,
      name,
      diseaseName,
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          message: data,
          requestStatus: RequestStatus.success,
          isDeleteRequest: true,
        ));
        return true;
      },
      failure: (error) {
        emit(state.copyWith(
          message: error.errors.first,
          requestStatus: RequestStatus.failure,
          isDeleteRequest: true,
        ));
      },
    );
  }

  // Future<void> getDefectedTooth() async {
  //   emit(state.copyWith(message: null, requestStatus: RequestStatus.loading));
  //   final result = await dentalRepository.getDefectedTooth(
  //       userType: 'Patient', language: 'ar');
  //   result.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //           defectedToothList: data, requestStatus: RequestStatus.success));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //           message: error.errors.first, requestStatus: RequestStatus.failure));
  //     },
  //   );
  // }

  // Future<void> getDocumentsByToothNumber({
  //   required String toothNumber,
  //   int? page,
  //   int? pageSize,
  // }) async {
  //   // If loading more, set the loadingMore flag
  //   if (page != null && page > 1) {
  //     emit(state.copyWith(isLoadingMore: true));
  //   } else {
  //     emit(state.copyWith(requestStatus: RequestStatus.loading));
  //     currentPage = 1;
  //     hasMore = true;
  //   }

  //   final result = await dentalRepository.getDocumentsByToothNumber(
  //     toothNumber: toothNumber,
  //     userType: 'Patient',
  //     language: 'ar',
  //     page: page ?? currentPage,
  //     pageSize: pageSize ?? this.pageSize,
  //   );

  //   result.when(
  //     success: (data) {
  //       final newDocuments = data.toothDocuments;

  //       hasMore = newDocuments.length >= (pageSize ?? this.pageSize);

  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         selectedToothList: page == 1 || page == null
  //             ? newDocuments
  //             : state.selectedToothList! + newDocuments,
  //         isLoadingMore: false,
  //       ));

  //       if (page == null || page == 1) {
  //         currentPage = 1;
  //       } else {
  //         currentPage = page;
  //       }
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //         message: error.errors.first,
  //         isLoadingMore: false,
  //       ));
  //     },
  //   );
  // }

  // Future<void> loadMoreDocuments(String toothNumber) async {
  //   if (!hasMore || isLoadingMore) return;

  //   await getDocumentsByToothNumber(
  //       toothNumber: toothNumber, page: currentPage + 1);
  // }

  // Future<void> getToothFilters() async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await dentalRepository.getToothFilters(
  //     userType: 'Patient',
  //     language: 'ar',
  //   );
  //   result.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         yearsFilter: data.years,
  //         toothNumberFilter: data.teethNumbers,
  //         procedureTypeFilter: data.subProcedures,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //         message: error.errors.first,
  //       ));
  //     },
  //   );
  // }

  // // Fetch filtered tooth documents based on selected filters
  // Future<void> getFilteredToothDocuments({
  //   int? year,
  //   String? toothNumber,
  //   String? procedureType,
  // }) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await dentalRepository.getFilteredToothDocuments(
  //     userType: 'Patient',
  //     language: 'ar',
  //     year: year,
  //     toothNumber: toothNumber,
  //     procedureType: procedureType,
  //   );
  //   result.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         filteredDefectedToothList: data,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //         message: error.errors.first,
  //         filteredDefectedToothList: null,
  //       ));
  //     },
  //   );
  // }

  // Future<void> getToothOperationDetailsById(String id) async {
  //   emit(state.copyWith(requestStatus: RequestStatus.loading));
  //   final result = await dentalRepository.getToothOperationDetailsById(
  //     id: id,
  //     userType: 'Patient',
  //     language: 'ar',
  //   );
  //   result.when(
  //     success: (data) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         selectedToothOperationDetails: data,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.failure,
  //         message: error.errors.first,
  //       ));
  //     },
  //   );
  // }

  // Future<void> deleteToothOperationDetailsById(String id) async {
  //   emit(state.copyWith(
  //       requestStatus: RequestStatus.loading, isDeleteRequest: true));
  //   final result = await dentalRepository.deleteToothOperationDetailsById(
  //     id: id,
  //     userType: 'Patient',
  //     language: 'ar',
  //   );
  //   result.when(
  //     success: (message) {
  //       emit(state.copyWith(
  //         requestStatus: RequestStatus.success,
  //         message: message,
  //         isDeleteRequest: true,
  //       ));
  //     },
  //     failure: (error) {
  //       emit(state.copyWith(
  //           requestStatus: RequestStatus.failure,
  //           message: error.errors.first,
  //           isDeleteRequest: true));
  //     },
  //   );
  // }
}
