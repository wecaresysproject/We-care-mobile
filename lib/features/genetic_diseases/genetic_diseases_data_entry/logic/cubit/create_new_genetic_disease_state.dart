part of 'create_new_gentic_disease_cubit.dart';

@immutable
class CreateNewGeneticDiseaseState extends Equatable {
  final String? selectedDiseaseCategory;
  final List<String> diseasesClassfications;
  final List<String> diseasesStatuses; // حالة المرض
  final String message; // error or success message

  final String? selectedGeneticDisease;
  final String? selectedAppearanceAgeStage;
  final String? selectedPatientStatus;
  final bool isFormsValidated;
  final bool isEditingGeneticDiseaseSuccess;
  final bool isNewDiseaseAddedSuccefully;
  final bool isEditingGeneticDisease;

  const CreateNewGeneticDiseaseState({
    this.selectedDiseaseCategory,
    this.diseasesClassfications = const [],
    this.diseasesStatuses = const [],
    this.message = '',
    this.selectedGeneticDisease,
    this.selectedAppearanceAgeStage,
    this.selectedPatientStatus,
    this.isFormsValidated = false,
    this.isEditingGeneticDiseaseSuccess = false,
    this.isNewDiseaseAddedSuccefully = false,
    this.isEditingGeneticDisease = false,
  });

  const CreateNewGeneticDiseaseState.initial()
      : this(
          selectedDiseaseCategory: null,
          diseasesClassfications: const [],
          diseasesStatuses: const [],
          message: '',
          selectedGeneticDisease: null,
          selectedAppearanceAgeStage: null,
          selectedPatientStatus: null,
          isFormsValidated: false,
          isEditingGeneticDiseaseSuccess: false,
          isNewDiseaseAddedSuccefully: false,
          isEditingGeneticDisease: false,
        );
  CreateNewGeneticDiseaseState copyWith({
    String? selectedDiseaseCategory,
    List<String>? diseasesClassfications,
    List<String>? diseasesStatuses,
    String? message,
    String? selectedGeneticDisease,
    String? selectedAppearanceAgeStage,
    String? selectedPatientStatus,
    bool? isFormsValidated,
    bool? isEditingGeneticDiseaseSuccess,
    bool? isNewDiseaseAddedSuccefully,
    bool? isEditingGeneticDisease,
  }) {
    return CreateNewGeneticDiseaseState(
      selectedDiseaseCategory:
          selectedDiseaseCategory ?? this.selectedDiseaseCategory,
      diseasesClassfications:
          diseasesClassfications ?? this.diseasesClassfications,
      diseasesStatuses: diseasesStatuses ?? this.diseasesStatuses,
      message: message ?? this.message,
      selectedGeneticDisease:
          selectedGeneticDisease ?? this.selectedGeneticDisease,
      selectedAppearanceAgeStage:
          selectedAppearanceAgeStage ?? this.selectedAppearanceAgeStage,
      selectedPatientStatus:
          selectedPatientStatus ?? this.selectedPatientStatus,
      isFormsValidated: isFormsValidated ?? this.isFormsValidated,
      isEditingGeneticDiseaseSuccess:
          isEditingGeneticDiseaseSuccess ?? this.isEditingGeneticDiseaseSuccess,
      isNewDiseaseAddedSuccefully:
          isNewDiseaseAddedSuccefully ?? this.isNewDiseaseAddedSuccefully,
      isEditingGeneticDisease:
          isEditingGeneticDisease ?? this.isEditingGeneticDisease,
    );
  }

  @override
  List<Object?> get props => [
        selectedDiseaseCategory,
        diseasesClassfications,
        diseasesStatuses,
        message,
        selectedGeneticDisease,
        selectedAppearanceAgeStage,
        selectedPatientStatus,
        isFormsValidated,
        isEditingGeneticDiseaseSuccess,
        isNewDiseaseAddedSuccefully,
        isEditingGeneticDisease,
      ];
}
