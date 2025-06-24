part of 'glasses_data_entry_cubit.dart';

@immutable
class GlassesDataEntryState extends Equatable {
  final RequestStatus glassesEssentialDataEntryStatus;
  final String? errorMessage;
  final bool isFormValidated;
  final String? examinationDateSelection;
  final String message; // error or success message
  final List<String> doctorNames;
  final bool isEditMode;
  final String decoumentId;
  final String? selectedHospitalCenter;
  final String? doctorName;
  final String? glassesStore;
  final bool? antiReflection;
  final bool? isBlueLightProtection;
  final bool? isScratchResistance;
  final bool? isAntiFogCoating; // مضاد للضباب
  final bool? isAntiFingerprint; // مضاد لبصمات الأصابع
  final bool? isUVProtection;

  const GlassesDataEntryState({
    this.glassesEssentialDataEntryStatus = RequestStatus.initial,
    this.errorMessage,
    this.isFormValidated = false,
    this.examinationDateSelection,
    this.message = '',
    this.doctorNames = const [],
    this.isEditMode = false,
    this.decoumentId = '',
    this.selectedHospitalCenter,
    this.doctorName,
    this.glassesStore,
    this.antiReflection,
    this.isBlueLightProtection,
    this.isScratchResistance,
    this.isAntiFogCoating,
    this.isAntiFingerprint,
    this.isUVProtection,
  }) : super();

  const GlassesDataEntryState.initialState()
      : this(
          glassesEssentialDataEntryStatus: RequestStatus.initial,
          isFormValidated: false,
          examinationDateSelection: null,
          message: '',
          doctorNames: const [],
          isEditMode: false,
          decoumentId: '',
          selectedHospitalCenter: null,
          doctorName: null,
          glassesStore: null,
          antiReflection: null,
          isBlueLightProtection: null,
          isScratchResistance: null,
          isAntiFogCoating: null,
          isAntiFingerprint: null,
          isUVProtection: null,
        );

  GlassesDataEntryState copyWith({
    RequestStatus? glassesEssentialDataEntryStatus,
    String? errorMessage,
    bool? isFormValidated,
    String? examinationDateSelection,
    String? message,
    List<String>? doctorNames,
    bool? isEditMode,
    String? decoumentId,
    String? selectedHospitalCenter,
    String? doctorName,
    String? glassesStore,
    bool? antiReflection,
    bool? isBlueLightProtection,
    bool? isScratchResistance,
    bool? isAntiFogCoating,
    bool? isAntiFingerprint,
    bool? isUVProtection,
  }) {
    return GlassesDataEntryState(
      glassesEssentialDataEntryStatus: glassesEssentialDataEntryStatus ??
          this.glassesEssentialDataEntryStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      isFormValidated: isFormValidated ?? this.isFormValidated,
      examinationDateSelection:
          examinationDateSelection ?? this.examinationDateSelection,
      message: message ?? this.message,
      doctorNames: doctorNames ?? this.doctorNames,
      isEditMode: isEditMode ?? this.isEditMode,
      decoumentId: decoumentId ?? this.decoumentId,
      selectedHospitalCenter:
          selectedHospitalCenter ?? this.selectedHospitalCenter,
      doctorName: doctorName ?? this.doctorName,
      glassesStore: glassesStore ?? this.glassesStore,
      antiReflection: antiReflection ?? this.antiReflection,
      isBlueLightProtection:
          isBlueLightProtection ?? this.isBlueLightProtection,
      isScratchResistance: isScratchResistance ?? this.isScratchResistance,
      isAntiFogCoating: isAntiFogCoating ?? this.isAntiFogCoating,
      isAntiFingerprint: isAntiFingerprint ?? this.isAntiFingerprint,
      isUVProtection: isUVProtection ?? this.isUVProtection,
    );
  }

  @override
  List<Object?> get props => [
        glassesEssentialDataEntryStatus,
        errorMessage,
        isFormValidated,
        examinationDateSelection,
        message,
        doctorNames,
        isEditMode,
        decoumentId,
        selectedHospitalCenter,
        doctorName,
        glassesStore,
        antiReflection,
        isBlueLightProtection,
        isScratchResistance,
        isAntiFogCoating,
        isAntiFingerprint,
        isUVProtection,
      ];
}
