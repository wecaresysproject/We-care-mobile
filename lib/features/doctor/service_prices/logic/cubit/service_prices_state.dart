part of 'service_prices_cubit.dart';

class ServicePricesState extends Equatable {
  const ServicePricesState({
    required this.offersFollowUpConsultation,
    required this.followUpConsultationValidityDays,
    required this.submissionStatus,
    required this.message,
    required this.loadStatus,
    required this.isEditMode,
    required this.hasChanges,
  });

  factory ServicePricesState.initial() => const ServicePricesState(
        offersFollowUpConsultation: true,
        followUpConsultationValidityDays: 7,
        submissionStatus: RequestStatus.initial,
        message: null,
        loadStatus: RequestStatus.initial,
        isEditMode: false,
        hasChanges: true,
      );

  final bool offersFollowUpConsultation;
  final int? followUpConsultationValidityDays;

  final RequestStatus submissionStatus;
  final String? message;

  /// Status of loading the saved prices. The form shows only on success.
  final RequestStatus loadStatus;

  /// True when the doctor already saved service prices before, so the form
  /// opened pre-filled and the button reads "حفظ التعديلات".
  final bool isEditMode;

  /// Whether the form differs from the saved data. Always true outside
  /// [isEditMode].
  final bool hasChanges;

  ServicePricesState copyWith({
    bool? offersFollowUpConsultation,
    int? Function()? followUpConsultationValidityDays,
    RequestStatus? submissionStatus,
    String? message,
    RequestStatus? loadStatus,
    bool? isEditMode,
    bool? hasChanges,
  }) {
    return ServicePricesState(
      offersFollowUpConsultation:
          offersFollowUpConsultation ?? this.offersFollowUpConsultation,
      followUpConsultationValidityDays: followUpConsultationValidityDays != null
          ? followUpConsultationValidityDays()
          : this.followUpConsultationValidityDays,
      submissionStatus: submissionStatus ?? this.submissionStatus,
      message: message ?? this.message,
      loadStatus: loadStatus ?? this.loadStatus,
      isEditMode: isEditMode ?? this.isEditMode,
      hasChanges: hasChanges ?? this.hasChanges,
    );
  }

  @override
  List<Object?> get props => [
        offersFollowUpConsultation,
        followUpConsultationValidityDays,
        submissionStatus,
        message,
        loadStatus,
        isEditMode,
        hasChanges,
      ];
}
