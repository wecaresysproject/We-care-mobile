part of 'medical_specialty_cubit.dart';

class MedicalSpecialtyState extends Equatable {
  const MedicalSpecialtyState({
    required this.mainSpecialties,
    required this.selectedMainSpecialty,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory MedicalSpecialtyState.initial() => const MedicalSpecialtyState(
        mainSpecialties: [],
        selectedMainSpecialty: null,
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final List<String> mainSpecialties;
  final String? selectedMainSpecialty;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved medical specialty. The form shows only on
  /// success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved this module before, so the form
  /// opened pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  MedicalSpecialtyState copyWith({
    List<String>? mainSpecialties,
    String? selectedMainSpecialty,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return MedicalSpecialtyState(
      mainSpecialties: mainSpecialties ?? this.mainSpecialties,
      selectedMainSpecialty:
          selectedMainSpecialty ?? this.selectedMainSpecialty,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      loadStatus: loadStatus ?? this.loadStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
        mainSpecialties,
        selectedMainSpecialty,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
