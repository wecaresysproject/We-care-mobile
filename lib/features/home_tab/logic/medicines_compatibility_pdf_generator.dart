import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/medication_compatibility/data/models/clinical_audit_report_model.dart';

class MedicinesCompatibilityPdfGenerator {
  late pw.Font _fontRegular;
  late pw.Font _fontBold;

  Future<Uint8List> generateCompatibilityReport(
      ClinicalAuditReport auditReport) async {
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
          ..._buildChemicalSection(auditReport.chemicalInteractionMatrix),
          ..._buildSystemicSection(auditReport.systemicCompatibility),
          ..._buildRiskGuideSection(auditReport.doctorDiscussion.riskTable),
          ..._buildQuestionsSection(auditReport.doctorDiscussion.questions),
        ],
      ),
    );

    return pdf.save();
  }

  String _clean(String? text) {
    if (text == null) return "";
    return text.replaceAll(RegExp(r'[^\x00-\x7F\u0600-\u06FF\s،؟!]'), '');
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
              pw.Text(DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                  style: _style(fontSize: 10, color: PdfColors.grey700)),
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
        'نتائج تحليل توافق أدويتى',
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

  List<pw.Widget> _buildChemicalSection(ChemicalInteractionMatrix matrix) {
    if (matrix.antagonism.isEmpty &&
        matrix.synergy.isEmpty &&
        matrix.pastDrugResiduals.isEmpty) return [];

    final widgets = <pw.Widget>[];
    widgets.add(_buildSectionHeader("تداخلات المواد الكيميائية (Matrix)"));

    if (matrix.antagonism.isNotEmpty) {
      widgets.add(_buildSubSectionHeader("التضاد (Antagonism)"));
      widgets.addAll(matrix.antagonism.map((e) => _buildInteractionCard(e.title,
          e.description, e.riskLevel, e.action, e.drugsInvolved, true)));
    }

    if (matrix.synergy.isNotEmpty) {
      widgets.add(_buildSubSectionHeader("التآزر (Synergy)"));
      widgets.addAll(matrix.synergy.map((e) => _buildInteractionCard(e.title,
          e.description, e.riskLevel, e.action, e.drugsInvolved, true)));
    }

    if (matrix.pastDrugResiduals.isNotEmpty) {
      widgets
          .add(_buildSubSectionHeader("تأثيرات الأدوية السابقة (Residuals)"));
      widgets.addAll(matrix.pastDrugResiduals.map((e) => _buildInteractionCard(
          e.title,
          e.description,
          e.riskLevel,
          e.action,
          e.drugsInvolved,
          true)));
    }

    widgets.add(pw.SizedBox(height: 10));
    return widgets;
  }

  List<pw.Widget> _buildSystemicSection(SystemicCompatibility systemic) {
    if (systemic.foodAndSupplements.isEmpty &&
        systemic.organSafety.isEmpty &&
        systemic.behavioralImpact.isEmpty) return [];

    final widgets = <pw.Widget>[];
    widgets.add(_buildSectionHeader("التوافق مع أجهزة الجسم (Systemic)"));

    if (systemic.foodAndSupplements.isNotEmpty) {
      widgets.add(_buildSubSectionHeader("الغذاء والمكملات"));
      widgets.addAll(systemic.foodAndSupplements.map((e) =>
          _buildInteractionCard(e.title, e.description, e.riskLevel, e.action,
              e.relatedItems, false)));
    }

    if (systemic.organSafety.isNotEmpty) {
      widgets.add(_buildSubSectionHeader("أمان الأعضاء"));
      widgets.addAll(systemic.organSafety.map((e) => _buildInteractionCard(
          e.title,
          e.description,
          e.riskLevel,
          e.action,
          e.relatedItems,
          false)));
    }

    if (systemic.behavioralImpact.isNotEmpty) {
      widgets.add(_buildSubSectionHeader("تأثيرات سلوكية"));
      widgets.addAll(systemic.behavioralImpact.map((e) => _buildInteractionCard(
          e.title,
          e.description,
          e.riskLevel,
          e.action,
          e.relatedItems,
          false)));
    }

    widgets.add(pw.SizedBox(height: 10));
    return widgets;
  }

  pw.Widget _buildInteractionCard(
      String title,
      String description,
      String riskLevel,
      String action,
      List<String> extraInfo,
      bool isChemical) {
    final color = _getRiskPdfColor(riskLevel);

    final cleanTitle = _clean(title);
    final cleanDescription = _clean(description);
    final cleanAction = _clean(action);
    final cleanExtra = extraInfo.map((e) => _clean(e)).toList();

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 12),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        border: pw.Border.all(color: PdfColors.grey200, width: 0.5),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment
            .start, // Avoid stretch to prevent infinite height
        children: [
          // Sidebar - we use a fixed height container or stack to simulate intrinsic height
          // Since IntrinsicHeight is risky, we use a simple leading border on a Container
          pw.Container(
            width: 5,
            height:
                50, // This is just a placeholder, we'll actually use a better approach
            decoration: pw.BoxDecoration(
              color: color,
              borderRadius: const pw.BorderRadius.only(
                topRight: pw.Radius.circular(6),
                bottomRight: pw.Radius.circular(6),
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
                        child: pw.Text(cleanTitle,
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
                          child: pw.Text(_clean(riskLevel),
                              style: _style(
                                  bold: true,
                                  fontSize: 10,
                                  color: PdfColors.white)),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Text(cleanDescription, style: _style(fontSize: 11)),
                  if (cleanExtra.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Text(
                      isChemical
                          ? "الأدوية المعنية: ${cleanExtra.join(', ')}"
                          : "المحاور المرتبطة: ${cleanExtra.join(', ')}",
                      style: _style(
                          bold: true,
                          fontSize: 10,
                          color: PdfColor.fromInt(
                              AppColorsManager.mainDarkBlue.toARGB32())),
                    ),
                  ],
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
                    child: pw.Text("الإجراء: $cleanAction",
                        style: _style(fontSize: 10)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _buildRiskGuideSection(List<RiskLevelItem> table) {
    if (table.isEmpty) return [];

    final widgets = <pw.Widget>[];
    widgets.add(_buildSectionHeader("دليل استشارة الطبيب"));

    widgets.add(
      pw.Container(
        padding: const pw.EdgeInsets.all(12),
        decoration: pw.BoxDecoration(
          color: PdfColors.grey50,
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          children: table
              .map((item) => pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 6),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 24,
                          height: 24,
                          decoration: pw.BoxDecoration(
                            color: _getRiskPdfColor(item.level),
                            borderRadius: pw.BorderRadius.circular(6),
                          ),
                          alignment: pw.Alignment.center,
                          child: pw.Text(_clean(item.level),
                              style: _style(
                                  bold: true,
                                  fontSize: 10,
                                  color: PdfColors.white)),
                        ),
                        pw.SizedBox(width: 12),
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(_clean(item.meaning),
                                  style: _style(bold: true, fontSize: 11)),
                              pw.Text("الإجراء المطلوب: ${_clean(item.action)}",
                                  style: _style(
                                      fontSize: 10, color: PdfColors.grey800)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );

    widgets.add(pw.SizedBox(height: 15));
    return widgets;
  }

  List<pw.Widget> _buildQuestionsSection(List<String> questions) {
    if (questions.isEmpty) return [];

    final widgets = <pw.Widget>[];
    widgets.add(_buildSectionHeader("أسئلة لنقاشها مع طبيبك"));

    widgets.add(
      pw.Container(
        padding: const pw.EdgeInsets.all(15),
        decoration: pw.BoxDecoration(
          color: PdfColor.fromInt(0xFFFFF2E6),
          borderRadius: pw.BorderRadius.circular(10),
          border: pw.Border.all(color: PdfColors.orange200, width: 0.5),
        ),
        child: pw.Column(
          children: questions
              .map((q) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 10),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("•",
                            style: _style(
                                bold: true,
                                fontSize: 16,
                                color: PdfColors.orange700)),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                            child: pw.Text(_clean(q),
                                style: _style(
                                    fontSize: 11, color: PdfColors.grey900))),
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    );

    return widgets;
  }

  pw.Widget _buildSectionHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 12),
      child: pw.Text(
        _clean(title),
        style: _style(
          bold: true,
          fontSize: 18,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
        ),
      ),
    );
  }

  pw.Widget _buildSubSectionHeader(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(top: 15, bottom: 8),
      child: pw.Text(
        _clean(title),
        style: _style(
          bold: true,
          fontSize: 14,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
        ),
      ),
    );
  }

  PdfColor _getRiskPdfColor(String level) {
    switch (level.toUpperCase().trim()) {
      case 'L1':
        return PdfColor.fromInt(AppColorsManager.criticalRisk.toARGB32());
      case 'L2':
        return PdfColor.fromInt(AppColorsManager.elevatedRisk.toARGB32());
      case 'L3':
        return PdfColor.fromInt(AppColorsManager.warning.toARGB32());
      case 'L4':
        return PdfColors.blue700;
      case 'L5':
        return PdfColors.grey700;
      default:
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

String normalizeArabicText(String input) {
  if (input.isEmpty) return input;

  return input
      // ياء لينة → ياء
      .replaceAll('\u0649', '\u064A')

      // optional fixes (مهمة جدًا أحيانًا 👇)
      .replaceAll('\u0629', '\u0647') // ة → ه (لو عندك مشاكل فيها)
      .replaceAll('\u0640', '') // تطويل ـ
      .replaceAll(RegExp(r'[\u064B-\u0652]'), ''); // تشكيل
}
