import 'package:json_annotation/json_annotation.dart';

part 'service_prices_request_body_model.g.dart';

@JsonSerializable()
class ServicePricesRequestBodyModel {
  final double examinationPriceInsideEgypt;
  final double examinationPriceOutsideEgypt;
  final bool offersFollowUpConsultation;
  final int? followUpConsultationValidityDays;

  ServicePricesRequestBodyModel({
    required this.examinationPriceInsideEgypt,
    required this.examinationPriceOutsideEgypt,
    required this.offersFollowUpConsultation,
    required this.followUpConsultationValidityDays,
  });

  Map<String, dynamic> toJson() => _$ServicePricesRequestBodyModelToJson(this);
}
