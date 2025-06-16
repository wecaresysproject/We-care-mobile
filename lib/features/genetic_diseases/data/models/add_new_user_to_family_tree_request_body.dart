import 'package:json_annotation/json_annotation.dart';

part 'add_new_user_to_family_tree_request_body.g.dart';

@JsonSerializable()
class AddNewUserToFamilyTreeRequestBodyModel {
  final String name;
  final String code;

  AddNewUserToFamilyTreeRequestBodyModel({
    required this.name,
    required this.code,
  });

  factory AddNewUserToFamilyTreeRequestBodyModel.fromJson(
          Map<String, dynamic> json) =>
      _$AddNewUserToFamilyTreeRequestBodyModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$AddNewUserToFamilyTreeRequestBodyModelToJson(this);
}
