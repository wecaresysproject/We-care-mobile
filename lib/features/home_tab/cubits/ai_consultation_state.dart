part of 'ai_consultation_cubit.dart';

class AIConsultationState extends Equatable {
  final RequestStatus status;
  final String message;
  final ModuleGuidanceDataModel? moduleGuidanceData;

  const AIConsultationState({
    this.status = RequestStatus.initial,
    this.message = '',
    this.moduleGuidanceData,
  });

  AIConsultationState copyWith({
    RequestStatus? status,
    String? message,
    ModuleGuidanceDataModel? moduleGuidanceData,
  }) {
    return AIConsultationState(
      status: status ?? this.status,
      message: message ?? this.message,
      moduleGuidanceData: moduleGuidanceData ?? this.moduleGuidanceData,
    );
  }

  @override
  List<Object?> get props => [status, message, moduleGuidanceData];
}
