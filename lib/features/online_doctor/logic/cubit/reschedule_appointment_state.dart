part of 'reschedule_appointment_cubit.dart';

class RescheduleAppointmentState extends Equatable {
  /// حالة تحميل الأيام المتاحة عند طبيب الحجز وتوقيتاتها.
  final RequestStatus availabilityStatus;
  final List<AppointmentDayModel> availableDays;
  final String errorMessage;

  /// حالة طلب تعديل الموعد نفسه — منفصلة عن تحميل المواعيد.
  final RequestStatus rescheduleStatus;

  /// رسالة فشل آخر طلب تعديل — بتتعرض كـ toast.
  final String rescheduleMessage;

  /// الحجز بميعاده الجديد بعد نجاح التعديل — بيرجع للشاشة اللى فتحت التعديل.
  final BookingModel? updatedBooking;

  const RescheduleAppointmentState({
    this.availabilityStatus = RequestStatus.initial,
    this.availableDays = const [],
    this.errorMessage = '',
    this.rescheduleStatus = RequestStatus.initial,
    this.rescheduleMessage = '',
    this.updatedBooking,
  });

  RescheduleAppointmentState copyWith({
    RequestStatus? availabilityStatus,
    List<AppointmentDayModel>? availableDays,
    String? errorMessage,
    RequestStatus? rescheduleStatus,
    String? rescheduleMessage,
    BookingModel? updatedBooking,
  }) {
    return RescheduleAppointmentState(
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      availableDays: availableDays ?? this.availableDays,
      errorMessage: errorMessage ?? this.errorMessage,
      rescheduleStatus: rescheduleStatus ?? this.rescheduleStatus,
      rescheduleMessage: rescheduleMessage ?? this.rescheduleMessage,
      updatedBooking: updatedBooking ?? this.updatedBooking,
    );
  }

  @override
  List<Object?> get props => [
        availabilityStatus,
        availableDays,
        errorMessage,
        rescheduleStatus,
        rescheduleMessage,
        updatedBooking,
      ];
}
