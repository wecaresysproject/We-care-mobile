import 'package:json_annotation/json_annotation.dart';

part 'all_categories_tickets_count.g.dart';

@JsonSerializable()
class AllCategoriesTicketsCount {
  bool success;
  String message;
  @JsonKey(name: 'data')
  CategoriesTicketsCount categoriesTicketsCount;

  AllCategoriesTicketsCount(
      {required this.success, required this.message, required this.categoriesTicketsCount});
  factory AllCategoriesTicketsCount.fromJson(Map<String, dynamic> json) => _$AllCategoriesTicketsCountFromJson(json);
}
@JsonSerializable()
class CategoriesTicketsCount {
  int labTest;
  int surgery;
  int emergency;
  int radiology;
  int medicine;
  int vaccine;
  int predescription;

  CategoriesTicketsCount(
      {required this.labTest,
      required this.surgery,
      required this.emergency,
      required this.radiology,
      required this.medicine,
      required this.vaccine,
      required this.predescription});
  factory CategoriesTicketsCount.fromJson(Map<String, dynamic> json) =>  _$CategoriesTicketsCountFromJson(json);

}
