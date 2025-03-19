import 'package:json_annotation/json_annotation.dart';
part 'vaccine_filters_response_model.g.dart';

@JsonSerializable()
class VaccinesFiltersResponseModel {
  List<int> years;
  List<String> vaccineNames;

  VaccinesFiltersResponseModel(
      {required this.years, required this.vaccineNames});

  factory VaccinesFiltersResponseModel.fromJson(Map<String, dynamic> json) =>
      _$VaccinesFiltersResponseModelFromJson(json);
}
