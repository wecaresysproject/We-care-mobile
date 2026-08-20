import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/online_doctor/presentation/views/widgets/online_doctor_theme.dart';

/// هيدر شاشة "التواصل مع الأطباء": زرار الشات فى البداية، العنوان والوصف فى
/// المنتصف، وصورة المستخدم فى النهاية.
class OnlineDoctorHeader extends StatefulWidget {
  const OnlineDoctorHeader({super.key, this.onChatTap});

  final VoidCallback? onChatTap;

  @override
  State<OnlineDoctorHeader> createState() => _OnlineDoctorHeaderState();
}

class _OnlineDoctorHeaderState extends State<OnlineDoctorHeader> {
  String userPhoto = "";

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();
  }

  Future<void> _loadUserPhoto() async {
    final photo = await CacheHelper.getString("userPhoto");
    if (mounted) {
      setState(() {
        userPhoto = photo;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: widget.onChatTap,
          child: Container(
            width: 48.w,
            height: 48.h,
            decoration: BoxDecoration(
              color: OnlineDoctorTheme.iconTint,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColorsManager.mainDarkBlue.withAlpha(20),
                  offset: const Offset(0, 3),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(
              Icons.chat_rounded,
              size: 22.sp,
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "التواصل مع الأطباء",
                textAlign: TextAlign.center,
                style: AppTextStyles.font20blackWeight600.copyWith(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: OnlineDoctorTheme.headingColor,
                ),
              ),
              verticalSpacing(2),
              Text(
                "نحن هنا لنهتم بصحتك",
                textAlign: TextAlign.center,
                style: AppTextStyles.font12blackWeight400.copyWith(
                  fontSize: 12.sp,
                  color: OnlineDoctorTheme.bodyColor,
                ),
              ),
            ],
          ),
        ),
        UserAvatarWidget(
          width: 48,
          height: 48,
          borderRadius: 24,
          userImageUrl: userPhoto,
        ),
      ],
    );
  }
}
