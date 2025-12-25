import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../presentation/widgets/medical_report_widget.dart';

class MedicalReportExportLogic {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> exportAndShareReport(BuildContext context) async {
    try {
      // 1. Capture the widget as an image using captureFromWidget
      // We pass the MedicalReportWidget directly and specify a landscape target size.
      // 1200 width is consistent with the widget's fixed width.
      final Uint8List imageBytes = await screenshotController.captureFromWidget(
        const MedicalReportWidget(),
        delay: const Duration(milliseconds: 100),
        pixelRatio: 3.0,
        context: context, // Optional, but good for inheriting theme/media query if needed
        targetSize: const Size(1600, 1600), // Height will adjust based on content, but we set a wide width constraint
        // Actually, for captureFromWidget, if the widget has a fixed width (which we set to 1200), 
        // it will respect that. We just need to ensure the capture context allows it.
      );

      // 2. Create PDF
      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4.landscape,
          margin: const pw.EdgeInsets.all(20),
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image, fit: pw.BoxFit.contain),
            );
          },
        ),
      );

      // 3. Save PDF to temporary file
      final output = await getTemporaryDirectory();
      final file = File('${output.path}/medical_report.pdf');
      await file.writeAsBytes(await pdf.save());

      // 4. Share PDF
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
