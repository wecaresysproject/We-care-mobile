import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// App bar ملف الطبيب زى التصميم: زرار المشاركة والمزيد فى البداية،
/// العنوان فى المنتصف، وسهم الرجوع فى النهاية.
class DoctorProfileAppBar extends StatelessWidget {
  const DoctorProfileAppBar({
    super.key,
    required this.title,
    this.onSharePressed,
    this.onMorePressed,
  });

  final String title;
  final VoidCallback? onSharePressed;
  final VoidCallback? onMorePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _AppBarIconButton(
          icon: Icons.more_vert_rounded,
          onTap: onMorePressed,
        ),
        horizontalSpacing(4),
        _AppBarIconButton(
          icon: Icons.share_outlined,
          onTap: onSharePressed,
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
        ),
        _AppBarIconButton(
          icon: Icons.arrow_back_ios_new_rounded,
          iconSize: 18,
          onTap: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  const _AppBarIconButton({
    required this.icon,
    this.onTap,
    this.iconSize = 21,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 34.w,
        height: 34.h,
        child: Icon(
          icon,
          size: iconSize.sp,
          color: OnlineDoctorTheme.headingColor,
        ),
      ),
    );
  }
}
