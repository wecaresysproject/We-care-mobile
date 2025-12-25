import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/nutration/nutration_data_entry/logic/cubit/nutration_data_entry_cubit.dart';

class SystemPromptView extends StatefulWidget {
  const SystemPromptView({super.key});

  @override
  State<SystemPromptView> createState() => _SystemPromptViewState();
}

class _SystemPromptViewState extends State<SystemPromptView> {
  @override
  void initState() {
    super.initState();
    // Trigger fetch on init
    context.read<NutrationDataEntryCubit>().fetchSystemPrompt();
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
                BlocBuilder<NutrationDataEntryCubit, NutrationDataEntryState>(
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
                        Text(
                          state.message,
                          style: AppTextStyles.font14BlueWeight700,
                          textAlign: TextAlign.center,
                        ),
                        verticalSpacing(16),
                        ElevatedButton(
                          onPressed: () {
                            context
                                .read<NutrationDataEntryCubit>()
                                .fetchSystemPrompt();
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
                      state.systemPrompt,
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
