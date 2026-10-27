part of 'participant_search_cubit.dart';

class ParticipantSearchState extends Equatable {
  final RequestStatus searchStatus;

  /// نتايج آخر بحث — فاضية قبل أول بحث أو لو مفيش مستخدم بالرقم.
  final List<SearchPhoneNumberUser> results;

  /// المستخدم المختار من النتايج — `null` لحد ما يتختار واحد.
  final SearchPhoneNumberUser? selectedUser;

  /// رسالة فشل آخر بحث.
  final String errorMessage;

  const ParticipantSearchState({
    this.searchStatus = RequestStatus.initial,
    this.results = const [],
    this.selectedUser,
    this.errorMessage = '',
  });

  /// [selectedUser] بيتبعت صريح دايمًا عشان ينفع يتمسح بـ `null` مع كل بحث جديد.
  ParticipantSearchState copyWith({
    RequestStatus? searchStatus,
    List<SearchPhoneNumberUser>? results,
    required SearchPhoneNumberUser? selectedUser,
    String? errorMessage,
  }) {
    return ParticipantSearchState(
      searchStatus: searchStatus ?? this.searchStatus,
      results: results ?? this.results,
      selectedUser: selectedUser,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [searchStatus, results, selectedUser, errorMessage];
}
