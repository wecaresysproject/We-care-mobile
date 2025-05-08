import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/cubits/cubit/medical_complains_search_cubit_state.dart';
import 'package:we_care/features/emergency_complaints/data/repos/emergency_complaints_data_entry_repo.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._complaintsDataEntryRepo) : super(SearchState.initial());

  final EmergencyComplaintsDataEntryRepo _complaintsDataEntryRepo;

  Future<void> sysptomsSearch(String query) async {
    emit(SearchState.loading());

    final result =
        await _complaintsDataEntryRepo.searchForMedicalIssueComplains(query);
    result.when(
      success: (result) {
        final syptomsDescription = result.map((e) => e.description).toList();
        emit(SearchState.loaded(syptomsDescription));
      },
      failure: (error) {
        emit(SearchState.error(error.errors.first));
      },
    );
  }

  void resetSearch() {
    emit(SearchState.initial());
  }
}
