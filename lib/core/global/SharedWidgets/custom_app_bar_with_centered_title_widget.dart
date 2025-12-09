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
    this.onbackArrowPress,
    this.showShareButtonOnly = false,
    this.showActionButtons = true,
    this.titleColor,
    this.fontSize,
    this.isMedicineModule = false,
    this.hasVideoIcon = false,
    this.onVideoTap,
  });

  final String title;
  final Function()? editFunction;
  final Function()? deleteFunction;
  final Function()? shareFunction;
  final bool showActionButtons;
  final bool showShareButtonOnly;
  final Color? titleColor;
  final double? fontSize;
  final void Function()? onbackArrowPress;
  final bool isMedicineModule;
  final bool hasVideoIcon;
  final Function()? onVideoTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitleRow(),
        verticalSpacing(12),
        _buildActionButtons(context),
      ],
    );
  }

  /// Builds the title row with back arrow, title, video icon, and medicine info
  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: isArabic() ? Alignment.topRight : Alignment.topLeft,
          child: CustomBackArrow(
            onTap: onbackArrowPress,
          ),
        ),
        Expanded(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.font20blackWeight600.copyWith(
              fontSize: fontSize?.sp ?? 21.sp,
              color: titleColor ?? Colors.black,
              fontFamily: "Cairo",
            ),
          ),
        ),
        if (hasVideoIcon) _buildVideoIcon(),
        if (isMedicineModule) _buildMedicineInfo(),
      ],
    );
  }

  /// Builds the video icon button
  Widget _buildVideoIcon() {
    return InkWell(
      onTap: onVideoTap,
      child: Image.asset(
        'assets/images/video icon.png',
        height: 50.h,
        width: 50.w,
      ),
    );
  }

  /// Builds the medicine module info text
  Widget _buildMedicineInfo() {
    return Text(
      "معلومات عن الدواء",
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w700,
        color: AppColorsManager.mainDarkBlue,
        decoration: TextDecoration.underline,
      ),
    );
  }

  /// Builds the action buttons row (delete, share, edit)
  Widget _buildActionButtons(BuildContext context) {
    if (!showActionButtons) {
      return const SizedBox.shrink();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!showShareButtonOnly) _buildDeleteButton(context),
        if (!showShareButtonOnly) horizontalSpacing(8.w),
        _buildShareButton(),
        horizontalSpacing(8.w),
        if (!showShareButtonOnly) _buildEditButton(),
      ],
    );
  }

  /// Builds the delete button with confirmation dialog
  Widget _buildDeleteButton(BuildContext context) {
    return CustomActionButton(
      onTap: () => _showDeleteConfirmationDialog(context),
      title: 'حذف',
      icon: 'assets/images/delete.png',
      color: AppColorsManager.warningColor,
    );
  }

  /// Builds the share button
  Widget _buildShareButton() {
    return CustomActionButton(
      onTap: shareFunction,
      title: 'ارسال',
      icon: 'assets/images/share.png',
    );
  }

  /// Builds the edit button
  Widget _buildEditButton() {
    return CustomActionButton(
      onTap: editFunction,
      title: 'تعديل',
      icon: 'assets/images/edit.png',
      color: AppColorsManager.mainDarkBlue,
    );
  }

  /// Shows the delete confirmation dialog
  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'تأكيد الحذف',
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              color: AppColorsManager.mainDarkBlue,
            ),
          ),
          content: Text(
            'هل أنت متأكد من أنك تريد حذف هذا العنصر؟',
            style: AppTextStyles.font16DarkGreyWeight400.copyWith(
              fontSize: 14.sp,
            ),
          ),
          actions: [
            TextButton(
              child: const Text('لا'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('نعم'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteFunction?.call();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}
