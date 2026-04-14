import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medicine/data/models/medical_compatibility_analysis_model.dart';

class MedicationCompatibilityAnalysisPdfGenerator {
  late pw.Font _fontRegular;
  late pw.Font _fontBold;

  Future<Uint8List> generateCompatibilityReport(
      CompatibilityAnalysisModel analysis) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegularData =
        await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final fontBoldData = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");
    _fontRegular = pw.Font.ttf(fontRegularData);
    _fontBold = pw.Font.ttf(fontBoldData);

    final logoImageProvider =
        await _loadAssetImage('assets/images/we_care_logo.png');

    final theme = pw.ThemeData.withFont(
      base: _fontRegular,
      bold: _fontBold,
    );

    pdf.addPage(
      pw.MultiPage(
        maxPages: 100,
        header: (context) => _buildHeader(logoImageProvider),
        footer: (context) => _buildFooter(context),
        pageTheme: pw.PageTheme(
          theme: theme,
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(30),
          textDirection: pw.TextDirection.rtl,
        ),
        build: (context) => [
          _buildTitle(),
          _buildRiskLegend(),
          pw.SizedBox(height: 15),
          _buildSummarySection(analysis.analysisSummary),
          pw.SizedBox(height: 20),
          if (analysis.issues.isEmpty)
            _buildNoIssuesSection()
          else
            ..._buildIssuesSection(analysis.issues),
        ],
      ),
    );

    return pdf.save();
  }

  String _clean(String? text) {
    if (text == null) return "";
    final sanitized =
        text.replaceAll(RegExp(r'[^\x00-\x7F\u0600-\u06FF\s،؟!]'), '');
    return _normalizeForPdf(sanitized);
  }

  String _normalizeForPdf(String input) {
    if (input.isEmpty) return input;
    return input
        .replaceAllMapped(
          RegExp(r'\u064A(?=\s|\b|$)'),
          (match) => '\u0649',
        )
        .replaceAll('\u0640', '')
        .replaceAll(RegExp(r'[\u064B-\u0652]'), '');
  }

  pw.TextStyle _style({
    bool bold = false,
    double fontSize = 12,
    PdfColor color = PdfColors.black,
  }) {
    return pw.TextStyle(
      font: bold ? _fontBold : _fontRegular,
      fontFallback: [_fontRegular],
      fontSize: fontSize,
      color: color,
    );
  }

  pw.Widget _buildHeader(pw.MemoryImage? logo) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 25),
      padding: const pw.EdgeInsets.only(bottom: 10),
      decoration: const pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('تطبيق وى كير', style: _style(bold: true, fontSize: 16)),
              pw.Text('تقرير التوافق الدوائي', style: _style(fontSize: 12)),
              pw.Text(
                DateFormat('dd/MM/yyyy HH:mm').format(
                  DateTime.now(),
                ),
                style: _style(
                  fontSize: 10,
                  color: PdfColors.grey700,
                ),
              ),
            ],
          ),
          if (logo != null) pw.Image(logo, width: 60, height: 60),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.center,
      margin: const pw.EdgeInsets.only(top: 25),
      padding: const pw.EdgeInsets.only(top: 10),
      decoration: const pw.BoxDecoration(
        border:
            pw.Border(top: pw.BorderSide(color: PdfColors.grey300, width: 0.5)),
      ),
      child: pw.Text(
        'صفحة ${context.pageNumber} من ${context.pagesCount}',
        style: _style(fontSize: 10, color: PdfColors.grey700),
      ),
    );
  }

  pw.Widget _buildTitle() {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 25),
      alignment: pw.Alignment.center,
      child: pw.Text(
        'نتائج تحليل التوافق الدوائي',
        style: _style(
          bold: true,
          fontSize: 24,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
        ),
      ),
    );
  }

  pw.Widget _buildRiskLegend() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
        children: [
          _buildRiskLegendItem("L1", "حرج", _getRiskPdfColor("L1")),
          _buildRiskLegendItem("L2", "مرتفع", _getRiskPdfColor("L2")),
          _buildRiskLegendItem("L3", "متوسط", _getRiskPdfColor("L3")),
          _buildRiskLegendItem("L4", "منخفض", _getRiskPdfColor("L4")),
          _buildRiskLegendItem("L5", "احترازي", _getRiskPdfColor("L5")),
        ],
      ),
    );
  }

  pw.Widget _buildRiskLegendItem(String level, String label, PdfColor color) {
    return pw.Row(
      children: [
        pw.Container(
          width: 8,
          height: 8,
          decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
        ),
        pw.SizedBox(width: 5),
        pw.Text('$level: $label', style: _style(fontSize: 10)),
      ],
    );
  }

  pw.Widget _buildSummarySection(String summary) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(10),
        border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('ملخص التحليل',
              style: _style(
                  bold: true,
                  fontSize: 16,
                  color: PdfColor.fromInt(
                      AppColorsManager.mainDarkBlue.toARGB32()))),
          pw.SizedBox(height: 10),
          pw.Text(_clean(summary), style: _style(fontSize: 12)),
        ],
      ),
    );
  }

  pw.Widget _buildNoIssuesSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(20),
      alignment: pw.Alignment.center,
      decoration: pw.BoxDecoration(
        color: PdfColor.fromInt(0xFFE8F5E9), // Green 50
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Text(
        'لا يوجد تعارض دوائي خطير بناءً على البيانات المتاحة.',
        style: _style(
          bold: true,
          fontSize: 14,
          color: PdfColor.fromInt(0xFF2E7D32), // Green 800
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  List<pw.Widget> _buildIssuesSection(List<CompatibilityIssue> issues) {
    return [
      pw.Text(
        'التداخلات المرصودة',
        style: _style(
          bold: true,
          fontSize: 18,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
        ),
      ),
      pw.SizedBox(height: 12),
      ...issues.map((issue) => _buildIssueCard(issue)),
    ];
  }

  pw.Widget _buildIssueCard(CompatibilityIssue issue) {
    final color = _getRiskPdfColor(issue.riskLevel);

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Inseparable(
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: 5,
              height: 50, // Minimum height for the sidebar
              decoration: pw.BoxDecoration(
                color: color,
                borderRadius: const pw.BorderRadius.only(
                  topRight: pw.Radius.circular(8),
                  bottomRight: pw.Radius.circular(8),
                ),
              ),
            ),
            pw.Expanded(
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(12),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          child: pw.Text(_clean(issue.title),
                              style: _style(bold: true, fontSize: 13)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.only(right: 8),
                          child: pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: pw.BoxDecoration(
                                color: color,
                                borderRadius: pw.BorderRadius.circular(4)),
                            child: pw.Text(_clean(issue.riskLevel),
                                style: _style(
                                    bold: true,
                                    fontSize: 10,
                                    color: PdfColors.white)),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(_clean('السبب العلمي: ${issue.scientificReason}'),
                        style: _style(fontSize: 11)),
                    pw.SizedBox(height: 10),
                    pw.Container(
                      padding: const pw.EdgeInsets.all(8),
                      width: double.infinity,
                      decoration: pw.BoxDecoration(
                        color: PdfColors.grey50,
                        borderRadius: pw.BorderRadius.circular(4),
                        border:
                            pw.Border.all(color: PdfColors.grey300, width: 0.5),
                      ),
                      child: pw.Text(
                          _clean('سؤال للطبيب: ${issue.doctorQuestion}'),
                          style: _style(fontSize: 10)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PdfColor _getRiskPdfColor(String level) {
    switch (level.toUpperCase().trim()) {
      case 'L1':
      case 'HIGH':
      case 'CRITICAL':
        return PdfColor.fromInt(AppColorsManager.criticalRisk.toARGB32());
      case 'L2':
      case 'MEDIUM':
        return PdfColor.fromInt(AppColorsManager.elevatedRisk.toARGB32());
      case 'L3':
      case 'LOW':
        return PdfColor.fromInt(AppColorsManager.warning.toARGB32());
      case 'L4':
        return PdfColors.blue700;
      case 'L5':
        return PdfColors.grey700;
      default:
        // Try to match common Arabic risk level names or just default to something
        if (level.contains('عالي') || level.contains('خطر')) {
          return PdfColor.fromInt(AppColorsManager.criticalRisk.toARGB32());
        }
        return PdfColors.black;
    }
  }

  Future<pw.MemoryImage?> _loadAssetImage(String path) async {
    try {
      final data = await rootBundle.load(path);
      return pw.MemoryImage(data.buffer.asUint8List());
    } catch (e) {
      return null;
    }
  }
}
