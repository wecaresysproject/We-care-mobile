import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';
import 'package:we_care/features/doctor/bookings/data/models/waiting_patient_model.dart';

class BookingsModel {
  BookingsModel({
    required this.doctorName,
    required this.specialty,
    required this.doctorPhotoUrl,
    required this.todayAppointments,
    required this.waitingPatients,
  });

  /// `data` of the doctor bookings endpoint — `appointments[]` and
  /// `waitingList[]`. The backend sends no `doctor` object yet, so the header
  /// fields stay empty until it does.
  factory BookingsModel.fromJson(Map<String, dynamic> json) {
    final doctor = json['doctor'] as Map<String, dynamic>? ?? const {};
    return BookingsModel(
      doctorName: doctor['name'] as String? ?? '',
      specialty: doctor['specialty'] as String? ?? '',
      doctorPhotoUrl: bookingsImageUrl(doctor['profileImage']),
      todayAppointments: (json['appointments'] as List? ?? const [])
          .map((e) => TodayAppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      waitingPatients: (json['waitingList'] as List? ?? const [])
          .map((e) => WaitingPatientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String doctorName;
  final String specialty;
  final String? doctorPhotoUrl;

  /// Sorted by `startsAt` ascending, as the API returns them.
  final List<TodayAppointmentModel> todayAppointments;

  /// Oldest `requestedAt` first, as the API returns them.
  final List<WaitingPatientModel> waitingPatients;

  BookingsModel copyWith({
    List<TodayAppointmentModel>? todayAppointments,
    List<WaitingPatientModel>? waitingPatients,
  }) {
    return BookingsModel(
      doctorName: doctorName,
      specialty: specialty,
      doctorPhotoUrl: doctorPhotoUrl,
      todayAppointments: todayAppointments ?? this.todayAppointments,
      waitingPatients: waitingPatients ?? this.waitingPatients,
    );
  }
}
