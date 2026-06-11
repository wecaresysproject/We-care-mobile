import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/allowed_care_access/data/models/create_care_access_request.dart';
import 'package:we_care/features/allowed_care_access/data/models/search_phone_number_response.dart';
import 'package:we_care/features/allowed_care_access/data/repositories/access_management_repository.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';

class AccessManagementCubit extends Cubit<AccessManagementState>
    with SafeEmitMixin {
  final AccessManagementRepository _accessManagementRepository;

  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController relationController = TextEditingController();

  AccessManagementCubit(this._accessManagementRepository)
      : super(const AccessManagementState.initialState());

  Future<void> searchPhoneNumber() async {
    final phoneNumber = phoneNumberController.text.trim();
    //* add +2 to the beginning of the phone number if it doesn't start with it
    final String formattedNumber =
        phoneNumber.startsWith('+2') ? phoneNumber : '+2$phoneNumber';
    if (phoneNumber.isEmpty) return;
    safeEmit(state.copyWith(searchStatus: RequestStatus.loading));

    final result =
        await _accessManagementRepository.searchPhoneNumber(formattedNumber);

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            searchStatus: RequestStatus.success,
            message: data.message,
            searchResults: data.data.users,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            searchStatus: RequestStatus.failure,
            message: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  void updateSelectedUser(SearchPhoneNumberUser user) {
    safeEmit(state.copyWith(selectedUser: user));
  }

  void updateSelectedPermission(String permission) {
    safeEmit(state.copyWith(selectedPermission: permission));
  }

  Future<void> createCareAccessRequest() async {
    final relation = relationController.text.trim();
    if (relation.isEmpty) {
      safeEmit(state.copyWith(
        createRequestStatus: RequestStatus.failure,
        createRequestMessage: 'يرجى إدخال صلة القرابة',
      ));
      return;
    }

    if (state.selectedUser == null) {
      safeEmit(state.copyWith(
        createRequestStatus: RequestStatus.failure,
        createRequestMessage: 'يرجى اختيار مستخدم أولاً',
      ));
      return;
    }

    safeEmit(state.copyWith(createRequestStatus: RequestStatus.loading));

    final request = CreateCareAccessRequest(
      targetUserId: state.selectedUser!.userId.toString(),
      relation: relation,
      permission: state.selectedPermission,
    );

    final result =
        await _accessManagementRepository.createCareAccessRequest(request);

    result.when(
      success: (message) {
        safeEmit(
          state.copyWith(
            createRequestStatus: RequestStatus.success,
            createRequestMessage: message,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            createRequestStatus: RequestStatus.failure,
            createRequestMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> getIncomingCareAccessRequests() async {
    safeEmit(state.copyWith(incomingRequestsStatus: RequestStatus.loading));

    final result =
        await _accessManagementRepository.getIncomingCareAccessRequests();

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            incomingRequestsStatus: RequestStatus.success,
            incomingRequests: data,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            incomingRequestsStatus: RequestStatus.failure,
            incomingRequestsMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> getAllowedCareAccessList() async {
    safeEmit(state.copyWith(allowedCareAccessStatus: RequestStatus.loading));

    final result = await _accessManagementRepository.getAllowedCareAccessList();

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            allowedCareAccessStatus: RequestStatus.success,
            allowedCareAccessList: data,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            allowedCareAccessStatus: RequestStatus.failure,
            allowedCareAccessMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  Future<void> getCareAccessRequestDetails(String requestId) async {
    safeEmit(state.copyWith(requestDetailsStatus: RequestStatus.loading));

    final result = await _accessManagementRepository
        .getCareAccessRequestDetails(requestId);

    result.when(
      success: (data) {
        safeEmit(
          state.copyWith(
            requestDetailsStatus: RequestStatus.success,
            requestDetails: data,
          ),
        );
      },
      failure: (error) {
        safeEmit(
          state.copyWith(
            requestDetailsStatus: RequestStatus.failure,
            requestDetailsMessage: error.errors.join('\n'),
          ),
        );
      },
    );
  }

  @override
  Future<void> close() {
    phoneNumberController.dispose();
    relationController.dispose();
    return super.close();
  }
}
