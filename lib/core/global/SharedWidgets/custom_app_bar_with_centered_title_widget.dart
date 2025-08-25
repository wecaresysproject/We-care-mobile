import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AppBarWithCenteredTitle extends StatelessWidget
    implements PreferredSizeWidget {
  const AppBarWithCenteredTitle({
    super.key,
    required this.title,
    this.editFunction,
    this.deleteFunction,
    this.shareFunction,
    this.showShareButtonOnly = false,
    this.showActionButtons = true,
    this.titleColor,
  });
  final String title;
  final Function()? editFunction;
  final Function()? deleteFunction;
  final Function()? shareFunction;
  final bool showActionButtons;
  final bool showShareButtonOnly;
  final Color? titleColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Align(
              alignment: isArabic() ? Alignment.topRight : Alignment.topLeft,
              child: CustomBackArrow(),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font20blackWeight600.copyWith(
                    fontSize: 21.sp, color: titleColor ?? Colors.black),
              ),
            ),
          ],
        ),
        verticalSpacing(12),
        showActionButtons
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  !showShareButtonOnly
                      ? CustomActionButton(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('تأكيد الحذف',
                                      style: AppTextStyles
                                          .font16DarkGreyWeight400
                                          .copyWith(
                                        color: AppColorsManager.mainDarkBlue,
                                      )),
                                  content: Text(
                                      'هل أنت متأكد من أنك تريد حذف هذا العنصر؟',
                                      style: AppTextStyles
                                          .font16DarkGreyWeight400
                                          .copyWith(fontSize: 14.sp)),
                                  actions: [
                                    TextButton(
                                      child: Text('لا'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // يغلق الـ dialog
                                      },
                                    ),
                                    TextButton(
                                      child: Text('نعم'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // يغلق الـ dialog
                                        if (deleteFunction != null) {
                                          deleteFunction!(); // ينفذ دالة الحذف
                                        }
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          title: 'حذف',
                          icon: 'assets/images/delete.png',
                          color: AppColorsManager.warningColor,
                        )
                      : SizedBox.shrink(),
                  horizontalSpacing(8.w),
                  CustomActionButton(
                      onTap: shareFunction,
                      title: 'ارسال',
                      icon: 'assets/images/share.png'),
                  horizontalSpacing(8.w),
                  !showShareButtonOnly
                      ? CustomActionButton(
                          onTap: editFunction,
                          title: 'تعديل',
                          icon: 'assets/images/edit.png',
                          color: AppColorsManager.mainDarkBlue,
                        )
                      : SizedBox.shrink()
                ],
              )
            : SizedBox.shrink()
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
