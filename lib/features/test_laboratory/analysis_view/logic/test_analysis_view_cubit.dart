import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/test_laboratory/data/repos/test_analysis_view_repo.dart';
import 'package:we_care/features/test_laboratory/analysis_view/logic/test_analysis_view_state.dart';

class TestAnalysisViewCubit extends Cubit<TestAnalysisViewState> {
  TestAnalysisViewCubit(this.testAnalysisViewRepo)
      : super(TestAnalysisViewState.initial());
  final TestAnalysisViewRepo testAnalysisViewRepo;

  Future<void> emitFilters() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.gettFilters();

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        yearsFilter: response,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitTests() async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getTests();

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        analysisSummarizedDataList: response.data,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitFilteredData(int year) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getTestsByYear(year);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        analysisSummarizedDataList: response.data,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }

  Future<void> emitTestbyId(String id) async {
    emit(state.copyWith(requestStatus: RequestStatus.loading));

    final response = await testAnalysisViewRepo.getTestbyId(id);

    response.when(success: (response) async {
      emit(state.copyWith(
        requestStatus: RequestStatus.success,
        selectedAnalysisDetails: response.data.first,
      ));
    }, failure: (error) {
      emit(state.copyWith(
        requestStatus: RequestStatus.failure,
      ));
    });
  }
}
