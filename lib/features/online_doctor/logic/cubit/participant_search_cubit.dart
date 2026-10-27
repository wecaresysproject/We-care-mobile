import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';
import 'package:we_care/features/allowed_care_access/data/repositories/access_management_repository.dart';

part 'participant_search_state.dart';

/// البحث عن مستخدم برقم الموبايل عشان يتضاف مشارك فى محادثة الكشف —
/// بنفس endpoint البحث بتاع "المسموح لهم بالرعاية".
class ParticipantSearchCubit extends Cubit<ParticipantSearchState>
    with SafeEmitMixin<ParticipantSearchState> {
  ParticipantSearchCubit(this._accessManagementRepository)
      : super(const ParticipantSearchState());

  final AccessManagementRepository _accessManagementRepository;

  Future<void> search(String phoneNumber) async {
    final phone = phoneNumber.trim();
    if (phone.isEmpty || state.searchStatus == RequestStatus.loading) return;

    // نفس تنسيق شاشة الرعاية: `+2` قدام الرقم لو مش موجود.
    final formattedNumber = phone.startsWith('+2') ? phone : '+2$phone';
    safeEmit(
      state.copyWith(searchStatus: RequestStatus.loading, selectedUser: null),
    );

    final result =
        await _accessManagementRepository.searchPhoneNumber(formattedNumber);

    result.when(
      success: (response) {
        final users = response.data.users;
        safeEmit(
          state.copyWith(
            searchStatus: RequestStatus.success,
            results: users,
            // نتيجة واحدة بتتختار على طول.
            selectedUser: users.length == 1 ? users.first : null,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            searchStatus: RequestStatus.failure,
            results: const [],
            selectedUser: null,
            errorMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  void selectUser(SearchPhoneNumberUser user) {
    safeEmit(state.copyWith(selectedUser: user));
  }
}
