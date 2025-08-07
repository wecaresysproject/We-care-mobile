part of 'add_new_medicine_data_entry_cubit.dart';

@immutable
class AddNewMedicineDataEntryState extends Equatable {
  final String? medicineStartDate;
  final String? selectedMedicineName;
  final String? selectedMedicalForm;
  final String? selectedDose;
  final String? selectedNoOfDose;

  final bool isFormValidated;
  final List<String> medicinesNames;
  final List<String> medicineForms;
  final List<String> medicalDoses;
  final String medicineId;
  final String updatedDocumentId;
  final List<MedicineBasicInfoModel>? medicinesBasicInfo;
  final List<String> dosageFrequencies; // عدد مرات الجرعات
  final bool isEditMode;
  final String message; // error or success message

  final List<MatchedMedicineModel> matchedMedicines;
  final OptionsLoadingState medicinesNamesOptionsLoadingState;
  final OptionsLoadingState medicalFormsOptionsLoadingState;
  final OptionsLoadingState medicalDosesOptionsLoadingState;
  final OptionsLoadingState dosageFrequenciesOptionsLoadingState;
  final OptionsLoadingState allUsageCategoriesOptionsLoadingState;
  final OptionsLoadingState allDurationsBasedOnCategoryOptionsLoadingState;

  const AddNewMedicineDataEntryState({
    this.isFormValidated = false,
    this.message = '',
    this.isEditMode = false,
    this.medicineStartDate,
    this.selectedMedicineName,
    this.selectedMedicalForm,
    this.selectedDose,
    this.selectedNoOfDose,
    this.medicinesNames = const [],
    this.medicineForms = const [],
    this.medicalDoses = const [],
    this.medicinesBasicInfo = const [],
    this.dosageFrequencies = const [],
    this.medicineId = '',
    this.updatedDocumentId = '',
    this.matchedMedicines = const [],
    this.medicinesNamesOptionsLoadingState = OptionsLoadingState.loading,
    this.medicalFormsOptionsLoadingState = OptionsLoadingState.loading,
    this.medicalDosesOptionsLoadingState = OptionsLoadingState.loading,
    this.dosageFrequenciesOptionsLoadingState = OptionsLoadingState.loading,
    this.allUsageCategoriesOptionsLoadingState = OptionsLoadingState.loading,
    this.allDurationsBasedOnCategoryOptionsLoadingState =
        OptionsLoadingState.loading,
  }) : super();

  const AddNewMedicineDataEntryState.initialState()
      : this(
          isFormValidated: false,
          message: '',
          isEditMode: false,
          medicineStartDate: null,
          selectedMedicineName: null,
          selectedMedicalForm: null,
          selectedDose: null,
          selectedNoOfDose: null,
          medicinesNames: const [],
          medicineForms: const [],
          medicalDoses: const [],
          medicinesBasicInfo: const [],
          dosageFrequencies: const [],
          medicineId: '',
          updatedDocumentId: '',
          matchedMedicines: const [],
          medicinesNamesOptionsLoadingState: OptionsLoadingState.loading,
          medicalFormsOptionsLoadingState: OptionsLoadingState.loading,
          medicalDosesOptionsLoadingState: OptionsLoadingState.loading,
          dosageFrequenciesOptionsLoadingState: OptionsLoadingState.loading,
          allUsageCategoriesOptionsLoadingState: OptionsLoadingState.loading,
          allDurationsBasedOnCategoryOptionsLoadingState:
              OptionsLoadingState.loading,
        );

  AddNewMedicineDataEntryState copyWith({
    bool? isFormValidated,
    String? message,
    bool? isEditMode,
    String? medicineStartDate,
    String? selectedMedicineName,
    String? selectedMedicalForm,
    String? selectedDose,
    String? selectedNoOfDose,
    List<String>? medicinesNames,
    List<String>? medicineForms,
    List<String>? medicalDoses,
    String? medicineId,
    List<String>? dosageFrequencies,
    List<String>? allUsageCategories,
    List<String>? allDurationsBasedOnCategory,
    String? updatedDocumentId,
    List<MatchedMedicineModel>? matchedMedicines,
    OptionsLoadingState? medicinesNamesOptionsLoadingState,
    OptionsLoadingState? medicalFormsOptionsLoadingState,
    OptionsLoadingState? medicalDosesOptionsLoadingState,
    OptionsLoadingState? dosageFrequenciesOptionsLoadingState,
    OptionsLoadingState? allUsageCategoriesOptionsLoadingState,
    OptionsLoadingState? allDurationsBasedOnCategoryOptionsLoadingState,
  }) {
    return AddNewMedicineDataEntryState(
      isFormValidated: isFormValidated ?? this.isFormValidated,
      message: message ?? this.message,
      isEditMode: isEditMode ?? this.isEditMode,
      medicineStartDate: medicineStartDate ?? this.medicineStartDate,
      selectedMedicineName: selectedMedicineName ?? this.selectedMedicineName,
      selectedMedicalForm: selectedMedicalForm ?? this.selectedMedicalForm,
      selectedDose: selectedDose ?? this.selectedDose,
      selectedNoOfDose: selectedNoOfDose ?? this.selectedNoOfDose,
      medicinesNames: medicinesNames ?? this.medicinesNames,
      medicineForms: medicineForms ?? this.medicineForms,
      medicalDoses: medicalDoses ?? this.medicalDoses,
      medicineId: medicineId ?? this.medicineId,
      medicinesBasicInfo: medicinesBasicInfo ?? medicinesBasicInfo,
      dosageFrequencies: dosageFrequencies ?? this.dosageFrequencies,
      updatedDocumentId: updatedDocumentId ?? this.updatedDocumentId,
      matchedMedicines: matchedMedicines ?? this.matchedMedicines,
      medicinesNamesOptionsLoadingState: medicinesNamesOptionsLoadingState ??
          this.medicinesNamesOptionsLoadingState,
      medicalFormsOptionsLoadingState: medicalFormsOptionsLoadingState ??
          this.medicalFormsOptionsLoadingState,
      medicalDosesOptionsLoadingState: medicalDosesOptionsLoadingState ??
          this.medicalDosesOptionsLoadingState,
      dosageFrequenciesOptionsLoadingState:
          dosageFrequenciesOptionsLoadingState ??
              this.dosageFrequenciesOptionsLoadingState,
      allUsageCategoriesOptionsLoadingState:
          allUsageCategoriesOptionsLoadingState ??
              this.allUsageCategoriesOptionsLoadingState,
      allDurationsBasedOnCategoryOptionsLoadingState:
          allDurationsBasedOnCategoryOptionsLoadingState ??
              this.allDurationsBasedOnCategoryOptionsLoadingState,
    );
  }

  @override
  List<Object?> get props => [
        isFormValidated,
        message,
        isEditMode,
        medicineStartDate,
        selectedMedicineName,
        selectedMedicalForm,
        selectedDose,
        selectedNoOfDose,
        medicinesNames,
        medicineForms,
        medicalDoses,
        medicineId,
        medicinesBasicInfo,
        dosageFrequencies,
        updatedDocumentId,
        matchedMedicines,
        medicinesNamesOptionsLoadingState,
        medicalFormsOptionsLoadingState,
        medicalDosesOptionsLoadingState,
        dosageFrequenciesOptionsLoadingState,
        allUsageCategoriesOptionsLoadingState,
        allDurationsBasedOnCategoryOptionsLoadingState,
      ];
}
