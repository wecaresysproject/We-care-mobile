import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/doctor/prescription/data/models/previous_prescription_model.dart';
import 'package:we_care/features/doctor/prescription/data/repos/doctor_prescription_repo.dart';

/// What `Routes.doctorPreviousPrescriptionsView` takes: the call's booking
/// (the call screen's "الروشتات القديمة") or a patient (from "ملفات المرضى
/// القدامى").
class PreviousPrescriptionsArgs {
  const PreviousPrescriptionsArgs.booking(String this.bookingId)
      : patientId = null;

  const PreviousPrescriptionsArgs.patient(String this.patientId)
      : bookingId = null;

  final String? bookingId;
  final String? patientId;
}

/// "روشتات المريض": loads the prescriptions the doctor wrote for the
/// patient: from the call's booking (earlier bookings only) or by patient.
class PreviousPrescriptionsCubit extends Cubit<PreviousPrescriptionsState>
    with SafeEmitMixin {
  PreviousPrescriptionsCubit(this._repo)
      : super(const PreviousPrescriptionsState());

  final DoctorPrescriptionRepo _repo;

  Future<void> load(PreviousPrescriptionsArgs args) async {
    safeEmit(const PreviousPrescriptionsState(status: RequestStatus.loading));
    final bookingId = args.bookingId;
    final result = bookingId != null
        ? await _repo.getPreviousPrescriptions(bookingId)
        : await _repo.getPatientPrescriptions(args.patientId!);
    result.when(
      success: (data) => safeEmit(
        PreviousPrescriptionsState(status: RequestStatus.success, data: data),
      ),
      failure: (error) => safeEmit(
        PreviousPrescriptionsState(
          status: RequestStatus.failure,
          message: error.errors.isNotEmpty ? error.errors.first : null,
        ),
      ),
    );
  }
}

@immutable
class PreviousPrescriptionsState extends Equatable {
  const PreviousPrescriptionsState({
    this.status = RequestStatus.initial,
    this.data,
    this.message,
  });

  final RequestStatus status;
  final PreviousPrescriptionsModel? data;

  /// The load error, when [status] is failure.
  final String? message;

  @override
  List<Object?> get props => [status, data, message];
}
