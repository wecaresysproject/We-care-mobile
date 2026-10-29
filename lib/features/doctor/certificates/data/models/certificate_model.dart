import 'package:json_annotation/json_annotation.dart';

part 'certificate_model.g.dart';

@JsonSerializable()
class CertificateModel {
  final String degreeTitle;
  final String grantingBody;
  final String countryName;
  final String obtainedDate;

  CertificateModel({
    required this.degreeTitle,
    required this.grantingBody,
    required this.countryName,
    required this.obtainedDate,
  });

  factory CertificateModel.fromJson(Map<String, dynamic> json) =>
      _$CertificateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CertificateModelToJson(this);
}
