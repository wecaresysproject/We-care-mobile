import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/select_image_container_shared_widget.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/x_ray/x_ray_data_entry/logic/cubit/x_ray_data_entry_cubit.dart';

class XRayReportSection extends StatelessWidget {
  const XRayReportSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<XRayDataEntryCubit, XRayDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "التقارير الطبية (${state.uploadedTestReports.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),

            // preview
            if (state.uploadedTestReports.isNotEmpty)
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: state.uploadedTestReports
                    .map((imgPath) => _reportItem(context, imgPath))
                    .toList(),
              ),

            verticalSpacing(10),
            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: context
                      .read<XRayDataEntryCubit>()
                      .reportTextController
                      .text
                      .isEmpty
                  ? "اكتب التقرير"
                  : "تعديل التقرير",
              onTap: () async {
                // ✅ اقرا الـ cubit من الـ context الحالي
                final cubit = context.read<XRayDataEntryCubit>();
                final isFirstTime =
                    cubit.reportTextController.text.isEmpty == true;
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WriteReportScreenSharedWidget(
                      reportController: cubit.reportTextController,
                      screenTitle:
                          isFirstTime ? "اكتب التقرير" : "تعديل التقرير",
                      saveButtonText:
                          isFirstTime ? "حفظ التقرير" : "حفظ التعديلات",
                    ),
                  ),
                );
              },
            ),
            verticalSpacing(8),
            BlocListener<XRayDataEntryCubit, XRayDataEntryState>(
              listenWhen: (previous, current) =>
                  previous.xRayReportRequestStatus !=
                  current.xRayReportRequestStatus,
              listener: (context, state) async {
                if (state.xRayReportRequestStatus ==
                    UploadReportRequestStatus.success) {
                  await showSuccess(state.message);
                }
                if (state.xRayReportRequestStatus ==
                    UploadReportRequestStatus.failure) {
                  await showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة للتقرير",
                onTap: () async {
                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();
                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<XRayDataEntryCubit>()
                            .uploadXrayReportPicked(
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

Widget _reportItem(BuildContext context, String path) {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: path,
          width: 80.w,
          height: 80.w,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        right: -6,
        top: -6,
        child: IconButton(
          icon: const Icon(Icons.close, size: 28, color: Colors.red),
          onPressed: () {
            context.read<XRayDataEntryCubit>().removeUploadedTestReport(path);
          },
        ),
      ),
    ],
  );
}
