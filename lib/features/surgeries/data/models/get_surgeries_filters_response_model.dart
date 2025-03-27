import 'package:json_annotation/json_annotation.dart';

part 'get_surgeries_filters_response_model.g.dart';

@JsonSerializable()
class GetSurgeriesFiltersResponseModel {
  List<int>? years;
  List<String>? surgeryNames;

  GetSurgeriesFiltersResponseModel({
    this.years,
    this.surgeryNames,
  });

  factory GetSurgeriesFiltersResponseModel.fromJson(
          Map<String, dynamic> json) =>
      _$GetSurgeriesFiltersResponseModelFromJson(json);
}
