part of 'service_prices_cubit.dart';

class ServicePricesState extends Equatable {
  const ServicePricesState({
    required this.offersFollowUpConsultation,
    required this.followUpConsultationValidityDays,
    required this.submissionStatus,
    required this.message,
  });

  factory ServicePricesState.initial() => const ServicePricesState(
        offersFollowUpConsultation: true,
        followUpConsultationValidityDays: 7,
        submissionStatus: RequestStatus.initial,
        message: null,
      );

  final bool offersFollowUpConsultation;
  final int? followUpConsultationValidityDays;

  final RequestStatus submissionStatus;
  final String? message;

  ServicePricesState copyWith({
    bool? offersFollowUpConsultation,
    int? Function()? followUpConsultationValidityDays,
    RequestStatus? submissionStatus,
    String? message,
  }) {
    return ServicePricesState(
      offersFollowUpConsultation:
          offersFollowUpConsultation ?? this.offersFollowUpConsultation,
      followUpConsultationValidityDays: followUpConsultationValidityDays != null
          ? followUpConsultationValidityDays()
          : this.followUpConsultationValidityDays,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        offersFollowUpConsultation,
        followUpConsultationValidityDays,
        submissionStatus,
        message,
      ];
}
