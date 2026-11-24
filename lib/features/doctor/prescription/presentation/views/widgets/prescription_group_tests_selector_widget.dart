import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

/// Multi-select list of the tests under the picked lab group, with a
/// select-all toggle — the prescription's take on the lab tests module's
/// group table.
class PrescriptionGroupTestsSelectorWidget extends StatelessWidget {
  const PrescriptionGroupTestsSelectorWidget({
    super.key,
    required this.tests,
    required this.selectedTests,
    required this.loadingState,
    required this.onToggle,
    required this.onToggleAll,
    required this.onRetry,
  });

  final List<String> tests;
  final List<String> selectedTests;
  final OptionsLoadingState loadingState;
  final ValueChanged<String> onToggle;
  final VoidCallback onToggleAll;
  final VoidCallback onRetry;

  bool get _areAllSelected =>
      tests.isNotEmpty && tests.every(selectedTests.contains);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                loadingState == OptionsLoadingState.loaded && tests.isNotEmpty
                    ? "تحاليل المجموعة (${selectedTests.length}/${tests.length})"
                    : "تحاليل المجموعة",
                style: AppTextStyles.font18blackWight500,
              ),
            ),
            if (loadingState == OptionsLoadingState.loaded && tests.isNotEmpty)
              GestureDetector(
                onTap: onToggleAll,
                child: Text(
                  _areAllSelected ? "إلغاء الكل" : "تحديد الكل",
                  style: AppTextStyles.font14BlueWeight700.copyWith(
                    color: AppColorsManager.prescriptionActionBlue,
                  ),
                ),
              ),
          ],
        ),
        verticalSpacing(10),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: loadingState == OptionsLoadingState.loaded &&
                      tests.isNotEmpty &&
                      selectedTests.isEmpty
                  ? AppColorsManager.warningColor
                  : AppColorsManager.prescriptionTableDivider,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: _buildBody(),
        ),
        if (loadingState == OptionsLoadingState.loaded &&
            tests.isNotEmpty &&
            selectedTests.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Text(
              "اختر تحليل واحد على الأقل",
              style: TextStyle(
                color: AppColorsManager.warningColor,
                fontSize: 14.sp,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildBody() {
    switch (loadingState) {
      case OptionsLoadingState.loading:
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: const Center(
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        );
      case OptionsLoadingState.error:
        return InkWell(
          onTap: onRetry,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 20.r, color: Colors.red.shade700),
                horizontalSpacing(6),
                Text(
                  "حدث خطأ في تحميل التحاليل، اضغط لإعادة المحاولة",
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    color: Colors.red.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      case OptionsLoadingState.loaded:
        if (tests.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 12.w),
            child: Text(
              "لا توجد تحاليل مسجلة لهذه المجموعة",
              textAlign: TextAlign.center,
              style: AppTextStyles.font14blackWeight400.copyWith(
                color: AppColorsManager.prescriptionSubtitleColor,
              ),
            ),
          );
        }
        return Column(
          children: [
            for (var i = 0; i < tests.length; i++) ...[
              if (i > 0)
                const Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColorsManager.prescriptionTableDivider,
                ),
              _TestRow(
                name: tests[i],
                isSelected: selectedTests.contains(tests[i]),
                onTap: () => onToggle(tests[i]),
              ),
            ],
          ],
        );
    }
  }
}

class _TestRow extends StatelessWidget {
  const _TestRow({
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected
          ? AppColorsManager.prescriptionEditActionBackground
          : Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          child: Row(
            children: [
              Checkbox(
                value: isSelected,
                onChanged: (_) => onTap(),
                activeColor: AppColorsManager.prescriptionActionBlue,
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Text(
                  name,
                  style: AppTextStyles.font14blackWeight400.copyWith(
                    color: AppColorsManager.prescriptionTableText,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
