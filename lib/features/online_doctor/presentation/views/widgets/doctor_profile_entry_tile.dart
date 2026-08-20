import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// عنصر واحد جوه أقسام ملف الطبيب — عنوان، سطر تفاصيل، سنة،
/// وزرار فتح رابط اختيارى.
class DoctorProfileEntryTile extends StatelessWidget {
  const DoctorProfileEntryTile({
    super.key,
    required this.title,
    this.index,
    this.subtitle,
    this.trailingLine,
    this.actionLabel,
    this.onActionTap,
  });

  /// ترتيب العنصر — بيتعرض قبل العنوان فى الأقسام المرقّمة.
  final int? index;

  final String title;

  /// سطر التفاصيل تحت العنوان — مثال: "جامعة عين شمس — مصر".
  final String? subtitle;

  /// آخر سطر — السنة أو "منذ 2013".
  final String? trailingLine;

  /// نص زرار الرابط — مثال: "عرض البحث".
  final String? actionLabel;

  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    final titleStyle = AppTextStyles.font14blackWeight400.copyWith(
      fontSize: 11.sp,
      fontWeight: FontWeight.w700,
      height: 1.6,
      color: OnlineDoctorTheme.headingColor,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (index != null) ...[
          //* الرقم فى اتجاه LTR عشان النقطة تفضل بعده مش قبله.
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text("$index.", style: titleStyle),
          ),
          horizontalSpacing(5),
        ],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: titleStyle),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 10.sp,
                    height: 1.6,
                    color: OnlineDoctorTheme.sectionBodyText,
                  ),
                ),
              if (trailingLine != null)
                Text(
                  trailingLine!,
                  style: AppTextStyles.font12blackWeight400.copyWith(
                    fontSize: 9.5.sp,
                    height: 1.6,
                    color: OnlineDoctorTheme.mutedText,
                  ),
                ),
              if (actionLabel != null) ...[
                verticalSpacing(2),
                GestureDetector(
                  onTap: onActionTap,
                  behavior: HitTestBehavior.opaque,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        actionLabel!,
                        style: AppTextStyles.font12blackWeight400.copyWith(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: OnlineDoctorTheme.accentBlue,
                        ),
                      ),
                      horizontalSpacing(3),
                      Transform.flip(
                        flipX: true,
                        child: Icon(
                          Icons.north_east_rounded,
                          size: 12.sp,
                          color: OnlineDoctorTheme.accentBlue,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
