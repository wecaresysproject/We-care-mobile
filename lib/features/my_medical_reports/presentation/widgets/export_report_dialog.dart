import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_elevated_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/logic/medical_report_export_logic.dart';

void showExportPdfDialog(
    BuildContext context, MedicalReportResponseModel? reportData) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ExportReportDialog(reportData: reportData);
    },
  );
}

class ExportReportDialog extends StatefulWidget {
  final MedicalReportResponseModel? reportData;

  const ExportReportDialog({super.key, required this.reportData});

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  final _nameController = TextEditingController();
  bool _attachToBackend = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اسم التقرير",
              style: AppTextStyles.font16BlackSemiBold.copyWith(
                color: AppColorsManager.mainDarkBlue,
              ),
            ),
            SizedBox(height: 12.h),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: "مثال: my_medical_report",
                hintStyle: AppTextStyles.font14blackWeight400.copyWith(
                  color: AppColorsManager.placeHolderColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24.w,
                  width: 24.w,
                  child: Checkbox(
                    value: _attachToBackend,
                    activeColor: AppColorsManager.mainDarkBlue,
                    onChanged: (value) {
                      setState(() {
                        _attachToBackend = value ?? false;
                      });
                    },
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "ارفاق التقرير الطبي للاستخدام فيما بعد داخل التطبيق",
                    style: AppTextStyles.font14BlackMedium.copyWith(
                      color: AppColorsManager.mainDarkBlue,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: CustomElevatedButton(
                    text: "اصدار التقرير",
                    onPressed: () {
                      String fileName = _nameController.text.trim();
                      if (fileName.isEmpty) {
                        fileName = "medical_report";
                      }

                      // Pop the dialog first
                      Navigator.of(context).pop();

                      // Call the export logic
                      MedicalReportExportLogic().exportAndShareReport(
                        context,
                        widget.reportData,
                        fileName,
                        _attachToBackend,
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
