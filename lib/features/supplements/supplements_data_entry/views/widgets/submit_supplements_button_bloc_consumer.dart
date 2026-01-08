import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/routing/routes.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';

class SubmitSupplementsButtonBlocConsumer extends StatelessWidget {
  const SubmitSupplementsButtonBlocConsumer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupplementsDataEntryCubit, SupplementsDataEntryState>(
      listenWhen: (previous, current) =>
          current.requestStatus == RequestStatus.success ||
          current.requestStatus == RequestStatus.failure,
      listener: (context, state) async {
        if (state.requestStatus == RequestStatus.success) {
          await showSuccess(state.message);
          if (context.mounted) {
            await context.pushReplacementNamed(
              Routes.supplementsFollowUpPlansView,
            );
          }
        } else if (state.requestStatus == RequestStatus.failure) {
          await showError(state.message);
        }
      },
      builder: (context, state) {
        return AppCustomButton(
          isLoading: state.requestStatus == RequestStatus.loading,
          title: "التالي",
          onPressed: () async {
            await context.read<SupplementsDataEntryCubit>().submitSupplements();
          },
          isEnabled: state.entries.isNotEmpty,
        );
      },
    );
  }
}
