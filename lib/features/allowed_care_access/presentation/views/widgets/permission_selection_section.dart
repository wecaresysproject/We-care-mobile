import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_option_card.dart';

class PermissionSelectionSection extends StatefulWidget {
  const PermissionSelectionSection({super.key});

  @override
  State<PermissionSelectionSection> createState() =>
      _PermissionSelectionSectionState();
}

class _PermissionSelectionSectionState
    extends State<PermissionSelectionSection> {
  int selectedIndex =
      1; // 1 means "تحكم كامل" is selected by default based on description

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الصلاحية المطلوبة',
          style: AppTextStyles.font16DarkGreyWeight400.copyWith(
            color: Colors.black,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        const Divider(height: 1, color: Color(0xFFEEEEEE)),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: PermissionOptionCard(
                isSelected: selectedIndex == 1,
                title: 'تحكم كامل',
                subtitle: 'عرض + تعديل',
                icon: Icons.edit_outlined,
                onTap: () {
                  setState(() {
                    selectedIndex = 1;
                  });
                },
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: PermissionOptionCard(
                isSelected: selectedIndex == 0,
                title: 'عرض فقط',
                subtitle: 'اطلاع فقط',
                icon: Icons.remove_red_eye_outlined,
                onTap: () {
                  setState(() {
                    selectedIndex = 0;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
