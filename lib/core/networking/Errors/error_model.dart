import 'package:json_annotation/json_annotation.dart';

// //! After Writing any thing in this class  or any making Simple edits
// //! We must run these Commands
// //!For dart
// //! dart pub run build_runner build
// //!For flutter
// //! flutter pub run build_runner build
part 'error_model.g.dart';

@JsonSerializable()
class ErrorModel {
  final String errorMessage;
  final int statusCode;
  ErrorModel({required this.errorMessage, required this.statusCode});

  factory ErrorModel.fromJson(Map<String, dynamic> json) =>
      _$ErrorModelFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorModelToJson(this);
}
