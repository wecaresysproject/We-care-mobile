import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_cubit.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compatibility/logic/medicines_compatibility_state.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/medicines_compitability_action_button_widget.dart';
import 'package:we_care/features/home_tab/Presentation/views/widgets/medicines_medical_history_status_bloc_builder_widget.dart';
import 'package:we_care/features/home_tab/Presentation/views/medicines_compitaability_sysptem_prompt.dart';
import 'package:we_care/features/medication_compatibility/presentation/views/widgets/medical_information_notice_widget.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_category_model.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_categories_data.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/category_filters_widget.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/medical_category_selection_widget.dart';
import 'package:we_care/features/my_medical_reports/presentation/widgets/medical_report_category_item.dart';

class MedicinesCompatibilityView extends StatefulWidget {
  const MedicinesCompatibilityView({super.key});

  @override
  State<MedicinesCompatibilityView> createState() =>
      _MedicinesCompatibilityViewState();
}

class _MedicinesCompatibilityViewState
    extends State<MedicinesCompatibilityView> {
  /// Track selected option values for the medications section (multi-selection)
  final Set<String> _selectedOptionValues = {};

  /// Track selected filters: {filterKey: {selectedValues}}
  final Map<String, Set<String>> _selectedFilters = {};

  /// Whether the checkbox (select all) is checked
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MedicinesCompatibilityCubit>()..initialRequests(),
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final cubit = getIt<MedicinesCompatibilityCubit>();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: cubit,
                  child: const MedicinesCompitaabilitySysptemPrompt(),
                ),
              ),
            );
          },
          backgroundColor: AppColorsManager.mainDarkBlue,
          child: const Icon(
            Icons.download,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(toolbarHeight: 0),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MedicinesCombitabilityAppBar(),
              verticalSpacing(24),
              const MedicinesMedicalHistoryStatusBlocBuilder(),
              verticalSpacing(8),
              _buildMedicationsSection(),
              verticalSpacing(40),
              const MedicinesCompitabilityActionButton(),
              verticalSpacing(16),
              const MedicalInformationNotice(),
              verticalSpacing(40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMedicationsSection() {
    return BlocBuilder<MedicinesCompatibilityCubit,
        MedicinesCompatibilityState>(
      builder: (context, state) {
        // Use dynamic data from API if available, otherwise use dummy
        final dummyCategory = medicinesCategory;
        final filterData = state.filterData;

        final category = MedicalCategoryModel(
          title: dummyCategory.title,
          image: dummyCategory.image,
          selectionType:
              filterData?.selectionType ?? dummyCategory.selectionType,
          radioOptions: filterData?.radioOptions ?? dummyCategory.radioOptions,
          filterSections:
              filterData?.filterSections ?? dummyCategory.filterSections,
        );

        return Column(
          children: [
            MedicalReportCategoryItem(
              title: category.title,
              iconPath: category.image,
              isExpanded: true, // Always expanded
              isSelected: _isSelected,
              onExpandToggle: () {
                // No-op: always expanded
              },
              onCheckboxToggle: () {
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
            ),
            // Always show the expanded content
            if (state.status == RequestStatus.loading)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: const Center(child: CircularProgressIndicator()),
              )
            else if (state.status == RequestStatus.failure)
              _buildErrorWidget(context, state.message)
            else ...[
              if (category.selectionType == MedicalSelectionType.selection ||
                  category.selectionType ==
                      MedicalSelectionType.selectionAndFilters)
                MedicalCategorySelectionWidget(
                  options: category.radioOptions,
                  selectedValues: _selectedOptionValues,
                  onChanged: (value, isSelected) {
                    setState(() {
                      if (isSelected) {
                        _selectedOptionValues.add(value);
                      } else {
                        _selectedOptionValues.remove(value);
                      }
                    });
                    context
                        .read<MedicinesCompatibilityCubit>()
                        .updateSelectedMedicines(_selectedOptionValues.toList());
                  },
                ),
              if (category.selectionType == MedicalSelectionType.filters ||
                  category.selectionType ==
                      MedicalSelectionType.selectionAndFilters)
                CategoryFiltersWidget(
                  filterSections: category.filterSections ?? [],
                  selectedFilters: _selectedFilters,
                  onFilterToggle: (sectionIndex, filterTitle, value) {
                    setState(() {
                      final String key = "${sectionIndex}_$filterTitle";
                      final selectedValues = _selectedFilters[key] ?? {};

                      if (selectedValues.contains(value)) {
                        selectedValues.remove(value);
                      } else {
                        selectedValues.add(value);
                      }
                      _selectedFilters[key] = selectedValues;
                    });
                    // Flatten all selected filter values to update recently expired medicines in Cubit
                    final allRecentlyExpired = _selectedFilters.values
                        .expand((values) => values)
                        .toList();
                    context
                        .read<MedicinesCompatibilityCubit>()
                        .updateRecentlyExpiredMedicines(allRecentlyExpired);
                  },
                ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48.sp,
              color: Colors.red.shade400,
            ),
            verticalSpacing(12),
            Text(
              message.isNotEmpty ? message : 'حدث خطأ أثناء تحميل البيانات',
              style: AppTextStyles.font14BlackMedium.copyWith(
                color: Colors.red.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            verticalSpacing(16),
            ElevatedButton.icon(
              onPressed: () {
                context
                    .read<MedicinesCompatibilityCubit>()
                    .fetchMedicinesFilters();
              },
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: Text(
                'إعادة المحاولة',
                style: AppTextStyles.font14BlackMedium.copyWith(
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColorsManager.mainDarkBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 10.h,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MedicinesCombitabilityAppBar extends StatelessWidget {
  const MedicinesCombitabilityAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MedicinesCompatibilityCubit,
        MedicinesCompatibilityState>(
      buildWhen: (previous, current) =>
          previous.moduleGuidanceData != current.moduleGuidanceData,
      builder: (context, state) {
        return CustomAppBarWithCenteredTitleWithGuidance(
          title: 'توافق أدويتي',
          trailingActions: [
            CircleIconButton(
              size: 30.w,
              icon: Icons.play_arrow,
              color: state.moduleGuidanceData?.videoLink?.isNotEmpty == true
                  ? AppColorsManager.mainDarkBlue
                  : Colors.grey,
              onTap: state.moduleGuidanceData?.videoLink?.isNotEmpty == true
                  ? () =>
                      launchYouTubeVideo(state.moduleGuidanceData!.videoLink)
                  : null,
            ),
            horizontalSpacing(8.w),
            CircleIconButton(
              size: 30.w,
              icon: Icons.menu_book_outlined,
              color: state.moduleGuidanceData?.moduleGuidanceText?.isNotEmpty ==
                      true
                  ? AppColorsManager.mainDarkBlue
                  : Colors.grey,
              onTap: state.moduleGuidanceData?.moduleGuidanceText?.isNotEmpty ==
                      true
                  ? () {
                      ModuleGuidanceAlertDialog.show(
                        context,
                        title: "توافق الأدوية",
                        description:
                            state.moduleGuidanceData!.moduleGuidanceText!,
                      );
                    }
                  : null,
            ),
          ],
        );
      },
    );
  }
}
