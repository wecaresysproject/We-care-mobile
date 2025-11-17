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
import 'package:we_care/features/eyes/eyes_data_entry_view/logic/cubit/eyes_data_entry_cubit.dart';

class MedicalExaminationUploadSection extends StatelessWidget {
  const MedicalExaminationUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EyesDataEntryCubit, EyesDataEntryState>(
      buildWhen: (previous, current) =>
          previous.medicalExaminationImages != current.medicalExaminationImages,
      builder: (context, state) {
        final uploadedCount = state.medicalExaminationImages.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان مع العدد
            Text(
              "صورة الفحوصات الطبية ($uploadedCount/8)",
              style: AppTextStyles.font18blackWight500,
            ),
            SizedBox(height: 10.h),
            // Preview images
            if (state.medicalExaminationImages.isNotEmpty)
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: state.medicalExaminationImages
                    .map(
                      (imgPath) => ImageViewerWithCancel(
                        imageUrl: imgPath,
                        onRemove: () {
                          context
                              .read<EyesDataEntryCubit>()
                              .removeUploadedExaminationImage(imgPath);
                        },
                      ),
                    )
                    .toList(),
              ),

            SizedBox(height: 10.h),

            // BlocListener للرفع
            BlocListener<EyesDataEntryCubit, EyesDataEntryState>(
              listenWhen: (previous, current) =>
                  previous.uploadMedicalExaminationStatus !=
                  current.uploadMedicalExaminationStatus,
              listener: (context, state) async {
                if (state.uploadMedicalExaminationStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message);
                } else if (state.uploadMedicalExaminationStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
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
                            .uploadMedicalExaminationImage(
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
