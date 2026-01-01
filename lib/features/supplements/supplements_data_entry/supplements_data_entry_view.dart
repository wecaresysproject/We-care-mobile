import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/SharedWidgets/user_selection_container_shared_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/supplements/data/models/supplement_entry_model.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_cubit.dart';
import 'package:we_care/features/supplements/supplements_data_entry/logic/supplements_data_entry_state.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/dose_counter_widget.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/labeled_icon_widget.dart';
import 'package:we_care/features/supplements/supplements_data_entry/views/widgets/submit_supplements_button_bloc_consumer.dart';

class SupplementsDataEntryView extends StatefulWidget {
  const SupplementsDataEntryView({super.key});

  @override
  State<SupplementsDataEntryView> createState() =>
      _SupplementsDataEntryViewState();
}

class _SupplementsDataEntryViewState extends State<SupplementsDataEntryView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<SupplementsDataEntryCubit>()..fetchAvailableVitamins(),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0.h,
        ),
        body: BlocBuilder<SupplementsDataEntryCubit, SupplementsDataEntryState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
              child: Column(
                children: [
                  AppBarWithCenteredTitle(
                    title: "مكملاتك الغذائية",
                    showActionButtons: false,
                  ),
                  verticalSpacing(24),
                  Text(
                    'ابدأ قرص فيتامينات او مكملات غذائيه \n'
                    'هنتابع معك كيف جسمك سيستفيد.',
                    style: AppTextStyles.font20blackWeight600.copyWith(
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      fontFamily: "Rubik",
                    ),
                  ),
                  verticalSpacing(24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const LabeledIcon(
                        icon: Icons.medication,
                        text: "الفيتامين أو المكمل",
                      ),
                      const LabeledIcon(
                        icon: Icons.rule,
                        text: "الجرعة/اليوم",
                      ),
                    ],
                  ),
                  verticalSpacing(24),
                  if (state.vitaminsStatus == RequestStatus.loading)
                    const Center(child: CircularProgressIndicator())
                  else ...[
                    ...List.generate(
                      state.entries.length,
                      (index) => Column(
                        children: [
                          _buildRow(
                            index,
                            state.availableVitamins,
                            state.entries[index],
                            context.read<SupplementsDataEntryCubit>(),
                          ),
                          if (index != state.entries.length - 1)
                            verticalSpacing(24),
                        ],
                      ),
                    ),
                  ],
                  verticalSpacing(30),
                  SubmitSupplementsButtonBlocConsumer(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRow(
    int index,
    List<String> options,
    SupplementEntry entry,
    SupplementsDataEntryCubit cubit,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: UserSelectionContainer(
            bottomSheetTitle: "ابحث عن الإسم ....",
            onOptionSelected: (value) {
              cubit.updateSupplementName(index, value);
            },
            containerHintText: entry.name ?? "ابحث عن الإسم ....",
            searchHintText: "ابحث عن الإسم ....",
            options: options,
          ),
        ),
        horizontalSpacing(12),
        Expanded(
          flex: 2,
          child: DoseCounter(
            initialValue: entry.dosagePerDay,
            onChanged: (value) {
              cubit.updateDosage(index, value);
            },
          ),
        ),
      ],
    );
  }
}
