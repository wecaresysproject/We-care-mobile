import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/waiting_patient_model.dart';
import 'package:we_care/features/doctor/bookings/data/repos/bookings_repo.dart';

part 'bookings_state.dart';

class BookingsCubit extends Cubit<BookingsState>
    with SafeEmitMixin<BookingsState> {
  BookingsCubit(this._bookingsRepo) : super(BookingsState.initial());

  final BookingsRepo _bookingsRepo;

  /// Loads the screen. With [silent] the current content stays on screen
  /// while it reloads (pull-to-refresh) and a failure keeps it too.
  Future<void> getBookings({bool silent = false}) async {
    if (!silent) safeEmit(state.copyWith(status: RequestStatus.loading));
    final response = await _bookingsRepo.getBookings();
    response.when(
      success: (bookings) => safeEmit(
        state.copyWith(status: RequestStatus.success, bookings: bookings),
      ),
      failure: (error) {
        if (silent) return;
        safeEmit(
          state.copyWith(
              status: RequestStatus.failure, message: error.errors.first),
        );
      },
    );
  }

  /// Moves a waiting patient into today's appointments once the API confirms.
  Future<void> acceptWaitingPatient(WaitingPatientModel patient) async {
    if (!_startAction(patient.id)) return;

    final response = await _bookingsRepo.acceptWaitingPatient(patient);
    response.when(
      success: (acceptedAppointment) {
        final bookings = state.bookings;
        if (bookings == null) return;
        safeEmit(state.copyWith(
          processingBookingId: '',
          actionStatus: RequestStatus.success,
          bookings: bookings.copyWith(
            todayAppointments: [
              ...bookings.todayAppointments
                  .where((a) => a.id != acceptedAppointment.id),
              acceptedAppointment,
            ]..sort((a, b) => a.startsAt.compareTo(b.startsAt)),
            waitingPatients: bookings.waitingPatients
                .where((p) => p.id != patient.id)
                .toList(),
          ),
        ));
      },
      failure: (error) => _onActionFailed(error.errors.first),
    );
  }

  /// Removes a patient from the waiting list once the API confirms.
  Future<void> rejectWaitingPatient(WaitingPatientModel patient) async {
    if (!_startAction(patient.id)) return;

    final response = await _bookingsRepo.rejectWaitingPatient(patient.id);
    response.when(
      success: (_) {
        final bookings = state.bookings;
        if (bookings == null) return;
        safeEmit(state.copyWith(
          processingBookingId: '',
          actionStatus: RequestStatus.success,
          bookings: bookings.copyWith(
            waitingPatients: bookings.waitingPatients
                .where((p) => p.id != patient.id)
                .toList(),
          ),
        ));
      },
      failure: (error) => _onActionFailed(error.errors.first),
    );
  }

  /// One accept / reject request at a time — false when one is running.
  bool _startAction(String bookingId) {
    if (state.processingBookingId.isNotEmpty) return false;
    safeEmit(state.copyWith(
      processingBookingId: bookingId,
      actionStatus: RequestStatus.loading,
    ));
    return true;
  }

  /// The patient may have left the waiting list meanwhile (`409`), so the
  /// lists are reloaded behind the error toast.
  void _onActionFailed(String message) {
    safeEmit(state.copyWith(
      processingBookingId: '',
      actionStatus: RequestStatus.failure,
      actionMessage: message,
    ));
    getBookings(silent: true);
  }
}
