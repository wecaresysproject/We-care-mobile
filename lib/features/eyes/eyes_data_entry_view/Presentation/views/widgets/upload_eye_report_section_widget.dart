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
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';

class EyeReportUploadSection extends StatelessWidget {
  const EyeReportUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EyesDataEntryCubit, EyesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.uploadedReportImages != current.uploadedReportImages,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "رفع صورة التقرير الطبي (${state.uploadedReportImages.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            SizedBox(height: 8.h),

            // Preview images
            if (state.uploadedReportImages.isNotEmpty)
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: state.uploadedReportImages
                    .map(
                      (imgPath) => ImageViewerWithCancel(
                        imageUrl: imgPath,
                        onRemove: () {
                          context
                              .read<EyesDataEntryCubit>()
                              .removeUploadedReportImage(imgPath);
                        },
                      ),
                    )
                    .toList(),
              ),

            SizedBox(height: 10.h),

            // Upload area with BlocListener
            BlocListener<EyesDataEntryCubit, EyesDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.uploadReportStatus != curr.uploadReportStatus,
              listener: (context, state) async {
                if (state.uploadReportStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                } else if (state.uploadReportStatus ==
                    UploadReportRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                containerBorderColor: (state.uploadedReportImages.isEmpty)
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
                        await context
                            .read<EyesDataEntryCubit>()
                            .uploadReportImagePicked(
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
