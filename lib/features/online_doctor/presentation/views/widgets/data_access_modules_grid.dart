import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/font_weight_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/app_strings.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/core/models/medical_module_enum.dart';
import 'package:we_care/features/online_doctor/data/models/data_access_module_option.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/booking_glass_card.dart';
import 'package:we_care/features/show_data_entry_types/Presentation/views/widgets/medical_categories_types_grid_view.dart'
    as medical_categories;

/// عدد الكروت فى الصف الواحد زى التصميم.
const int _cardsPerRow = 4;

/// شبكة الموديولات اللى المريض بيختار منها اللى الطبيب يشوفه.
class DataAccessModulesGrid extends StatelessWidget {
  const DataAccessModulesGrid({
    super.key,
    required this.options,
    required this.selectedModules,
    required this.onModuleToggled,
  });

  final List<DataAccessModuleOption> options;
  final Set<MedicalModule> selectedModules;
  final ValueChanged<MedicalModule> onModuleToggled;

  @override
  Widget build(BuildContext context) {
    final rowsCount = (options.length / _cardsPerRow).ceil();

    return Column(
      children: [
        for (var row = 0; row < rowsCount; row++) ...[
          if (row != 0) verticalSpacing(22),
          Row(
            children: [
              for (var column = 0; column < _cardsPerRow; column++) ...[
                if (column != 0) horizontalSpacing(16),
                Expanded(
                  child: _moduleCardAt(row * _cardsPerRow + column),
                ),
              ],
            ],
          ),
        ],
      ],
    );
  }

  /// الصف الأخير ممكن ميكملش 4 كروت — بنسيب مكان فاضى بنفس العرض.
  Widget _moduleCardAt(int index) {
    if (index >= options.length) return SizedBox(height: 68.h);

    final option = options[index];
    return _ModuleCard(
      option: option,
      isSelected: selectedModules.contains(option.module),
      onTap: () => onModuleToggled(option.module),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  const _ModuleCard({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final DataAccessModuleOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconPath = option.iconOverride ?? _moduleIconPath(option.module);

    final card = BookingGlassCard(
      height: 68,
      borderRadius: 16,
      isSelected: isSelected,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconPath != null)
            Image.asset(iconPath,
                width: 28.w, height: 28.h, fit: BoxFit.contain),
          verticalSpacing(2),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              option.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeightHelper.medium,
                fontFamily: AppStrings.cairoFontFamily,
                height: 17 / 12,
                color: isSelected
                    ? AppColorsManager.mainDarkBlue
                    : AppColorsManager.textColor,
              ),
            ),
          ),
        ],
      ),
    );

    if (option.isEnabled) return card;

    // موديول لسه غير مفعّل — بيظهر باهت والضغط عليه مش بيعمل حاجة.
    return Opacity(
      opacity: 0.45,
      child: IgnorePointer(child: card),
    );
  }
}

/// بنجيب أيقونة الموديول من نفس مصدر شاشة "ملفاتى الطبية" عشان تفضل موحدة.
String? _moduleIconPath(MedicalModule module) {
  for (final category in medical_categories.categoriesView) {
    if (category["moduleNameIdentifier"] == module) {
      return category["image"] as String;
    }
  }
  return null;
}
