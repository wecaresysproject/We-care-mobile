part of 'medical_specialty_cubit.dart';

class MedicalSpecialtyState extends Equatable {
  const MedicalSpecialtyState({
    required this.mainSpecialties,
    required this.selectedMainSpecialty,
    required this.submissionStatus,
    required this.message,
  });

  factory MedicalSpecialtyState.initial() => const MedicalSpecialtyState(
        mainSpecialties: [],
        selectedMainSpecialty: null,
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final List<String> mainSpecialties;
  final String? selectedMainSpecialty;

  final RequestStatus submissionStatus;
  final String? message;

  MedicalSpecialtyState copyWith({
    List<String>? mainSpecialties,
    String? selectedMainSpecialty,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return MedicalSpecialtyState(
      mainSpecialties: mainSpecialties ?? this.mainSpecialties,
      selectedMainSpecialty:
          selectedMainSpecialty ?? this.selectedMainSpecialty,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        mainSpecialties,
        selectedMainSpecialty,
        submissionStatus,
        message,
      ];
}
