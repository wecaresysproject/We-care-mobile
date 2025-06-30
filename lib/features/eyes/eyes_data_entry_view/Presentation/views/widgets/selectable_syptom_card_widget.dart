// Reusable selectable symptom card widget
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/eyes/eyes_data_entry_view/Presentation/views/eye_procedures_and_syptoms_data_entry.dart';

class SelectableCard extends StatelessWidget {
  final SymptomAndProcedureItem symptom;
  final VoidCallback onTap;

  const SelectableCard({
    super.key,
    required this.symptom,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFECF5FF),
                Color(0xFFFBFDFF),
              ],
            ),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: AppColorsManager.placeHolderColor,
              width: .5,
            ),
          ),
          child: Row(
            children: [
              _buildCheckbox(),
              horizontalSpacing(12),
              Expanded(
                child: Text(
                  symptom.title,
                  style: AppTextStyles.font14blackWeight400,
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.ltr,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckbox() {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: symptom.isSelected
            ? AppColorsManager.mainDarkBlue
            : Colors.transparent,
        border: Border.all(
          color: symptom.isSelected ? Colors.transparent : Color(0xff777777),
          width: 2.5,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: symptom.isSelected
          ? const Icon(
              Icons.check,
              color: Colors.white,
              size: 16,
            )
          : null,
    );
  }
}
