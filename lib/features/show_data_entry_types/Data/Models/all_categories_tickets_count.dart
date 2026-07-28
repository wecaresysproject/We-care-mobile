import 'package:json_annotation/json_annotation.dart';

part 'all_categories_tickets_count.g.dart';

@JsonSerializable()
class AllCategoriesTicketsCount {
  bool success;
  String message;
  @JsonKey(name: 'data')
  CategoriesTicketsCount categoriesTicketsCount;

  AllCategoriesTicketsCount(
      {required this.success,
      required this.message,
      required this.categoriesTicketsCount});
  factory AllCategoriesTicketsCount.fromJson(Map<String, dynamic> json) =>
      _$AllCategoriesTicketsCountFromJson(json);
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
  int teeth;
  int allergies;
  int chronicDiseases;
  int eyes;
  int mentalHealth;
  int sportsActivities;
  int nutrition;
  int vitalActivities;
  int geneticDiseases;
  int monthlyHealthSurvey;
  int supplements;
  int riskBehaviors;

  CategoriesTicketsCount({
    this.labTest = 0,
    this.surgery = 0,
    this.emergency = 0,
    this.radiology = 0,
    this.medicine = 0,
    this.vaccine = 0,
    this.predescription = 0,
    this.riskBehaviors = 0,
    this.teeth = 0,
    this.allergies = 0,
    this.chronicDiseases = 0,
    this.eyes = 0,
    this.mentalHealth = 0,
    this.sportsActivities = 0,
    this.nutrition = 0,
    this.vitalActivities = 0,
    this.geneticDiseases = 0,
    this.monthlyHealthSurvey = 0,
    this.supplements = 0,
  });
  factory CategoriesTicketsCount.fromJson(Map<String, dynamic> json) =>
      _$CategoriesTicketsCountFromJson(json);
}
