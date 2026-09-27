import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_time_status.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/data/repos/bookings_repo.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState>
    with SafeEmitMixin<BookingsState> {
  BookingsCubit(this._bookingsRepo) : super(BookingsState.initial());

  final BookingsRepo _bookingsRepo;

  Future<void> getBookings() async {
    safeEmit(state.copyWith(status: RequestStatus.loading));
    final response = await _bookingsRepo.getBookings();
    response.when(
      success: (bookings) => safeEmit(
        state.copyWith(status: RequestStatus.success, bookings: bookings),
      ),
      failure: (error) => safeEmit(
        state.copyWith(
            status: RequestStatus.failure, message: error.errors.first),
      ),
    );
  }

  /// Moves a waiting patient into today's appointments.
  void acceptWaitingPatient(String patientId) {
    final bookings = state.bookings;
    if (bookings == null) return;

    final patient =
        bookings.waitingPatients.firstWhere((p) => p.id == patientId);
    final acceptedAppointment = TodayAppointmentModel(
      id: patient.id,
      patientName: patient.patientName,
      patientPhotoUrl: patient.patientPhotoUrl,
      bookingTimeLabel: patient.joinRequestTimeLabel,
      type: patient.type,
      timeStatus: AppointmentTimeStatus.due,
      statusMinutes: null,
    );

    safeEmit(state.copyWith(
      bookings: bookings.copyWith(
        todayAppointments: [...bookings.todayAppointments, acceptedAppointment],
        waitingPatients:
            bookings.waitingPatients.where((p) => p.id != patientId).toList(),
      ),
    ));
  }

  /// Removes a patient from the waiting list.
  void rejectWaitingPatient(String patientId) {
    final bookings = state.bookings;
    if (bookings == null) return;

    safeEmit(state.copyWith(
      bookings: bookings.copyWith(
        waitingPatients:
            bookings.waitingPatients.where((p) => p.id != patientId).toList(),
      ),
    ));
  }
}
