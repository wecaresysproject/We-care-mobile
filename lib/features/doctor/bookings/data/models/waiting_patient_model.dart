import 'package:json_annotation/json_annotation.dart';
import 'package:we_care/features/doctor/bookings/data/models/appointment_type.dart';

part 'waiting_patient_model.g.dart';

@JsonSerializable()
class WaitingPatientModel {
  WaitingPatientModel({
    required this.id,
    required this.patientName,
    required this.patientPhotoUrl,
    required this.joinRequestTimeLabel,
    required this.type,
    required this.waitingMinutes,
  });

  final String id;
  final String patientName;
  final String? patientPhotoUrl;
  final String joinRequestTimeLabel;
  final AppointmentType type;
  final int waitingMinutes;

  factory WaitingPatientModel.fromJson(Map<String, dynamic> json) =>
      _$WaitingPatientModelFromJson(json);

  Map<String, dynamic> toJson() => _$WaitingPatientModelToJson(this);
}
