import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_phone_number_response.g.dart';

@JsonSerializable(explicitToJson: true)
class SearchPhoneNumberResponse extends Equatable {
  final bool success;
  final String message;
  final SearchPhoneNumberData data;

  const SearchPhoneNumberResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SearchPhoneNumberResponse.fromJson(Map<String, dynamic> json) =>
      _$SearchPhoneNumberResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPhoneNumberResponseToJson(this);

  @override
  List<Object?> get props => [success, message, data];
}

@JsonSerializable(explicitToJson: true)
class SearchPhoneNumberData extends Equatable {
  final List<SearchPhoneNumberUser> users;

  const SearchPhoneNumberData({
    required this.users,
  });

  factory SearchPhoneNumberData.fromJson(Map<String, dynamic> json) =>
      _$SearchPhoneNumberDataFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPhoneNumberDataToJson(this);

  @override
  List<Object?> get props => [users];
}

@JsonSerializable(explicitToJson: true)
class SearchPhoneNumberUser extends Equatable {
  final int userId;
  final String fullName;
  final String phoneNumber;

  const SearchPhoneNumberUser({
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
  });

  factory SearchPhoneNumberUser.fromJson(Map<String, dynamic> json) =>
      _$SearchPhoneNumberUserFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPhoneNumberUserToJson(this);

  @override
  List<Object?> get props => [userId, fullName, phoneNumber];
}
