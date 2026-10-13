import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/features/online_doctor/data/models/appointment_slot_model.dart';
import 'package:we_care/features/online_doctor/data/models/book_appointment_request.dart';
import 'package:we_care/features/online_doctor/data/repos/online_doctor_repo.dart';

part 'book_appointment_state.dart';

class BookAppointmentCubit extends Cubit<BookAppointmentState> {
  BookAppointmentCubit(this._onlineDoctorRepo)
      : super(const BookAppointmentState());

  final OnlineDoctorRepo _onlineDoctorRepo;

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

  Future<void> bookAppointment(BookAppointmentRequest request) async {
    if (state.bookingStatus == RequestStatus.loading) return;
    emit(state.copyWith(bookingStatus: RequestStatus.loading));

    final result = await _onlineDoctorRepo.bookAppointment(request: request);
    if (isClosed) return;

    result.when(
      success: (_) {
        emit(state.copyWith(bookingStatus: RequestStatus.success));
      },
      failure: (error) {
        emit(
          state.copyWith(
            bookingStatus: RequestStatus.failure,
            bookingMessage: error.errors.first,
          ),
        );
      },
    );
  }
}
