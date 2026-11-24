import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/logic/cubit/doctor_prescription_cubit.dart';

/// What goes on the prescription paper.
class PrescriptionDocumentData {
  const PrescriptionDocumentData({
    required this.prescription,
    required this.date,
    this.patientName,
    this.doctorName,
    this.doctorSpecialty,
    this.editedAt,
  });

  final DoctorPrescriptionState prescription;

  /// The booking date.
  final DateTime date;
  final String? patientName;
  final String? doctorName;
  final String? doctorSpecialty;

  /// Shown as "آخر تعديل" when the prescription was edited after saving.
  final DateTime? editedAt;
}

/// One table cell: [flex] share of the row width, [isStart] aligns the text
/// to the start instead of the center (for long text).
class _Cell {
  const _Cell(this.text, {required this.flex, this.isStart = false})
      : detail = null,
        isBold = false;

  const _Cell.withDetail(
    this.text, {
    required this.detail,
    required this.flex,
  })  : isStart = true,
        isBold = true;

  final String text;
  final String? detail;
  final int flex;
  final bool isStart;
  final bool isBold;
}

/// Lays the prescription out as paper pages, in the same style as the
/// medical report PDF. Each page becomes one image attached to the
/// patient's prescription ticket, so nothing scrolls: text wraps inside
/// the page width, and long prescriptions continue on the next page row
/// by row.
class DoctorPrescriptionDocumentBuilder {
  const DoctorPrescriptionDocumentBuilder();

  /// About the shape of the image box in the medical report PDF
  /// (half an A3 page wide, 380pt high), so the image isn't shrunk much.
  static const pageFormat = PdfPageFormat(400, 394);

  static const double _sidePadding = 16;

  static final _darkBlue =
      PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32());
  static final _babyBlue =
      PdfColor.fromInt(AppColorsManager.babyBlueColor.toARGB32());
  static const _border = PdfColors.grey300;
  static const _headerBackground = PdfColors.grey100;
  static const _detailColor = PdfColors.grey700;

  static pw.ThemeData? _theme;
  static pw.MemoryImage? _logo;

  /// One PNG per page.
  Future<List<Uint8List>> buildPageImages(
    PrescriptionDocumentData data, {
    double dpi = 220,
  }) async {
    final pdfBytes = await buildPdf(data);
    final images = <Uint8List>[];
    await for (final page in Printing.raster(pdfBytes, dpi: dpi)) {
      images.add(await page.toPng());
    }
    return images;
  }

  Future<Uint8List> buildPdf(PrescriptionDocumentData data) async {
    final theme = await _loadTheme();
    final logo = await _loadLogo();
    final document = pw.Document();

    document.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pageFormat,
          theme: theme,
          margin: const pw.EdgeInsets.only(bottom: 8),
          textDirection: pw.TextDirection.rtl,
          // Without it the page images are transparent, and viewers with a
          // dark background (full-screen image) show them black.
          buildBackground: (_) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(color: PdfColors.white),
          ),
        ),
        // Every page names the doctor and the date, so a page shown on
        // its own still says who wrote it and when.
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            context.pageNumber == 1
                ? _buildHeader(logo)
                : _buildContinuationHeader(data),
            _buildDoctorStrip(data),
          ],
        ),
        footer: _buildFooter,
        build: (context) => [
          _buildInfoTable(data),
          ..._buildMedicines(data.prescription),
          ..._buildExaminations(data.prescription),
          ..._buildInstructions(data.prescription),
        ].map(_padded).toList(),
      ),
    );

    return document.save();
  }

  static Future<pw.ThemeData> _loadTheme() async {
    if (_theme != null) return _theme!;
    final regular = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final bold = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");
    return _theme = pw.ThemeData.withFont(
      base: pw.Font.ttf(regular),
      bold: pw.Font.ttf(bold),
    );
  }

  static Future<pw.MemoryImage?> _loadLogo() async {
    if (_logo != null) return _logo;
    try {
      final bytes = await rootBundle.load('assets/images/we_care_logo.png');
      return _logo = pw.MemoryImage(bytes.buffer.asUint8List());
    } catch (_) {
      return null;
    }
  }

  static String _formatDate(DateTime date) =>
      "${date.year}/${date.month}/${date.day}";

  static final _arabicLetters = RegExp(r'[\u0600-\u06FF]');

  /// Latin-only text (e.g. an English medicine name) is laid out left to
  /// right, so its words keep their order when it wraps.
  static pw.TextDirection _directionOf(String value) =>
      _arabicLetters.hasMatch(value) || value.trim().isEmpty
          ? pw.TextDirection.rtl
          : pw.TextDirection.ltr;

  static String _text(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? "-" : sanitizeTextForPdf(trimmed);
  }

  pw.Widget _padded(pw.Widget child) => pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: _sidePadding),
        child: child,
      );

  // ---------------------------------------------------------------------------
  // Header & footer (same look as the medical report)
  // ---------------------------------------------------------------------------

  pw.Widget _buildHeader(pw.MemoryImage? logo) {
    return pw.Container(
      color: _darkBlue,
      padding: const pw.EdgeInsets.symmetric(
        horizontal: _sidePadding,
        vertical: 10,
      ),
      child: pw.Row(
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  "روشتة طبية",
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  "WECARE - Save Your Soul",
                  style: const pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 8,
                  ),
                ),
              ],
            ),
          ),
          if (logo != null)
            pw.Container(
              padding: const pw.EdgeInsets.all(3),
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Image(logo, width: 38, height: 38),
            ),
        ],
      ),
    );
  }

  pw.Widget _buildContinuationHeader(PrescriptionDocumentData data) {
    final patientName = data.patientName?.trim() ?? '';
    return pw.Container(
      width: double.infinity,
      color: _darkBlue,
      padding: const pw.EdgeInsets.symmetric(
        horizontal: _sidePadding,
        vertical: 6,
      ),
      child: pw.Text(
        sanitizeTextForPdf(
          patientName.isEmpty
              ? "روشتة طبية (تابع)"
              : "روشتة طبية (تابع) - $patientName",
        ),
        style: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildDoctorStrip(PrescriptionDocumentData data) {
    final doctorName = data.doctorName?.trim() ?? '';
    final doctorSpecialty = data.doctorSpecialty?.trim() ?? '';
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.symmetric(
        horizontal: _sidePadding,
        vertical: 5,
      ),
      decoration: pw.BoxDecoration(
        color: _headerBackground,
        border: pw.Border(bottom: pw.BorderSide(color: _babyBlue, width: 1.5)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (doctorName.isNotEmpty)
                  pw.Text(
                    sanitizeTextForPdf("د. $doctorName"),
                    style: pw.TextStyle(
                      fontSize: 9.5,
                      fontWeight: pw.FontWeight.bold,
                      color: _darkBlue,
                    ),
                  ),
                if (doctorSpecialty.isNotEmpty)
                  pw.Text(
                    sanitizeTextForPdf(doctorSpecialty),
                    style: const pw.TextStyle(
                      fontSize: 8,
                      color: _detailColor,
                    ),
                  ),
              ],
            ),
          ),
          pw.SizedBox(width: 8),
          pw.Row(
            children: [
              pw.Text(
                "التاريخ: ",
                style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: _darkBlue,
                ),
              ),
              pw.Text(
                _formatDate(data.date),
                textDirection: pw.TextDirection.ltr,
                style:
                    const pw.TextStyle(fontSize: 8.5, color: PdfColors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(
        top: 8,
        left: _sidePadding,
        right: _sidePadding,
      ),
      padding: const pw.EdgeInsets.only(top: 4),
      decoration: pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: _babyBlue, width: 1.5)),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            "We Care Prescription",
            style: const pw.TextStyle(fontSize: 7.5, color: PdfColors.black),
          ),
          pw.Text(
            "${context.pageNumber} / ${context.pagesCount}",
            textDirection: pw.TextDirection.ltr,
            style: const pw.TextStyle(fontSize: 8, color: PdfColors.black),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Info table: patient, last edit, diagnosis (doctor and date are in the
  // header of every page)
  // ---------------------------------------------------------------------------

  pw.Widget _buildInfoTable(PrescriptionDocumentData data) {
    final patientName = data.patientName?.trim() ?? '';
    final diagnosis = data.prescription.diagnosis.trim();

    // Short facts go two per row; the diagnosis takes a whole row.
    final pairs = <(String, String)>[
      if (patientName.isNotEmpty) ("المريض", patientName),
      if (data.editedAt != null) ("آخر تعديل", _formatDate(data.editedAt!)),
    ];
    final rows = <List<(String, String)>>[
      for (var i = 0; i < pairs.length; i += 2)
        pairs.sublist(i, i + 2 > pairs.length ? pairs.length : i + 2),
      if (diagnosis.isNotEmpty) [("التشخيص", diagnosis)],
    ];
    if (rows.isEmpty) return pw.SizedBox();

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: _border, width: 0.5),
      ),
      child: pw.Column(
        children: [
          for (var i = 0; i < rows.length; i++)
            pw.Container(
              decoration: i == rows.length - 1
                  ? null
                  : const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(color: _border, width: 0.5),
                      ),
                    ),
              child: pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  for (final (label, value) in rows[i]) ...[
                    _infoLabel(label),
                    pw.Expanded(child: _infoValue(value)),
                  ],
                  // Keeps a lone fact at half width, like the rows above.
                  if (rows[i].length == 1 && rows[i].first.$1 != "التشخيص")
                    pw.Expanded(child: pw.SizedBox()),
                ],
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _infoLabel(String label) {
    return pw.Container(
      width: 56,
      color: _headerBackground,
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: pw.Text(
        label,
        style: pw.TextStyle(
          fontSize: 8.5,
          fontWeight: pw.FontWeight.bold,
          color: _darkBlue,
        ),
      ),
    );
  }

  pw.Widget _infoValue(String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      child: pw.Text(
        _text(value),
        textDirection: _directionOf(value),
        textAlign: pw.TextAlign.right,
        style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.black),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sections
  // ---------------------------------------------------------------------------

  List<pw.Widget> _buildMedicines(DoctorPrescriptionState prescription) {
    if (prescription.totalMedicines == 0) return [];
    var number = 0;
    return _section(
      title: "الأدوية",
      header: const [
        _Cell("#", flex: 1),
        _Cell("الدواء", flex: 5),
        _Cell("الشكل", flex: 3),
        _Cell("الكمية", flex: 3),
        _Cell("الجرعة", flex: 3),
        _Cell("المدة", flex: 2),
      ],
      rows: [
        for (final medicine in prescription.medicines)
          [
            _Cell("${++number}", flex: 1),
            _Cell.withDetail(
              medicine.name,
              detail: medicine.instructions.trim().isEmpty
                  ? null
                  : "تعليمات: ${medicine.instructions.trim()}",
              flex: 5,
            ),
            _Cell(medicine.medicalForm, flex: 3),
            _Cell(medicine.doseAmount, flex: 3),
            _Cell(medicine.doseFrequency, flex: 3),
            _Cell(medicine.duration, flex: 2),
          ],
        // Written by hand: one free-text line across the row.
        for (final medicine in prescription.manualMedicines)
          [
            _Cell("${++number}", flex: 1),
            _Cell(medicine.details, flex: 16, isStart: true),
          ],
      ],
    );
  }

  List<pw.Widget> _buildExaminations(DoctorPrescriptionState prescription) {
    if (prescription.totalExaminations == 0) return [];
    List<_Cell> freeText(String type, String text) => [
          _Cell(type, flex: 3),
          _Cell(text, flex: 10, isStart: true),
        ];

    return _section(
      title: "الفحوصات",
      header: const [
        _Cell("النوع", flex: 3),
        _Cell("الفحص", flex: 5),
        _Cell("التفاصيل", flex: 5),
      ],
      rows: [
        for (final xRay in prescription.xRays)
          [
            const _Cell("أشعة", flex: 3),
            _Cell("${xRay.bodyPart} - ${xRay.type}", flex: 5),
            _Cell(
              xRay.purposes.isEmpty ? "-" : xRay.purposes.join("، "),
              flex: 5,
            ),
          ],
        for (final xRay in prescription.manualXRays)
          freeText("أشعة", xRay.details),
        for (final labTest in prescription.labTests)
          [
            const _Cell("تحاليل", flex: 3),
            _Cell(labTest.groupName ?? labTest.testNameEn!, flex: 5),
            _Cell(labTest.testNames.join("، "), flex: 5),
          ],
        for (final labTest in prescription.manualLabTests)
          freeText("تحاليل", labTest.details),
        for (final endoscopy in prescription.endoscopies)
          freeText("مناظير", endoscopy.details),
        for (final examination in prescription.additionalExaminations)
          freeText("فحوصات إضافية", examination.details),
      ],
    );
  }

  List<pw.Widget> _buildInstructions(DoctorPrescriptionState prescription) {
    if (prescription.patientInstructions.isEmpty) return [];
    var number = 0;
    return _section(
      title: "تعليمات للمريض",
      header: const [
        _Cell("#", flex: 1),
        _Cell("التعليمات", flex: 16),
      ],
      rows: [
        for (final instruction in prescription.patientInstructions)
          [
            _Cell("${++number}", flex: 1),
            _Cell(instruction.details, flex: 16, isStart: true),
          ],
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Table building blocks
  // ---------------------------------------------------------------------------

  /// The title, the header row and the first row stay together, so a title
  /// never ends a page alone. The other rows are separate widgets, so a
  /// long table continues on the next page.
  List<pw.Widget> _section({
    required String title,
    required List<_Cell> header,
    required List<List<_Cell>> rows,
  }) {
    return [
      pw.Inseparable(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            _sectionTitle(title),
            _row(header, isHeader: true),
            _row(rows.first),
          ],
        ),
      ),
      for (final cells in rows.skip(1)) _row(cells),
    ];
  }

  pw.Widget _sectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 12, bottom: 6),
      decoration: pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: _babyBlue, width: 2)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
          color: _darkBlue,
        ),
      ),
    );
  }

  pw.Widget _row(List<_Cell> cells, {bool isHeader = false}) {
    const side = pw.BorderSide(color: _border, width: 0.5);
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      decoration: pw.BoxDecoration(
        color: isHeader ? _headerBackground : null,
        border: pw.Border(
          top: isHeader ? side : pw.BorderSide.none,
          left: side,
          right: side,
          bottom: side,
        ),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          for (final cell in cells)
            pw.Expanded(
              flex: cell.flex,
              child: pw.Padding(
                padding: const pw.EdgeInsets.symmetric(horizontal: 3),
                child: isHeader ? _headerCell(cell) : _valueCell(cell),
              ),
            ),
        ],
      ),
    );
  }

  pw.Widget _headerCell(_Cell cell) {
    return pw.Text(
      cell.text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(
        fontSize: 8.5,
        fontWeight: pw.FontWeight.bold,
        color: _darkBlue,
      ),
    );
  }

  pw.Widget _valueCell(_Cell cell) {
    final align = cell.isStart ? pw.TextAlign.right : pw.TextAlign.center;
    return pw.Column(
      crossAxisAlignment: cell.isStart
          ? pw.CrossAxisAlignment.start
          : pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          _text(cell.text),
          textDirection: _directionOf(cell.text),
          textAlign: align,
          style: pw.TextStyle(
            fontSize: 8.5,
            color: PdfColors.black,
            fontWeight: cell.isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        if (cell.detail != null)
          pw.Text(
            _text(cell.detail!),
            textDirection: _directionOf(cell.detail!),
            textAlign: align,
            style: const pw.TextStyle(fontSize: 7.5, color: _detailColor),
          ),
      ],
    );
  }
}
