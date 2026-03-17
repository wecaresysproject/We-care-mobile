import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_cubit.dart';
import 'package:we_care/features/medicine/medicines_data_entry/logic/cubit/medicines_data_entry_state.dart';

class MedicalCompitaiblitySystemPromptView extends StatefulWidget {
  const MedicalCompitaiblitySystemPromptView({super.key});

  @override
  State<MedicalCompitaiblitySystemPromptView> createState() =>
      _MedicalCompitaiblitySystemPromptViewState();
}

class _MedicalCompitaiblitySystemPromptViewState
    extends State<MedicalCompitaiblitySystemPromptView> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch on init
    context
        .read<MedicinesDataEntryCubit>()
        .fetchNewMedicalCompitabilitySystemPrompt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: const AppBarWithCenteredTitle(
              title: 'البرومبت الخاص بالنظام',
              showActionButtons: false,
            ),
          ),
          Expanded(
            child:
                BlocBuilder<MedicinesDataEntryCubit, MedicinesDataEntryState>(
              builder: (context, state) {
                if (state.fetchSystemPromptStatus == RequestStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.fetchSystemPromptStatus ==
                    RequestStatus.failure) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'حدث خطأ أثناء تحميل البرومبت',
                          style: AppTextStyles.font14BlueWeight700,
                        ),
                        if (state.message.isNotEmpty)
                          Text(
                            state.message,
                            style: AppTextStyles.font14BlueWeight700,
                            textAlign: TextAlign.center,
                          ),
                        verticalSpacing(16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<MedicinesDataEntryCubit>()
                                .fetchNewMedicalCompitabilitySystemPrompt();
                          },
                          child: Text(
                            'إعادة المحاولة',
                            style: AppTextStyles.font14BlueWeight700.copyWith(
                              color: AppColorsManager.criticalRisk,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (state.fetchSystemPromptStatus ==
                    RequestStatus.success) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: SelectableText(
                      state.medicalCompitabilitySystemPrompt ?? '',
                      style: AppTextStyles.font14BlueWeight700.copyWith(
                        height: 1.5,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
