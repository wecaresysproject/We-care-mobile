import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

Future<void> showImagePicker(BuildContext context,
    {Function(bool)? onImagePicked}) async {
  await showModalBottomSheet(
    context: context,
    backgroundColor: AppColorsManager.scaffoldBackGroundColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(18.r),
      ),
    ),
    builder: (BuildContext context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text(
              "ارفق صورة",
              style: AppTextStyles.font18blackWight500.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/images/image_picker.png",
              height: 21.h,
              width: 21.w,
            ),
            title: Text(
              'اختر من المعرض',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: Color(0xff555555),
              ),
            ),
            onTap: () async {
              context.pop();
              bool result = await _pickImageFromGallery(context);
              if (onImagePicked != null && result) {
                onImagePicked(result); // Call callback function
              }
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/images/camera_icon.png",
              height: 21.h,
              width: 21.w,
            ),
            title: Text(
              'اختر من الكاميرا',
              style: AppTextStyles.font16DarkGreyWeight400.copyWith(
                color: Color(0xff555555),
              ),
            ),
            onTap: () async {
              context.pop();
              bool result = await _pickImageFromCamera(context);
              if (onImagePicked != null && result) {
                onImagePicked(result); // Call callback only if it's provided
              }
            },
          ),
        ],
      );
    },
  );
}

Future<bool> _pickImageFromGallery(BuildContext context) async {
  final picker = getIt.get<ImagePickerService>();

  final result = await picker.pickImageFromGallery(context.translate);

  return result;
}

Future<bool> _pickImageFromCamera(BuildContext context) async {
  final picker = getIt.get<ImagePickerService>();

  final result = await picker.pickImageFromCamera(context.translate);

  return result;
}
