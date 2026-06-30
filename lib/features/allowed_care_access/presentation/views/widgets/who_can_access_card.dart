import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/allowed_care_access/data/models/care_profile.dart';
import 'package:we_care/features/allowed_care_access/presentation/views/widgets/added_at_badge.dart';

class WhoCanAccessCard extends StatelessWidget {
  final CareProfile profile;
  final VoidCallback onManagePermissionsPressed;
  final VoidCallback onRevokeAccessPressed;

  const WhoCanAccessCard({
    super.key,
    required this.profile,
    required this.onManagePermissionsPressed,
    required this.onRevokeAccessPressed,
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
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Color(0xFFEEEEEE)),
                    // Bottom Section
                    Align(
                      alignment: Alignment.centerLeft,
                      child: AddedAtBadge(
                        label: profile.addedAtLabel,
                      ),
                    ),
                    verticalSpacing(16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onManagePermissionsPressed,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColorsManager.mainDarkBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              elevation: 0,
                            ),
                            child: Text(
                              'إدارة الصلاحيات',
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        horizontalSpacing(12),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (dialogContext) {
                                  return AlertDialog(
                                    title: const Text('تأكيد إلغاء الوصول'),
                                    content: const Text(
                                      'هل أنت متأكد من أنك تريد إلغاء وصول هذا الشخص لملفك الطبي؟',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                        child: const Text(
                                          'إلغاء',
                                          style: TextStyle(
                                              color: AppColorsManager
                                                  .mainDarkBlue),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                          onRevokeAccessPressed();
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                        ),
                                        child: Text(
                                          'تأكيد',
                                          style: AppTextStyles
                                              .font14blackWeight400
                                              .copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Color(0xFFE53935)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text(
                              'إلغاء الوصول',
                              style:
                                  AppTextStyles.font14blackWeight400.copyWith(
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFFE53935),
                              ),
                            ),
                          ),
                        ),
                      ],
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
