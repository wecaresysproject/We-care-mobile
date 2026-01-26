import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';

import 'medical_report_pdf_generator.dart';

class MedicalReportExportLogic {
  Future<void> exportAndShareReport(
      BuildContext context, MedicalReportResponseModel? reportData) async {
    try {
      // Generate PDF using the new generator
      final pdfBytes =
          await MedicalReportPdfGenerator().generateMedicalReport(reportData!);

      // Save PDF to temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/medical_report.pdf');
      await file.writeAsBytes(pdfBytes);

      // Share PDF
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Medical Report',
        subject: 'My Medical Report',
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting report: $e')),
        );
      }
    }
  }
}
