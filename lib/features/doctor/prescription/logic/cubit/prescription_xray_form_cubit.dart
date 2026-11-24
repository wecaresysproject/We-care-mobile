import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/prescription/data/models/prescription_xray_model.dart';
import 'package:we_care/features/x_ray/data/models/body_parts_response_model.dart';
import 'package:we_care/features/x_ray/data/repos/x_ray_data_entry_repo.dart';

part 'prescription_xray_form_state.dart';

/// The add / edit X-ray sheet of the doctor's prescription. Reuses the
/// X-ray module's lookups: body part → its types → the type's purposes.
class PrescriptionXRayFormCubit extends Cubit<PrescriptionXRayFormState>
    with SafeEmitMixin {
  PrescriptionXRayFormCubit(this._xRayRepo)
      : super(const PrescriptionXRayFormState());

  final XRayDataEntryRepo _xRayRepo;

  /// [initialXRay] fills the form when editing an existing row.
  Future<void> init(PrescriptionXRayModel? initialXRay) async {
    if (initialXRay != null) {
      safeEmit(
        state.copyWith(
          isEditMode: true,
          selectedBodyPart: initialXRay.bodyPart,
          selectedType: () => initialXRay.type,
          selectedPurposes: initialXRay.purposes,
        ),
      );
    }
    await loadBodyParts();
    // Editing: the types of the saved body part, so it can be changed.
    if (initialXRay != null) await loadTypes();
  }

  Future<void> loadBodyParts() async {
    safeEmit(
      state.copyWith(bodyPartsLoadingState: OptionsLoadingState.loading),
    );
    final response = await _xRayRepo.getBodyPartsData();
    response.when(
      success: (bodyParts) => safeEmit(
        state.copyWith(
          bodyParts: bodyParts,
          bodyPartsLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(bodyPartsLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  /// النوع of the selected body part — same lookup as the X-ray module.
  Future<void> loadTypes() async {
    final bodyPart = state.selectedBodyPart;
    final matches = state.bodyParts.where((b) => b.bodyPartName == bodyPart);
    if (matches.isEmpty) {
      // A typed body part — the doctor writes the type by hand.
      safeEmit(
        state.copyWith(
          types: const [],
          typesLoadingState: OptionsLoadingState.loaded,
        ),
      );
      return;
    }
    safeEmit(state.copyWith(typesLoadingState: OptionsLoadingState.loading));
    final response =
        await _xRayRepo.getRadiologyTypeByBodyPartId(matches.first.id);
    // The doctor may have picked another body part while this was loading.
    if (state.selectedBodyPart != bodyPart) return;
    response.when(
      success: (bodyPartTypes) => safeEmit(
        state.copyWith(
          types: bodyPartTypes.radiologyTypeOfBodyPart,
          typesLoadingState: OptionsLoadingState.loaded,
        ),
      ),
      failure: (_) => safeEmit(
        state.copyWith(typesLoadingState: OptionsLoadingState.error),
      ),
    );
  }

  Future<void> updateBodyPart(String bodyPart) async {
    if (bodyPart == state.selectedBodyPart) return;
    safeEmit(
      state.copyWith(
        selectedBodyPart: bodyPart,
        // The old type and purposes belong to the previous body part.
        types: const [],
        selectedType: () => null,
        selectedPurposes: const [],
      ),
    );
    await loadTypes();
  }

  void updateType(String type) {
    if (type == state.selectedType) return;
    safeEmit(
      state.copyWith(
        selectedType: () => type,
        // The old purposes belong to the previous type.
        selectedPurposes: const [],
      ),
    );
  }

  /// Adds the purpose, or removes it when already picked.
  void togglePurpose(String purpose) {
    if (purpose.trim().isEmpty) return;
    final purposes = [...state.selectedPurposes];
    purposes.contains(purpose)
        ? purposes.remove(purpose)
        : purposes.add(purpose);
    safeEmit(state.copyWith(selectedPurposes: purposes));
  }

  void removePurpose(String purpose) {
    safeEmit(
      state.copyWith(
        selectedPurposes:
            state.selectedPurposes.where((p) => p != purpose).toList(),
      ),
    );
  }

  /// The filled row, or null while a required field is missing.
  PrescriptionXRayModel? buildXRay() {
    if (!state.isFormValid) return null;
    return PrescriptionXRayModel(
      bodyPart: state.selectedBodyPart!.trim(),
      type: state.selectedType!.trim(),
      purposes: state.selectedPurposes,
    );
  }
}
