import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/booking_model.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'reschedule_appointment_state.dart';

class RescheduleAppointmentCubit extends Cubit<RescheduleAppointmentState> {
  RescheduleAppointmentCubit(this._onlineDoctorRepo)
      : super(const RescheduleAppointmentState());

  final OnlineDoctorRepo _onlineDoctorRepo;

  /// نفس endpoint المواعيد المتاحة بتاع شاشة "حجز موعد" — بـ id طبيب الحجز.
  Future<void> getDoctorAvailability(String doctorId) async {
    emit(state.copyWith(availabilityStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.getDoctorAvailability(
      doctorId: doctorId,
    );
    if (isClosed) return;

    result.when(
      success: (days) {
        emit(
          state.copyWith(
            availabilityStatus: RequestStatus.success,
            availableDays: days,
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            availabilityStatus: RequestStatus.failure,
            errorMessage: error.errors.first,
          ),
        );
      },
    );
  }

  Future<void> rescheduleBooking({
    required BookingModel booking,
    required AppointmentDayModel day,
    required AppointmentTimeSlot slot,
  }) async {
    if (state.rescheduleStatus == RequestStatus.loading) return;
    emit(state.copyWith(rescheduleStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.rescheduleBooking(
      bookingId: booking.bookingId,
      day: day,
      slot: slot,
    );
    if (isClosed) return;

    result.when(
      success: (updatedBooking) {
        emit(
          state.copyWith(
            rescheduleStatus: RequestStatus.success,
            // لو الرد مرجّعش الحجز بنبنيه من الميعاد اللى المريض اختاره.
            updatedBooking: updatedBooking ??
                booking.copyWith(
                  appointmentDateTime: slot.startsAt,
                  endsAt: slot.endsAt,
                ),
          ),
        );
      },
      failure: (error) {
        emit(
          state.copyWith(
            rescheduleStatus: RequestStatus.failure,
            rescheduleMessage: error.errors.first,
          ),
        );
      },
    );
  }
}
