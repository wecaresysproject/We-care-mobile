import 'package:bloc/bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';
import 'package:we_care/features/supplements/data/repos/supplements_data_entry_repo.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';

class SupplementsDataEntryCubit extends Cubit<SupplementsDataEntryState> {
  SupplementsDataEntryCubit(this._supplementsDataEntryRepo)
      : super(SupplementsDataEntryState.initial());
  final SupplementsDataEntryRepo _supplementsDataEntryRepo;

  Future<void> fetchAvailableVitamins() async {
    emit(state.copyWith(vitaminsStatus: RequestStatus.loading));
    final result = await _supplementsDataEntryRepo.retrieveAvailableVitamins(
      language: AppStrings.arabicLang,
    );
    result.when(
      success: (data) {
        emit(
          state.copyWith(
            vitaminsStatus: RequestStatus.success,
            availableVitamins: data,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            vitaminsStatus: RequestStatus.failure,
            responseMessage: failure.errors.first,
          ),
        );
      },
    );
  }

  void updateSupplementName(int index, String name) {
    if (index < 0 || index >= state.entries.length) return;
    final updatedEntries = List<SupplementEntry>.from(state.entries);
    updatedEntries[index] = updatedEntries[index].copyWith(name: name);
    emit(state.copyWith(entries: updatedEntries));
  }

  void updateDosage(int index, int dosage) {
    if (index < 0 || index >= state.entries.length) return;
    final updatedEntries = List<SupplementEntry>.from(state.entries);
    updatedEntries[index] =
        updatedEntries[index].copyWith(dosagePerDay: dosage);
    emit(state.copyWith(entries: updatedEntries));
  }

  List<SupplementEntry> buildSupplementsPayload() {
    return state.entries
        .where((e) => e.name != null && e.dosagePerDay > 0)
        .toList();
  }

  Future<void> submitSupplements() async {
    final supplements = buildSupplementsPayload();
    if (supplements.isEmpty) {
      emit(
        state.copyWith(
          requestStatus: RequestStatus.failure,
          responseMessage: "يرجى اختيار مكمل واحد على الأقل",
        ),
      );
      return;
    }

    emit(state.copyWith(requestStatus: RequestStatus.loading));
    final result = await _supplementsDataEntryRepo.submitSelectedSupplements(
      supplements: supplements,
    );

    result.when(
      success: (message) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.success,
            responseMessage: message,
          ),
        );
      },
      failure: (failure) {
        emit(
          state.copyWith(
            requestStatus: RequestStatus.failure,
            responseMessage: failure.errors.first,
          ),
        );
      },
    );
  }
}
