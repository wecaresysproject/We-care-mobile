import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/Database/cach_helper.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

/// App bar بسهم رجوع فى البداية، عنوان فى المنتصف، وصورة المستخدم فى النهاية.
class DoctorSpecializationsAppBar extends StatefulWidget {
  const DoctorSpecializationsAppBar({super.key, required this.title});

  final String title;

  @override
  State<DoctorSpecializationsAppBar> createState() =>
      _DoctorSpecializationsAppBarState();
}

class _DoctorSpecializationsAppBarState
    extends State<DoctorSpecializationsAppBar> {
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
        const CustomBackArrow(),
        Expanded(
          child: Text(
            widget.title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(
              fontSize: 19.sp,
              color: Colors.black,
            ),
          ),
        ),
        UserAvatarWidget(
          width: 40,
          height: 40,
          borderRadius: 17,
          userImageUrl: userPhoto,
        ),
      ],
    );
  }
}
