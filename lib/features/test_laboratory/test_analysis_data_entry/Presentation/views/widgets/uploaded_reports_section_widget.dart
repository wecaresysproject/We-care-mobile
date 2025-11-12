import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/image_quality_detector.dart';
import 'package:we_care/core/global/SharedWidgets/show_image_picker_selection_widget.dart';
import 'package:we_care/core/global/SharedWidgets/write_report_screen.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/Presentation/views/widgets/select_image_container_widget.dart';
import 'package:we_care/features/test_laboratory/test_analysis_data_entry/logic/cubit/test_analysis_data_entry_cubit.dart';

class UploadedReportsSection extends StatelessWidget {
  const UploadedReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TestAnalysisDataEntryCubit, TestAnalysisDataEntryState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "التقارير الطبية (${state.uploadedTestReports.length}/8)",
              style: AppTextStyles.font18blackWight500,
            ),

            SizedBox(height: 8.h),

            // preview
            if (state.uploadedTestReports.isNotEmpty)
              Wrap(
                runSpacing: 8,
                spacing: 8,
                children: state.uploadedTestReports
                    .map((imgPath) => _reportItem(context, imgPath))
                    .toList(),
              ),

            SizedBox(height: 10.h),

            SelectImageContainer(
              imagePath: "assets/images/t_shape_icon.png",
              label: context
                      .read<TestAnalysisDataEntryCubit>()
                      .reportTextController
                      .text
                      .isEmpty
                  ? "اكتب التقرير"
                  : "تعديل التقرير",
              onTap: () async {
                // ✅ اقرا الـ cubit من الـ context الحالي
                final cubit = context.read<TestAnalysisDataEntryCubit>();
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

            SizedBox(height: 8.h),

            // Add report image
            BlocListener<TestAnalysisDataEntryCubit,
                TestAnalysisDataEntryState>(
              listenWhen: (prev, curr) =>
                  prev.testReportRequestStatus != curr.testReportRequestStatus,
              listener: (context, state) {
                if (state.testReportRequestStatus ==
                    UploadReportRequestStatus.success) {
                  showSuccess(state.message);
                }
                if (state.testReportRequestStatus ==
                    UploadReportRequestStatus.failure) {
                  showError(state.message);
                }
              },
              child: SelectImageContainer(
                imagePath: "assets/images/photo_icon.png",
                label: "ارفق صورة للتقرير",
                onTap: () async {
                  if (state.uploadedTestReports.length >= 8) {
                    return showError("لا يمكنك رفع أكثر من 8 تقارير");
                  }

                  await showImagePicker(
                    context,
                    onImagePicked: (isImagePicked) async {
                      final picker = getIt.get<ImagePickerService>();

                      if (isImagePicked && picker.isImagePickedAccepted) {
                        await context
                            .read<TestAnalysisDataEntryCubit>()
                            .uploadLaboratoryTestReportPicked(
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
              context
                  .read<TestAnalysisDataEntryCubit>()
                  .removeUploadedTestReport(path);
            },
          ),
        ),
      ],
    );
  }
}
