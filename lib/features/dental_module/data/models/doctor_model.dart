import 'package:json_annotation/json_annotation.dart';

part 'doctor_model.g.dart';

@JsonSerializable()
class Doctor {
  final String id;
  final String fullName;
  final String specialty;
  final String phoneNumber;
  final String governate;

  const Doctor({
    required this.id,
    required this.fullName,
    required this.specialty,
    required this.phoneNumber,
    required this.governate,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) => _$DoctorFromJson(json);
  Map<String, dynamic> toJson() => _$DoctorToJson(this);
}
