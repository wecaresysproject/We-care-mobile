import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/image_preview_item_with_cancel.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/doctor/basic_data/logic/cubit/doctor_basic_data_cubit.dart';
import 'package:we_care/generated/l10n.dart';

class BasicDataProfilePhotoSection extends StatelessWidget {
  const BasicDataProfilePhotoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBasicDataCubit, DoctorBasicDataState>(
      buildWhen: (prev, curr) =>
          prev.profileImageUrl != curr.profileImageUrl ||
          prev.profileImageUploadStatus != curr.profileImageUploadStatus,
      builder: (context, state) {
        final cubit = context.read<DoctorBasicDataCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).basicDataFormPhotoLabel,
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            if (state.profileImageUrl.isNotEmptyOrNull) ...[
              ImageViewerWithCancel(
                imageUrl: state.profileImageUrl!,
                onRemove: cubit.removeProfileImage,
              ),
              verticalSpacing(10),
            ],
            BlocListener<DoctorBasicDataCubit, DoctorBasicDataState>(
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
