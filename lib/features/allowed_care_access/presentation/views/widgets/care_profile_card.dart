import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/permission_badge.dart';

class CareProfileCard extends StatelessWidget {
  final CareProfile profile;
  final VoidCallback onEnterPressed;

  const CareProfileCard({
    super.key,
    required this.profile,
    required this.onEnterPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Side border color accent
            Container(
              width: 6,
              decoration: BoxDecoration(
                color: AppColorsManager.mainDarkBlue.withAlpha(150),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 48.w,
                          height: 48.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColorsManager.mainDarkBlue
                                  .withOpacity(0.1),
                              width: 2,
                            ),
                            image: DecorationImage(
                              image: (profile.personalPhotoUrl.isEmptyOrNull ||
                                      profile.personalPhotoUrl ==
                                          "لم يتم ادخال بيانات")
                                  ? const AssetImage(
                                          "assets/images/user_avatar.png")
                                      as ImageProvider
                                  : NetworkImage(profile.personalPhotoUrl),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        horizontalSpacing(12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (profile.name).firstAndLastName,
                              style: AppTextStyles.font14BlueWeight700.copyWith(
                                fontSize: 16.sp,
                              ),
                              textAlign: TextAlign.right,
                            ),
                            verticalSpacing(4),
                            Text(
                              profile.relation,
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: onEnterPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColorsManager.mainDarkBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: Text(
                            'دخول',
                            style: AppTextStyles.font14blackWeight400.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEEEEEE)),
                    // Bottom Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PermissionBadge(
                        permissionType: profile.permissionType,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
