import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_cubit.dart';
import 'package:we_care/features/allowed_care_access/presentation/logic/access_management_state.dart';

class SubmitCareRequestButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitCareRequestButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccessManagementCubit, AccessManagementState>(
      builder: (context, state) {
        return AppCustomButton(
          isEnabled:
              state.selectedUser != null && state.selectedPermission.isNotEmpty,
          isLoading: state.createRequestStatus == RequestStatus.loading,
          onPressed: onPressed,
          title: 'إرسال الطلب',
        );
      },
    );
  }
}
