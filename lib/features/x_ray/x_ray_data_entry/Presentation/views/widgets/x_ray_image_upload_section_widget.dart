import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/image_preview_item_with_cancel.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';

class XRayImageUploadSection extends StatelessWidget {
  const XRayImageUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayDataEntryCubit, XRayDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الصور المرفوعة (${state.uploadedTestImages.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            SizedBox(height: 8.h),

            // Preview images
            if (state.uploadedTestImages.isNotEmpty)
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: state.uploadedTestImages
                    .map(
                      (imgPath) => ImageViewerWithCancel(
                        imageUrl: imgPath,
                        onRemove: () {
                          context
                              .read<XRayDataEntryCubit>()
                              .removeUploadedImage(imgPath);
                        },
                      ),
                    )
                    .toList(),
              ),

            SizedBox(height: 10.h),

            // 🩻 Upload area with success/error listener
            BlocListener<XRayDataEntryCubit, XRayDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.xRayImageRequestStatus != curr.xRayImageRequestStatus,
              listener: (context, state) async {
                if (state.xRayImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                } else if (state.xRayImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                containerBorderColor: (state.uploadedTestImages.isEmpty)
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();

                      if (isImagePicked && picker.isImagePickedAccepted) {
                        // Upload image
                        await context
                            .read<XRayDataEntryCubit>()
                            .uploadXrayImagePicked(
                              imagePath: picker.pickedImage!.path,
                            );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
