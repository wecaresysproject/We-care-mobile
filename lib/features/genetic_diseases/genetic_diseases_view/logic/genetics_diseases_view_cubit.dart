import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/shared_repo.dart';
import 'package:we_care/features/genetic_diseases/data/repos/genetic_diseases_view_repo.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/logic/genetics_diseases_view_state.dart';

class GeneticsDiseasesViewCubit extends Cubit<GeneticsDiseasesViewState> {
  final GeneticDiseasesViewRepo geneticDiseasesViewRepo;
  final AppSharedRepo sharedRepo;
  int currentPage = 1;
  final int pageSize = 10;
  bool hasMore = true;
  bool isLoadingMore = false;

  GeneticsDiseasesViewCubit({
    required this.geneticDiseasesViewRepo,
    required this.sharedRepo,
  }) : super(const GeneticsDiseasesViewState.initial());

  Future<void> emitModuleGuidance() async {
    final result = await sharedRepo
        .getModuleGuidance(WeCareMedicalModules.geneticDiseases.name);
    result.when(
      success: (data) {
        emit(state.copyWith(moduleGuidanceData: data));
      },
      failure: (error) {
        emit(state.copyWith(moduleGuidanceData: null));
      },
    );
  }

  Future<void> initialRequests() async {
    await Future.wait(
      [
        getPersonalGeneticDiseases(),
        getCurrentPersonalGeneticDiseases(),
        emitModuleGuidance(),
      ],
    );
  }

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
    required String id,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.getPersonalGeneticDiseaseDetails(
      'ar',
      'Patient',
      id,
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
    final result = await geneticDiseasesViewRepo
        .deleteFamilyMemberSpecificDiseasebyNameAndCodeAndDiseaseName(
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

  Future<void> getCurrentPersonalGeneticDiseases() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result =
        await geneticDiseasesViewRepo.getCurrentPersonalGeneticDiseases(
      language: 'ar',
      userType: 'Patient',
    );
    result.when(
      success: (data) {
        emit(state.copyWith(
          requestStatus: RequestStatus.success,
          currentPersonalGeneticDiseases: data,
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

  Future<void> deleteSpecificCurrentPersonalGeneticDiseaseById({
    required String id,
  }) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await geneticDiseasesViewRepo
        .deleteSpecificCurrentPersonalGeneticDiseaseById(
      language: 'ar',
      userType: 'Patient',
      id: id,
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
}
