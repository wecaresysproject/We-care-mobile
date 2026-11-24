part of 'prescription_xray_form_cubit.dart';

@immutable
class PrescriptionXRayFormState extends Equatable {
  const PrescriptionXRayFormState({
    this.isEditMode = false,
    this.bodyParts = const [],
    this.bodyPartsLoadingState = OptionsLoadingState.loading,
    this.selectedBodyPart,
    this.types = const [],
    this.typesLoadingState = OptionsLoadingState.loaded,
    this.selectedType,
    this.selectedPurposes = const [],
  });

  final bool isEditMode;

  /// منطقة الأشعة
  final List<BodyPartsResponseModel> bodyParts;
  final OptionsLoadingState bodyPartsLoadingState;
  final String? selectedBodyPart;

  /// النوع — with each type's purposes.
  final List<RadiologyTypeOfBodyPartModel> types;
  final OptionsLoadingState typesLoadingState;
  final String? selectedType;

  /// نوعية الاحتياج للأشعة
  final List<String> selectedPurposes;

  List<String> get bodyPartNames =>
      bodyParts.map((bodyPart) => bodyPart.bodyPartName).toList();

  List<String> get typeNames => types.map((type) => type.type).toList();

  /// The purposes of the selected type — empty for a typed type.
  List<String> get purposeOptions {
    final matches = types.where((type) => type.type == selectedType);
    return matches.isEmpty ? const [] : matches.first.purposes;
  }

  bool get isFormValid =>
      _isFilled(selectedBodyPart) && _isFilled(selectedType);

  static bool _isFilled(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// [selectedType] takes a function, so `null` can be told apart from
  /// "not passed".
  PrescriptionXRayFormState copyWith({
    bool? isEditMode,
    List<BodyPartsResponseModel>? bodyParts,
    OptionsLoadingState? bodyPartsLoadingState,
    String? selectedBodyPart,
    List<RadiologyTypeOfBodyPartModel>? types,
    OptionsLoadingState? typesLoadingState,
    String? Function()? selectedType,
    List<String>? selectedPurposes,
  }) {
    return PrescriptionXRayFormState(
      isEditMode: isEditMode ?? this.isEditMode,
      bodyParts: bodyParts ?? this.bodyParts,
      bodyPartsLoadingState:
          bodyPartsLoadingState ?? this.bodyPartsLoadingState,
      selectedBodyPart: selectedBodyPart ?? this.selectedBodyPart,
      types: types ?? this.types,
      typesLoadingState: typesLoadingState ?? this.typesLoadingState,
      selectedType: selectedType != null ? selectedType() : this.selectedType,
      selectedPurposes: selectedPurposes ?? this.selectedPurposes,
    );
  }

  @override
  List<Object?> get props => [
        isEditMode,
        bodyParts,
        bodyPartsLoadingState,
        selectedBodyPart,
        types,
        typesLoadingState,
        selectedType,
        selectedPurposes,
      ];
}
