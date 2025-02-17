import 'package:json_annotation/json_annotation.dart';

part 'api_error_model.g.dart';

// //! After Writing any thing in this class  or any making Simple edits
// //! We must run these Commands
// //!For dart
// //! dart pub run build_runner build
// //!For flutter
// //! flutter pub run build_runner build
@JsonSerializable()
class ApiErrorModel {
  final bool? success;
  final List<String> errors;

  ApiErrorModel({
    this.success,
    required this.errors,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ApiErrorModelToJson(this);
}
