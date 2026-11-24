import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/networking/api_result.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/bookings/data/models/bookings_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/completed_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
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
        state.copyWith(
          status: RequestStatus.success,
          bookings: kDebugMode
              ? _withDemoWaiting(
                  _withDemoCompleted(_withDemoAppointment(bookings)),
                )
              : bookings,
        ),
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

  // TODO(prescription): remove once real bookings reach the call screen.
  /// Debug-only demo appointment at the top of today's list, so the doctor
  /// can open the call screen and its prescription without a real booking.
  /// Its meeting doesn't exist, so the video shows an error — the action
  /// tiles under it still work.
  static const demoAppointmentId = 'demo-prescription-booking';

  BookingsModel _withDemoAppointment(BookingsModel bookings) {
    final demo = TodayAppointmentModel(
      id: demoAppointmentId,
      patientName: "حجز تجريبي - الروشتة",
      patientPhotoUrl: null,
      type: AppointmentType.examination,
      startsAt: DateTime.now(),
    );
    return bookings.copyWith(
      todayAppointments: [
        demo,
        ...bookings.todayAppointments.where((a) => a.id != demoAppointmentId),
      ],
    );
  }

  // TODO(completed-bookings): remove once the backend sends
  // `completedAppointments`.
  /// Debug-only sample rows for "الكشوفات المنتهية" while the backend list
  /// is still empty. Real rows replace them as soon as any arrive.
  BookingsModel _withDemoCompleted(BookingsModel bookings) {
    if (bookings.completedAppointments.isNotEmpty) return bookings;
    final today = DateTime.now();
    DateTime at(int hour, int minute) =>
        DateTime(today.year, today.month, today.day, hour, minute);
    CompletedAppointmentModel row(
      String id,
      String name,
      AppointmentType type,
      DateTime startsAt,
    ) =>
        CompletedAppointmentModel(
          id: 'demo-completed-$id',
          patientName: name,
          type: type,
          startsAt: startsAt,
          completedAt: startsAt.add(const Duration(minutes: 20)),
        );

    return BookingsModel(
      doctorName: bookings.doctorName,
      specialty: bookings.specialty,
      doctorPhotoUrl: bookings.doctorPhotoUrl,
      todayAppointments: bookings.todayAppointments,
      waitingPatients: bookings.waitingPatients,
      // Last finished first, as the API will send them.
      completedAppointments: [
        row('4', "سارة عبدالرحمن علي", AppointmentType.consultation,
            at(12, 30)),
        row('3', "محمود السيد حسن", AppointmentType.examination, at(11, 15)),
        row('2', "منى إبراهيم يوسف", AppointmentType.consultation, at(10, 0)),
        row('1', "أحمد محمد عبدالله", AppointmentType.examination, at(9, 0)),
      ],
    );
  }

  // TODO(waiting-list): remove once the backend fills `waitingList`.
  /// Debug-only sample patients for "قائمة الانتظار" while the backend list
  /// is still empty. Accept / reject on them run locally (see
  /// [_isDemoBooking]) — the API doesn't know them.
  BookingsModel _withDemoWaiting(BookingsModel bookings) {
    if (bookings.waitingPatients.isNotEmpty) return bookings;
    final now = DateTime.now();
    WaitingPatientModel patient(
      String id,
      String name,
      AppointmentType type,
      int minutesAgo,
    ) =>
        WaitingPatientModel(
          id: 'demo-waiting-$id',
          patientName: name,
          patientPhotoUrl: null,
          type: type,
          requestedAt: now.subtract(Duration(minutes: minutesAgo)),
        );

    return bookings.copyWith(
      // Oldest request first, as the API will send them.
      waitingPatients: [
        patient('1', "خالد عبدالعزيز محمد", AppointmentType.examination, 25),
        patient('2', "نورا سامي الشريف", AppointmentType.consultation, 12),
        patient('3', "يوسف أحمد رمضان", AppointmentType.examination, 4),
      ],
    );
  }

  static bool _isDemoBooking(String bookingId) => bookingId.startsWith('demo-');

  /// Moves a waiting patient into today's appointments once the API confirms.
  Future<void> acceptWaitingPatient(WaitingPatientModel patient) async {
    if (!_startAction(patient.id)) return;

    final response = _isDemoBooking(patient.id)
        ? ApiResult<TodayAppointmentModel>.success(
            TodayAppointmentModel(
              id: patient.id,
              patientName: patient.patientName,
              patientPhotoUrl: patient.patientPhotoUrl,
              type: patient.type,
              startsAt: DateTime.now(),
            ),
          )
        : await _bookingsRepo.acceptWaitingPatient(patient);
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

    final response = _isDemoBooking(patient.id)
        ? const ApiResult<bool>.success(true)
        : await _bookingsRepo.rejectWaitingPatient(patient.id);
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
