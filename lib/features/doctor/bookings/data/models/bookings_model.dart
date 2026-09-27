import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/bookings/data/models/today_appointment_model.dart';
import 'package:we_care/features/doctor/bookings/data/models/waiting_patient_model.dart';

part 'bookings_model.g.dart';

@JsonSerializable()
class BookingsModel {
  BookingsModel({
    required this.doctorName,
    required this.specialty,
    required this.doctorPhotoUrl,
    required this.todayAppointments,
    required this.waitingPatients,
  });

  final String doctorName;
  final String specialty;
  final String? doctorPhotoUrl;
  final List<TodayAppointmentModel> todayAppointments;
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

  factory BookingsModel.fromJson(Map<String, dynamic> json) =>
      _$BookingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingsModelToJson(this);
}
