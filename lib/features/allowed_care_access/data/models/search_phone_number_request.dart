import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_phone_number_request.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchPhoneNumberRequest extends Equatable {
  final String phoneNumber;

  const SearchPhoneNumberRequest({
    required this.phoneNumber,
  });

  factory SearchPhoneNumberRequest.fromJson(Map<String, dynamic> json) =>
      _$SearchPhoneNumberRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPhoneNumberRequestToJson(this);

  @override
  List<Object?> get props => [phoneNumber];
}
