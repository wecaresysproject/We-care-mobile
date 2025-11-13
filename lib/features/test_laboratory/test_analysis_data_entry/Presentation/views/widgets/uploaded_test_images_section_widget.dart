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
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/logic/cubit/test_analysis_data_entry_cubit.dart';

class UploadedTestImagesSection extends StatelessWidget {
  const UploadedTestImagesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestAnalysisDataEntryCubit, TestAnalysisDataEntryState>(
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
                        onRemove: () => context
                            .read<TestAnalysisDataEntryCubit>()
                            .removeUploadedImage(imgPath),
                        imageUrl: imgPath,
                      ),
                    )
                    .toList(),
              ),

            SizedBox(height: 10.h),

            // Add new
            BlocListener<TestAnalysisDataEntryCubit,
                TestAnalysisDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.testImageRequestStatus != curr.testImageRequestStatus,
              listener: (context, state) {
                if (state.testImageRequestStatus ==
                    UploadImageRequestStatus.success) {
                  showSuccess(state.message);
                }
                if (state.testImageRequestStatus ==
                    UploadImageRequestStatus.failure) {
                  showError(state.message);
                }
              },
              child: SelectImageContainer(
                containerBorderColor: (state.uploadedTestImages.isEmpty)
                    ? AppColorsManager.warningColor
                    : AppColorsManager.textfieldOutsideBorderColor,
                imagePath: "assets/images/photo_icon.png",
                label: "إضافة صورة",
                onTap: () async {
                  if (state.uploadedTestImages.length >= 8) {
                    return showError("لا يمكنك رفع أكثر من 8 صور");
                  }

                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();

                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<TestAnalysisDataEntryCubit>()
                            .uploadLaboratoryTestImagePicked(
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
