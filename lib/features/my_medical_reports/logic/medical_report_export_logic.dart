import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';
import 'package:we_care/features/my_medical_reports/data/repos/medical_report_repo.dart';

import 'medical_report_pdf_generator.dart';

class MedicalReportExportLogic {
  final MedicalReportRepo _repo;

  MedicalReportExportLogic(this._repo);

  Future<void> exportAndShareReport(
      BuildContext context,
      MedicalReportResponseModel? reportData,
      String fileName,
      bool attachToBackend) async {
    try {
      // Generate PDF using the new generator
      final pdfBytes =
          await MedicalReportPdfGenerator().generateMedicalReport(reportData!);

      // Save PDF to temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);

      // Upload to backend if requested
      if (attachToBackend) {
        final generatedAt = DateTime.now().toUtc().toIso8601String();
        final result = await _repo.uploadReport(file, fileName, generatedAt);

        result.when(
          success: (response) {
            AppLogger.info("PDF uploaded successfully: ${response.url ?? ''}");
            showSuccess("تم رفع التقرير بنجاح");
          },
          failure: (error) {
            AppLogger.error("PDF upload failed: ${error.errors.join(', ')}");
            showError(error.errors.isNotEmpty
                ? error.errors.first
                : "حدث خطأ أثناء رفع التقرير");
          },
        );
      }

      // Share PDF
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Medical Report',
        subject: 'My Medical Report',
      );
    } catch (e, s) {
      if (context.mounted) {
        showError("حدث خطأ أثناء تصدير التقرير");
      }
      AppLogger.error("PDF ERROR: $e");
      AppLogger.error("STACK: $s");
    }
  }

  /// Generates the PDF as a [File] without sharing. Used for AI consultation handoff.
  Future<File?> generatePdfFile(BuildContext context,
      MedicalReportResponseModel? reportData, String fileName) async {
    try {
      final pdfBytes =
          await MedicalReportPdfGenerator().generateMedicalReport(reportData!);
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/$fileName.pdf');
      await file.writeAsBytes(pdfBytes);
      return file;
    } catch (e, s) {
      if (context.mounted) {
        showError("حدث خطأ أثناء إنشاء التقرير");
      }
      AppLogger.error("PDF ERROR: $e");
      AppLogger.error("STACK: $s");
      return null;
    }
  }
}
