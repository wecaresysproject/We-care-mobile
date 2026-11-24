part of 'prescription_medicine_form_cubit.dart';

@immutable
class PrescriptionMedicineFormState extends Equatable {
  const PrescriptionMedicineFormState({
    this.isEditMode = false,
    this.medicines = const [],
    this.namesLoadingState = OptionsLoadingState.loading,
    this.medicineId,
    this.selectedMedicineName,
    this.medicalForms = const [],
    this.formsLoadingState = OptionsLoadingState.loaded,
    this.selectedMedicalForm,
    this.doseAmounts = const [],
    this.doseAmountsLoadingState = OptionsLoadingState.loaded,
    this.selectedDoseAmount,
    this.dosageFrequencies = const [],
    this.frequenciesLoadingState = OptionsLoadingState.loading,
    this.selectedDoseFrequency,
    this.duration = '',
    this.instructions = '',
  });

  final bool isEditMode;

  /// اسم الدواء
  final List<MedicineBasicInfoModel> medicines;
  final OptionsLoadingState namesLoadingState;
  final String? medicineId;
  final String? selectedMedicineName;

  /// طريقة الاستخدام (الأشكال الدوائية)
  final List<String> medicalForms;
  final OptionsLoadingState formsLoadingState;
  final String? selectedMedicalForm;

  /// كمية الدواء
  final List<String> doseAmounts;
  final OptionsLoadingState doseAmountsLoadingState;
  final String? selectedDoseAmount;

  /// عدد مرات الجرعة
  final List<String> dosageFrequencies;
  final OptionsLoadingState frequenciesLoadingState;
  final String? selectedDoseFrequency;

  /// مدة الاستخدام
  final String duration;

  /// تعليمات — optional.
  final String instructions;

  List<String> get medicinesNames =>
      medicines.map((medicine) => medicine.tradeName).toList();

  bool get isFormValid =>
      _isFilled(selectedMedicineName) &&
      _isFilled(selectedMedicalForm) &&
      _isFilled(selectedDoseAmount) &&
      _isFilled(selectedDoseFrequency) &&
      _isFilled(duration);

  static bool _isFilled(String? value) =>
      value != null && value.trim().isNotEmpty;

  /// Nullable fields that can be cleared take a function, so `null` can be
  /// told apart from "not passed".
  PrescriptionMedicineFormState copyWith({
    bool? isEditMode,
    List<MedicineBasicInfoModel>? medicines,
    OptionsLoadingState? namesLoadingState,
    String? Function()? medicineId,
    String? selectedMedicineName,
    List<String>? medicalForms,
    OptionsLoadingState? formsLoadingState,
    String? Function()? selectedMedicalForm,
    List<String>? doseAmounts,
    OptionsLoadingState? doseAmountsLoadingState,
    String? Function()? selectedDoseAmount,
    List<String>? dosageFrequencies,
    OptionsLoadingState? frequenciesLoadingState,
    String? selectedDoseFrequency,
    String? duration,
    String? instructions,
  }) {
    return PrescriptionMedicineFormState(
      isEditMode: isEditMode ?? this.isEditMode,
      medicines: medicines ?? this.medicines,
      namesLoadingState: namesLoadingState ?? this.namesLoadingState,
      medicineId: medicineId != null ? medicineId() : this.medicineId,
      selectedMedicineName: selectedMedicineName ?? this.selectedMedicineName,
      medicalForms: medicalForms ?? this.medicalForms,
      formsLoadingState: formsLoadingState ?? this.formsLoadingState,
      selectedMedicalForm: selectedMedicalForm != null
          ? selectedMedicalForm()
          : this.selectedMedicalForm,
      doseAmounts: doseAmounts ?? this.doseAmounts,
      doseAmountsLoadingState:
          doseAmountsLoadingState ?? this.doseAmountsLoadingState,
      selectedDoseAmount: selectedDoseAmount != null
          ? selectedDoseAmount()
          : this.selectedDoseAmount,
      dosageFrequencies: dosageFrequencies ?? this.dosageFrequencies,
      frequenciesLoadingState:
          frequenciesLoadingState ?? this.frequenciesLoadingState,
      selectedDoseFrequency:
          selectedDoseFrequency ?? this.selectedDoseFrequency,
      duration: duration ?? this.duration,
      instructions: instructions ?? this.instructions,
    );
  }

  @override
  List<Object?> get props => [
        isEditMode,
        medicines,
        namesLoadingState,
        medicineId,
        selectedMedicineName,
        medicalForms,
        formsLoadingState,
        selectedMedicalForm,
        doseAmounts,
        doseAmountsLoadingState,
        selectedDoseAmount,
        dosageFrequencies,
        frequenciesLoadingState,
        selectedDoseFrequency,
        duration,
        instructions,
      ];
}
