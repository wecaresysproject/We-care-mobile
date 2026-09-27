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

class BasicDataNationalIdPhotoSection extends StatelessWidget {
  const BasicDataNationalIdPhotoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorBasicDataCubit, DoctorBasicDataState>(
      buildWhen: (prev, curr) =>
          prev.nationalIdImageUrl != curr.nationalIdImageUrl ||
          prev.nationalIdImageUploadStatus != curr.nationalIdImageUploadStatus,
      builder: (context, state) {
        final cubit = context.read<DoctorBasicDataCubit>();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              S.of(context).basicDataFormNationalIdPhotoLabel,
              style: AppTextStyles.font18blackWight500,
            ),
            verticalSpacing(10),
            if (state.nationalIdImageUrl.isNotEmptyOrNull) ...[
              ImageViewerWithCancel(
                imageUrl: state.nationalIdImageUrl!,
                onRemove: cubit.removeNationalIdImage,
              ),
              verticalSpacing(10),
            ],
            BlocListener<DoctorBasicDataCubit, DoctorBasicDataState>(
              listenWhen: (prev, curr) =>
                  prev.nationalIdImageUploadStatus !=
                  curr.nationalIdImageUploadStatus,
              listener: (context, state) async {
                if (state.nationalIdImageUploadStatus ==
                    UploadImageRequestStatus.success) {
                  await showSuccess(state.message!);
                } else if (state.nationalIdImageUploadStatus ==
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
                        await cubit.uploadNationalIdImage(
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
