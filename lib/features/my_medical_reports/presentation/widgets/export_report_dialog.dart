import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/SharedWidgets/custom_elevated_button.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/Presentation/views/ai_consultation_screen.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String get _resolvedFileName {
    final name = _nameController.text.trim();
    return name.isEmpty ? "medical_report" : name;
  }

  Future<void> _onExport() async {
    Navigator.of(context).pop();
    MedicalReportExportLogic().exportAndShareReport(
      context,
      widget.reportData,
      _resolvedFileName,
      _attachToBackend,
    );
  }

  Future<void> _onConsultAI(BuildContext dialogContext) async {
    setState(() => _isLoading = true);

    final fileName = _resolvedFileName;

    // Generate the PDF file first
    final pdfFile = await MedicalReportExportLogic().generatePdfFile(
      dialogContext,
      widget.reportData,
      fileName,
    );

    if (!dialogContext.mounted) return;
    Navigator.of(dialogContext).pop();

    if (pdfFile != null) {
      Navigator.of(dialogContext).push(
        MaterialPageRoute(
          builder: (_) => AIConsultationScreen(
            preAttachedReport: pdfFile,
            preAttachedFileName: '$fileName.pdf',
          ),
        ),
      );
    }
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
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Row(
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      text: "اصدار التقرير",
                      onPressed: _onExport,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomElevatedButton(
                      text: "استشارة ال Ai",
                      onPressed: () => _onConsultAI(context),
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
