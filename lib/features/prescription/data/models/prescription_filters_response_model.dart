import 'package:json_annotation/json_annotation.dart';

part 'prescription_filters_response_model.g.dart';

@JsonSerializable()
class PrescriptionFiltersResponseModel {
  List<int>? years;
  List<String>? doctors;
  @JsonKey(name: 'doctorspecialty')
  List<String>? specification;

  PrescriptionFiltersResponseModel(
      {this.years, this.doctors, this.specification});

  factory PrescriptionFiltersResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$PrescriptionFiltersResponseModelFromJson(json);
}
