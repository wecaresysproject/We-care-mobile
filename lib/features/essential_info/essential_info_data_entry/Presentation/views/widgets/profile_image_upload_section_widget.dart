import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/image_preview_item_with_cancel.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/essential_info/essential_info_data_entry/logic/cubit/essential_data_entry_cubit.dart';

class ProfileImageUploadSection extends StatelessWidget {
  const ProfileImageUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EssentialDataEntryCubit, EssentialDataEntryState>(
      buildWhen: (prev, curr) =>
          prev.userPersonalImage != curr.userPersonalImage ||
          prev.profileImageUploadStatus != curr.profileImageUploadStatus,
      builder: (context, state) {
        final cubit = context.read<EssentialDataEntryCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "الصورة الشخصية (4x6)",
              style: AppTextStyles.font18blackWight500,
            ),
            SizedBox(height: 8.h),
            if (state.userPersonalImage.isNotEmptyOrNull)
              ImageViewerWithCancel(
                imageUrl: state.userPersonalImage!,
                onRemove: () => cubit.onRemoveProfileImage(),
              ),
            SizedBox(height: 10.h),
            BlocListener<EssentialDataEntryCubit, EssentialDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.profileImageUploadStatus !=
                  curr.profileImageUploadStatus,
              listener: (context, state) async {
                if (state.profileImageUploadStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message!);
                } else if (state.profileImageUploadStatus ==
                    UploadImageRequestStatus.failure) {
                  await showError(state.message!);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isPicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isPicked && picker.isImagePickedAccepted) {
                        await cubit.uploadProfileImage(
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
