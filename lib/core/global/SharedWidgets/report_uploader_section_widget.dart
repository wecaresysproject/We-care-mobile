import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/image_preview_item_with_cancel.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';

class ReportUploaderSection<CubitType extends StateStreamable<StateType>,
    StateType> extends StatelessWidget {
  final UploadReportRequestStatus Function(StateType) statusSelector;
  final Future<void> Function(String imagePath) onUpload;

  final List<String> Function(StateType) uploadedSelector;
  final void Function(String imagePath) onRemove;

  final int maxImages;
  final String resultMessage;

  const ReportUploaderSection({
    super.key,
    required this.statusSelector,
    required this.onUpload,
    required this.uploadedSelector,
    required this.onRemove,
    required this.resultMessage,
    this.maxImages = 8,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitType, StateType>(
      builder: (context, state) {
        final uploaded = uploadedSelector(state);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// الصور المرفوعة
            if (uploaded.isNotEmpty)
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: uploaded
                    .map(
                      (imgPath) => ImageViewerWithCancel(
                        imageUrl: imgPath,
                        onRemove: () => onRemove(imgPath),
                      ),
                    )
                    .toList(),
              ),
            if (uploaded.isNotEmpty) const SizedBox(height: 16),

            /// Listener للرفع
            BlocListener<CubitType, StateType>(
              listenWhen: (previous, current) =>
                  statusSelector(previous) != statusSelector(current),
              listener: (context, state) async {
                final status = statusSelector(state);

                if (status == UploadReportRequestStatus.success) {
                  await showSuccess(
                    resultMessage,
                  );
                }

                if (status == UploadReportRequestStatus.failure) {
                  await showError(
                    resultMessage,
                  );
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة",
                onTap: uploaded.length >= maxImages
                    ? () => showError("لا يمكنك رفع أكثر من $maxImages صور")
                    : () async {
                        await showImagePicker(
                          context,
                          onImagePicked: (isPicked) async {
                            final picker = getIt.get<ImagePickerService>();

                            if (isPicked && picker.isImagePickedAccepted) {
                              await onUpload(picker.pickedImage!.path);
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
