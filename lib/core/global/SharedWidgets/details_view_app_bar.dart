import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/custom_action_button_widget.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_back_arrow.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class DetailsViewAppBar extends StatelessWidget {
  const DetailsViewAppBar(
      {super.key,
      required this.title,
      this.editFunction,
      this.deleteFunction,
      this.shareFunction,
      this.showActionButtons = true});
  final String title;
  final Function()? editFunction;
  final Function()? deleteFunction;
  final Function()? shareFunction;
  final bool showActionButtons;

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
                style: AppTextStyles.font20blackWeight600
                    .copyWith(fontSize: 21.sp),
              ),
            ),
          ],
        ),
        verticalSpacing(12),
        showActionButtons
            ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomActionButton(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('تأكيد الحذف'),
                            content: Text(
                                'هل أنت متأكد من أنك تريد حذف هذا العنصر؟'),
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
                  ),
                  horizontalSpacing(8.w),
                  CustomActionButton(
                      onTap: shareFunction,
                      title: 'ارسال',
                      icon: 'assets/images/share.png'),
                  horizontalSpacing(8.w),
                  CustomActionButton(
                    onTap: editFunction,
                    title: 'تعديل',
                    icon: 'assets/images/edit.png',
                    color: AppColorsManager.mainDarkBlue,
                  )
                ],
              )
            : SizedBox.shrink()
      ],
    );
  }
}
