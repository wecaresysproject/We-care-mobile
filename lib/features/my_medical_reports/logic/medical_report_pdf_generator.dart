import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/features/genetic_diseases/genetic_diseases_view/presentation/views/family_member_genetic_diesases.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';

import '../../../../core/global/theming/color_manager.dart';

class MedicalReportPdfGenerator {
  static const sectionMargin =
      pw.EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10);
  static const sectionPadding = pw.EdgeInsets.fromLTRB(15, 5, 15, 15);

  Future<Uint8List> generateMedicalReport(
      MedicalReportResponseModel reportData) async {
    final pdf = pw.Document();

    // Load fonts
    final fontRegular = await rootBundle.load("assets/fonts/Cairo-Regular.ttf");
    final fontBold = await rootBundle.load("assets/fonts/Cairo-Bold.ttf");
    final ttfRegular = pw.Font.ttf(fontRegular);
    final ttfBold = pw.Font.ttf(fontBold);

    // Load images
    final profileImageProvider = await getUserProfileImage(reportData);
    final complaintImages = await _loadComplaintImages(reportData);
    final surgeryImages = await _loadSurgeryImages(reportData);
    final radiologyImages = await _loadRadiologyImages(reportData);
    final prescriptionImages = await _loadPrescriptionImages(reportData);
    final teethImages = await _loadTeethImages(reportData);
    final eyesImages = await _loadEyeImages(reportData);

    final logoImageProvider =
        await _loadAssetImage('assets/images/we_care_logo.png');

    final theme = pw.ThemeData.withFont(
      base: ttfRegular,
      bold: ttfBold,
    );

    pdf.addPage(
      pw.MultiPage(
        maxPages: 1000,
        pageTheme: pw.PageTheme(
          theme: theme,
          pageFormat: PdfPageFormat.a3,
          margin: const pw.EdgeInsets.all(0),
          textDirection: pw.TextDirection.rtl,
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              color: PdfColor.fromInt(0xffD6D6D6),
            ),
          ),
        ),
        footer: (context) => _buildFooter(context),
        header: (context) =>
            _buildHeader(profileImageProvider, logoImageProvider, reportData),
        build: (context) => [
          _buildBasicInfoSection(reportData), // ✅
          _buildVitalSignsSection(reportData), // ✅
          _buildChronicDiseasesSection(reportData), // ✅
          _buildComplaintsSection(
              reportData, complaintImages), // ✅ دن بالشكل اليدوي مع وجود صور
          _buildMedicationsSection(reportData), // ✅
          _buildLabResultsSection(reportData), // ✅
          _buildSurgeriesSection(reportData, surgeryImages),
          _buildXRaySection(reportData, radiologyImages),
          _buildPrescriptionsSection(reportData, prescriptionImages),
          _buildGeneticDiseasesSection(reportData), // ✅
          _buildAllergiesSection(reportData), // ✅
          _buildEyesModuleSection(reportData, eyesImages),
          _buildTeethModuleSection(reportData, teethImages),
          // _buildVaccinationsSection(),
          _buildMentalIlnessSection(
              reportData), // ✅ دن بالشكل اليدووي من غير صور
          ..._buildSmartNutrationAnalysisSection(reportData), // ✅
          pw.SizedBox(height: 10),
          _buildPhysicalActivitySection(reportData), // ✅
          _buildSupplementsAndVitaminsSection(reportData), // ✅
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildXRaySection(MedicalReportResponseModel reportData,
      Map<String, pw.MemoryImage> radiologyImages) {
    final radiologyEntries = reportData.data.radiology;

    if (radiologyEntries == null || radiologyEntries.isEmpty) {
      return pw.SizedBox.shrink();
    }

    // Step 1: Build a flat list of quarters from all radiology tickets
    final quarters = <pw.Widget>[];

    for (final radiology in radiologyEntries) {
      // Collect all valid images: xrayImages + reportImages
      final allImages = <String>[
        ...(radiology.xrayImages ?? []),
        ...(radiology.reportImages ?? []),
      ].where((url) => url.isNotEmpty && url != "لم يتم ادخال بيانات").toList();

      if (allImages.isEmpty) {
        // No images: still show the table in a quarter with no image
        quarters.add(_buildRadiologyQuarter(radiology, null, radiologyImages));
      } else {
        // First quarter: table + first image
        quarters.add(_buildRadiologyQuarter(
            radiology, allImages.first, radiologyImages));

        // Remaining images: each gets its own image-only quarter
        for (var i = 1; i < allImages.length; i++) {
          quarters.add(_buildImageOnlyQuarter(allImages[i], radiologyImages));
        }
      }
    }

    // Step 2: Pack quarters into rows of 2, and rows into pages of 2 rows (4 quarters per page)
    final rows = <pw.Widget>[];
    for (var i = 0; i < quarters.length; i += 2) {
      final hasSecond = i + 1 < quarters.length;
      rows.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                  child: quarters[i],
                ),
              ),
              pw.Expanded(
                child: hasSecond
                    ? pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: quarters[i + 1],
                      )
                    : pw.SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأشعة'),
          pw.SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  /// Builds a quarter with a compact metadata table + one image underneath.
  pw.Widget _buildRadiologyQuarter(
    RadiologyEntry radiology,
    String? imageUrl,
    Map<String, pw.MemoryImage> radiologyImages,
  ) {
    final periodicUsageText =
        (radiology.periodicUsage != null && radiology.periodicUsage!.isNotEmpty)
            ? radiology.periodicUsage!.first
            : '';

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Manual metadata table
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
          ),
          child: pw.Row(
            children: [
              _buildHeaderCell('التاريخ', flex: 2, fontSize: 10),
              _buildHeaderCell('نوع الأشعة', flex: 2, fontSize: 10),
              _buildHeaderCell('منطقة الأشعة', flex: 2, fontSize: 10),
              if (periodicUsageText.isNotEmpty)
                _buildHeaderCell('نوعية الاحتياج', flex: 3, fontSize: 10),
            ],
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              left: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              right: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            ),
          ),
          child: pw.Row(
            children: [
              _buildValueCell(_safeText(radiology.radiologyDate),
                  flex: 2, fontSize: 10),
              _buildValueCell(_safeText(radiology.radioType),
                  flex: 2, fontSize: 10),
              _buildValueCell(_safeText(radiology.bodyPart),
                  flex: 2, fontSize: 10),
              if (periodicUsageText.isNotEmpty)
                _buildValueCell(_safeText(periodicUsageText),
                    flex: 3, fontSize: 10),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        // Image area
        if (imageUrl != null) _buildQuarterImage(imageUrl, radiologyImages),
      ],
    );
  }

  /// Builds a quarter with only an image (no table).
  pw.Widget _buildImageOnlyQuarter(
    String imageUrl,
    Map<String, pw.MemoryImage> radiologyImages,
  ) {
    return _buildQuarterImage(imageUrl, radiologyImages);
  }

  /// Renders a single image inside a bordered container, filling the quarter.
  pw.Widget _buildQuarterImage(
    String imageUrl,
    Map<String, pw.MemoryImage> radiologyImages,
  ) {
    final image = radiologyImages[imageUrl];
    final double quarterHeight = 190 * 2;

    return pw.Container(
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey200),
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: image != null
          ? pw.Image(
              image,
              fit: pw.BoxFit.fill,
              // width: quarterWidth,
              height: quarterHeight,
            )
          // ? pw.Column(
          //     children: [

          //       // pw.SizedBox(height: 2),
          //       // pw.UrlLink(
          //       //   destination: imageUrl,
          //       //   child: pw.Text(
          //       //     'اضغط للتحميل',
          //       //     style: pw.TextStyle(
          //       //       fontSize: 8,
          //       //       color: PdfColors.blue700,
          //       //       decoration: pw.TextDecoration.underline,
          //       //     ),
          //       //   ),
          //       // ),
          //     ],
          //   )
          : pw.SizedBox(height: quarterHeight),
    );
  }

  pw.Widget _buildPrescriptionsSection(MedicalReportResponseModel reportData,
      Map<String, pw.MemoryImage> prescriptionImages) {
    final prescriptions = reportData.data.preDescriptions;

    if (prescriptions == null || prescriptions.isEmpty) {
      return pw.SizedBox.shrink();
    }

    // Step 1: Collect all "quarters" (Metadata+Image or Image-only)
    final quarters = <pw.Widget>[];

    for (final prescription in prescriptions) {
      // Collect all valid images
      final allImages = (prescription.preDescriptionPhoto ?? [])
          .where((url) => url.isNotEmpty && url != "لم يتم ادخال بيانات")
          .toList();

      if (allImages.isEmpty) {
        // No images: still show the table in a quarter with no image
        quarters.add(
            _buildPrescriptionQuarter(prescription, null, prescriptionImages));
      } else {
        // First quarter: table + first image
        quarters.add(_buildPrescriptionQuarter(
            prescription, allImages.first, prescriptionImages));

        // Remaining images: each gets its own image-only quarter
        for (var i = 1; i < allImages.length; i++) {
          quarters
              .add(_buildImageOnlyQuarter(allImages[i], prescriptionImages));
        }
      }
    }

    // Step 2: Pack quarters into rows of 2 (A3 vertical layout / 2 columns)
    final rows = <pw.Widget>[];
    for (var i = 0; i < quarters.length; i += 2) {
      final hasSecond = i + 1 < quarters.length;
      rows.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 10),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                  child: quarters[i],
                ),
              ),
              pw.Expanded(
                child: hasSecond
                    ? pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 5),
                        child: quarters[i + 1],
                      )
                    : pw.SizedBox(),
              ),
            ],
          ),
        ),
      );
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('روشتة الأطباء'),
          pw.SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }

  pw.Widget _buildGeneticDiseasesSection(
      MedicalReportResponseModel reportData) {
    final geneticModule = reportData.data.geneticDiseases;
    if (geneticModule == null) return pw.SizedBox.shrink();

    final hasFamilyDiseases = geneticModule.familyGeneticDiseases != null &&
        geneticModule.familyGeneticDiseases!.isNotEmpty;
    final hasExpectedRisks = geneticModule.myExpectedGeneticDiseases != null &&
        geneticModule.myExpectedGeneticDiseases!.isNotEmpty;

    if (!hasFamilyDiseases && !hasExpectedRisks) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الامراض الوراثية'),
          pw.SizedBox(height: 12),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// ================= FAMILY DISEASES =================
              pw.Expanded(
                flex: 3,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'الامراض الوراثية العائلية',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: PdfColor.fromInt(
                            AppColorsManager.mainDarkBlue.toARGB32()),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    if (hasFamilyDiseases) ...[
                      _buildFamilyGeneticHeaderRow(),
                      ...geneticModule.familyGeneticDiseases!.map((item) {
                        final membersNames = (item.members ?? []).map((m) {
                          final memberCode =
                              (m.code != null && m.code!.isNotEmpty)
                                  ? getFamilyMemberCode(m.code!)
                                  : "غير معروف";
                          final nameStr = (m.name != null && m.name!.isNotEmpty)
                              ? " : ${m.name}"
                              : "";
                          return "- $memberCode$nameStr";
                        }).join('\n');

                        final membersStatuses = (item.members ?? []).map((m) {
                          return (m.diseaseStatus != null &&
                                  m.diseaseStatus!.isNotEmpty)
                              ? '- ${m.diseaseStatus}'
                              : "--";
                        }).join('\n');

                        return pw.Column(
                          children: [
                            _buildFamilyGeneticRow(
                              status: membersStatuses,
                              names: membersNames,
                              disease: item.geneticDisease,
                            ),
                            pw.Divider(
                              color: PdfColors.grey300,
                              height: 1,
                            ),
                          ],
                        );
                      }),
                    ],
                  ],
                ),
              ),

              pw.SizedBox(width: 12),

              /// ================= EXPECTED DISEASES =================
              pw.Expanded(
                flex: 2,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'أمراضي الوراثية المتوقعة',
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: PdfColor.fromInt(
                            AppColorsManager.mainDarkBlue.toARGB32()),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    if (hasExpectedRisks) ...[
                      _buildExpectedGeneticHeaderRow(),
                      ...geneticModule.myExpectedGeneticDiseases!.map((item) {
                        return pw.Column(
                          children: [
                            _buildExpectedGeneticRow(
                              probability: item.probabilityLevel,
                              disease: item.geneticDisease,
                            ),
                            pw.Divider(
                              color: PdfColors.grey300,
                              height: 1,
                            ),
                          ],
                        );
                      }),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFamilyGeneticHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('المرض الوراثي', flex: 3),
          _buildHeaderCell('الأقارب المصابون', flex: 4),
          _buildHeaderCell('حالة المريض', flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildFamilyGeneticRow({
    required String status,
    required String names,
    String? disease,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(disease), flex: 3),
          _buildValueCell(
            _safeText(names),
            flex: 4,
          ),
          _buildValueCell(_safeText(status), flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildExpectedGeneticHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('الأمراض الوراثية المتوقعة', flex: 4),
          _buildHeaderCell('احتمالية الإصابة', flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildExpectedGeneticRow({
    String? probability,
    String? disease,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(
            _safeText(disease),
            flex: 4,
          ),
          _buildValueCell(_safeText(probability), flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildSupplementsAndVitaminsSection(
      MedicalReportResponseModel reportData) {
    final supplementsModule = reportData.data.supplementsModule;
    if (supplementsModule == null ||
        supplementsModule.supplements == null ||
        supplementsModule.supplements!.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('متابعة الفيتامينات و المكملات الغذائية'),
          pw.SizedBox(height: 12),
          _buildSupplementsHeaderRow(),
          ...supplementsModule.supplements!.map((supplement) {
            return pw.Column(
              children: [
                _buildSupplementsRow(supplement),
                pw.Divider(
                  color: PdfColors.grey300,
                  height: 1,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildPhysicalActivitySection(
      MedicalReportResponseModel reportData) {
    final physicalActivityModule = reportData.data.physicalActivityModule;
    if (physicalActivityModule == null || physicalActivityModule.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('جدول متابعة النشاط الرياضي'),
          pw.SizedBox(height: 12),
          _buildPhysicalActivityHeaderRow(),
          ...physicalActivityModule.map((entry) {
            return pw.Column(
              children: [
                _buildPhysicalActivityRow(entry),
                pw.Divider(
                  color: PdfColors.grey300,
                  height: 1,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildPhysicalActivityRow(PhysicalActivityEntry entry) {
    String planTypeAr = entry.planType ?? "--";
    if (planTypeAr.toLowerCase() == 'monthly') {
      planTypeAr = 'شهرية';
    } else if (planTypeAr.toLowerCase() == 'weekly') {
      planTypeAr = 'أسبوعية';
    }

    final dateStr = entry.dateRange != null
        ? "${(entry.dateRange!.to)} : ${(entry.dateRange!.from)}"
        : "--";

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(dateStr), flex: 20),
          _buildValueCell(_safeText(planTypeAr), flex: 12),
          _buildValueCell(
              _safeText(
                  formatter.format((entry.totalExerciseDays ?? 0).round())),
              flex: 10),
          _buildValueCell(
              _safeText(
                  formatter.format((entry.averageMinutesPerDay ?? 0).round())),
              flex: 10),
          _buildValueCell(
              _safeText(
                  formatter.format((entry.totalExerciseMinutes ?? 0).round())),
              flex: 10),
          _buildValueCell(
              _safeText(formatter
                  .format((entry.muscleBuildingUnitsActual ?? 0).round())),
              flex: 10),
          _buildValueCell(
              _safeText(formatter
                  .format((entry.muscleBuildingUnitsStandard ?? 0).round())),
              flex: 10),
          _buildValueCell(
              _safeText(formatter
                  .format((entry.muscleMaintenanceUnitsActual ?? 0).round())),
              flex: 10),
          _buildValueCell(
              _safeText(formatter
                  .format((entry.muscleMaintenanceUnitsStandard ?? 0).round())),
              flex: 10),
        ],
      ),
    );
  }

  pw.Widget _buildPhysicalActivityHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('التاريخ', flex: 18),
          _buildHeaderCell('خطة (أسبوعية/\nشهرية)', flex: 12),
          _buildHeaderCell('عدد أيام\nممارسة الرياضة', flex: 10),
          _buildHeaderCell('متوسط\nالدقائق لليوم', flex: 10),
          _buildHeaderCell('عدد دقائق\nممارسة الرياضة', flex: 10),
          _buildHeaderCell('وحدات البناء\nالعضلي الفعلي', flex: 10),
          _buildHeaderCell('وحدات البناء\nالعضلى المعيارى', flex: 10),
          _buildHeaderCell('وحدات الصيانة\nالعضلية الفعلية', flex: 10),
          _buildHeaderCell('وحدات الصيانة\nالعضلية المعيارية', flex: 10),
        ],
      ),
    );
  }

  pw.Widget _buildSupplementsHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(6),
      decoration: const pw.BoxDecoration(color: PdfColors.grey100),
      child: pw.Row(
        children: [
          _buildHeaderCell('التاريخ', flex: 18),
          _buildHeaderCell('نوع الخطة', flex: 15),
          _buildHeaderCell('اسم الفيتامين (المكمل الغذائي)', flex: 35),
          _buildHeaderCell('الجرعة اليومية', flex: 12),
        ],
      ),
    );
  }

  pw.Widget _buildSupplementsRow(dynamic supplement) {
    String planTypeAr = mapPlanTypeName(supplement);

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(supplement.date), flex: 18),
          _buildValueCell(_safeText(planTypeAr), flex: 15),
          _buildValueCell(_safeText(supplement.supplementName), flex: 35),
          _buildValueCell(_safeText(supplement.dosage), flex: 12),
        ],
      ),
    );
  }

  String mapPlanTypeName(Supplement supplement) {
    String planTypeAr = supplement.planType ?? "--";
    if (planTypeAr.toLowerCase() == 'monthly') {
      planTypeAr = 'شهرية';
    } else if (planTypeAr.toLowerCase() == 'weekly') {
      planTypeAr = 'أسبوعية';
    }
    return planTypeAr;
  }

  pw.Widget _buildPrescriptionQuarter(
    PreDescriptionModel prescription,
    String? imageUrl,
    Map<String, pw.MemoryImage> prescriptionImages,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Manual metadata table
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: pw.BoxDecoration(
            color: PdfColors.grey100,
            border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
          ),
          child: pw.Row(
            children: [
              _buildHeaderCell('التاريخ', flex: 3, fontSize: 10),
              _buildHeaderCell('اسم الطبيب', flex: 4, fontSize: 10),
              _buildHeaderCell('التخصص', flex: 3, fontSize: 10),
            ],
          ),
        ),
        pw.Container(
          padding: const pw.EdgeInsets.symmetric(vertical: 4),
          decoration: const pw.BoxDecoration(
            border: pw.Border(
              left: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              right: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
              bottom: pw.BorderSide(color: PdfColors.grey300, width: 0.5),
            ),
          ),
          child: pw.Row(
            children: [
              _buildValueCell(_safeText(prescription.preDescriptionDate),
                  flex: 3, fontSize: 10),
              _buildValueCell(_safeText(prescription.doctorName),
                  flex: 4, fontSize: 10),
              _buildValueCell(_safeText(prescription.doctorSpecialty),
                  flex: 3, fontSize: 10),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        // Image area
        if (imageUrl != null) _buildQuarterImage(imageUrl, prescriptionImages),
      ],
    );
  }

  Future<Map<String, pw.MemoryImage>> _loadPrescriptionImages(
      MedicalReportResponseModel reportData) async {
    final images = <String, pw.MemoryImage>{};
    final prescriptions = reportData.data.preDescriptions;
    if (prescriptions == null) return images;

    final urls = <String>{};
    for (var p in prescriptions) {
      if (p.preDescriptionPhoto != null) {
        for (var url in p.preDescriptionPhoto!) {
          if (url.isNotEmpty && url != "string") {
            urls.add(url);
          }
        }
      }
    }

    AppLogger.debug('🔍 Loading ${urls.length} prescription images...');
    for (var url in urls) {
      try {
        final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
        images[url] = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        AppLogger.debug('❌ Failed to load prescription image: $url - $e');
      }
    }
    return images;
  }

  pw.Widget _buildTeethModuleSection(MedicalReportResponseModel reportData,
      Map<String, pw.MemoryImage> teethImages) {
    final teethModule = reportData.data.teethModule;
    if (teethModule == null) return pw.SizedBox.shrink();

    final hasSymptoms = teethModule.teethSymptoms != null &&
        teethModule.teethSymptoms!.isNotEmpty;
    final hasProcedures = teethModule.teethProcedures != null &&
        teethModule.teethProcedures!.isNotEmpty;

    if (!hasSymptoms && !hasProcedures) return pw.SizedBox.shrink();

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأسنان'),
          pw.SizedBox(height: 12),
          if (hasSymptoms) ...[
            pw.Text('أعراض الأسنان',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColor.fromInt(
                        AppColorsManager.mainDarkBlue.toARGB32()))),
            pw.SizedBox(height: 2),
            _buildTeethSymptomHeaderRow(),
            ...teethModule.teethSymptoms!.map((symptom) {
              return pw.Column(
                children: [
                  _buildTeethSymptomRow(symptom),
                  pw.Divider(color: PdfColors.grey300, height: 1),
                ],
              );
            }),
            pw.SizedBox(height: 10),
          ],
          if (hasProcedures) ...[
            pw.Text('إجراءات الأسنان',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColor.fromInt(
                        AppColorsManager.mainDarkBlue.toARGB32()))),
            pw.SizedBox(height: 2),
            ...teethModule.teethProcedures!.asMap().entries.map((entry) {
              final index = entry.key;
              final procedure = entry.value;
              final isLast = index == teethModule.teethProcedures!.length - 1;

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.TableHelper.fromTextArray(
                    headers: [
                      'الإجراء الطبي الفرعي',
                      'الإجراء الطبي الرئيسي',
                      'رقم السن',
                      'التاريخ',
                    ],
                    data: [
                      [
                        _safeText(procedure.subProcedure),
                        _safeText(procedure.primaryProcedure),
                        _safeText(procedure.teethNumber),
                        _safeText(procedure.procedureDate),
                      ]
                    ],
                    headerStyle: pw.TextStyle(
                      color: PdfColor.fromInt(
                          AppColorsManager.mainDarkBlue.toARGB32()),
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey100),
                    cellAlignment: pw.Alignment.center,
                    border: pw.TableBorder.all(
                        color: PdfColors.grey300, width: 0.5),
                  ),
                  if (procedure.xRayImages != null &&
                      procedure.xRayImages!.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: procedure.xRayImages!.map((url) {
                        final img = teethImages[url];
                        if (img == null) return pw.SizedBox();
                        // Occupy roughly 50% width if more than 1 image, else 100%
                        final width =
                            procedure.xRayImages!.length == 1 ? 500.0 : 240.0;
                        return pw.Container(
                          width: width,
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: PdfColors.grey200),
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Image(img, fit: pw.BoxFit.contain),
                        );
                      }).toList(),
                    ),
                  ],
                  if (!isLast)
                    pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Future<Map<String, pw.MemoryImage>> _loadTeethImages(
      MedicalReportResponseModel reportData) async {
    final images = <String, pw.MemoryImage>{};
    final module = reportData.data.teethModule;
    if (module == null || module.teethProcedures == null) return images;

    final urls = <String>{};
    for (var p in module.teethProcedures!) {
      if (p.xRayImages != null) {
        for (var url in p.xRayImages!) {
          if (url.isNotEmpty && url != "string") {
            urls.add(url);
          }
        }
      }
    }

    AppLogger.debug('🔍 Loading ${urls.length} teeth x-ray images...');
    for (var url in urls) {
      try {
        final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
        images[url] = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        AppLogger.debug('❌ Failed to load teeth image: $url - $e');
      }
    }
    return images;
  }

  pw.Widget _buildEyesModuleSection(MedicalReportResponseModel reportData,
      Map<String, pw.MemoryImage> eyeImages) {
    final eyeModule = reportData.data.eyeModule;
    if (eyeModule == null) return pw.SizedBox.shrink();

    final hasSymptoms =
        eyeModule.eyeSymptoms != null && eyeModule.eyeSymptoms!.isNotEmpty;
    final hasProcedures =
        eyeModule.eyeProcedures != null && eyeModule.eyeProcedures!.isNotEmpty;

    if (!hasSymptoms && !hasProcedures) return pw.SizedBox.shrink();

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('العيون'),
          pw.SizedBox(height: 12),
          if (hasSymptoms) ...[
            pw.Text('أعراض العيون',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColor.fromInt(
                        AppColorsManager.mainDarkBlue.toARGB32()))),
            pw.SizedBox(height: 2),
            pw.TableHelper.fromTextArray(
              headers: [
                'مدة الأعراض',
                'الأعراض',
                'عضو العين',
                'تاريخ بداية الأعراض',
              ],
              data: eyeModule.eyeSymptoms!.map((symptom) {
                return [
                  _safeText(symptom.symptomDuration),
                  _safeText(
                    (symptom.symptoms != null && symptom.symptoms!.isNotEmpty)
                        ? symptom.symptoms!
                            .map((e) =>
                                e.trim() == "لم يتم ادخال بيانات" ? e : '- $e')
                            .join('\n')
                        : '--',
                  ),
                  _safeText(symptom.affectedEyePart),
                  _safeText(symptom.symptomStartDate),
                ];
              }).toList(),
              headerStyle: pw.TextStyle(
                color:
                    PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
                fontWeight: pw.FontWeight.bold,
                fontSize: 12,
              ),
              cellStyle: const pw.TextStyle(
                fontSize: 12,
              ),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey100),
              cellAlignment: pw.Alignment.center,
              border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            ),
            pw.SizedBox(height: 10),
          ],
          if (hasProcedures) ...[
            pw.Text('إجراءات العيون',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 14,
                    color: PdfColor.fromInt(
                        AppColorsManager.mainDarkBlue.toARGB32()))),
            pw.SizedBox(height: 2),
            ...eyeModule.eyeProcedures!.asMap().entries.map((entry) {
              final index = entry.key;
              final procedure = entry.value;
              final isLast = index == eyeModule.eyeProcedures!.length - 1;

              final combinedImages = [
                ...?procedure.medicalExaminationImages,
                ...?procedure.medicalReportUrl,
              ].where((url) => url.isNotEmpty && url != "string").toList();

              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.TableHelper.fromTextArray(
                    headers: [
                      'الإجراء الطبي',
                      'عضو العين',
                      'تاريخ الإجراء الطبي',
                    ],
                    data: [
                      [
                        _safeText(
                          (procedure.medicalProcedures != null &&
                                  procedure.medicalProcedures!.isNotEmpty)
                              ? procedure.medicalProcedures!
                                  .map((e) => e.trim() == "لم يتم ادخال بيانات"
                                      ? e
                                      : '- $e')
                                  .join('\n')
                              : '--',
                        ),
                        _safeText(procedure.affectedEyePart),
                        _safeText(procedure.medicalReportDate),
                      ]
                    ],
                    headerStyle: pw.TextStyle(
                      color: PdfColor.fromInt(
                          AppColorsManager.mainDarkBlue.toARGB32()),
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                    cellStyle: const pw.TextStyle(
                      fontSize: 12,
                    ),
                    headerDecoration:
                        const pw.BoxDecoration(color: PdfColors.grey100),
                    cellAlignment: pw.Alignment.center,
                    border: pw.TableBorder.all(
                        color: PdfColors.grey300, width: 0.5),
                  ),
                  if (combinedImages.isNotEmpty) ...[
                    pw.SizedBox(height: 8),
                    pw.Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: combinedImages.asMap().entries.map(
                        (imgEntry) {
                          final url = imgEntry.value;
                          final img = eyeImages[url];
                          if (img == null) return pw.SizedBox();

                          return pw.Container(
                            width: 240, // 50% width roughly
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.grey200),
                              borderRadius: pw.BorderRadius.circular(4),
                            ),
                            child: pw.Image(img, fit: pw.BoxFit.contain),
                          );
                        },
                      ).toList(),
                    ),
                  ],
                  if (!isLast)
                    pw.Divider(color: PdfColors.grey300, thickness: 0.5),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  Future<Map<String, pw.MemoryImage>> _loadEyeImages(
      MedicalReportResponseModel reportData) async {
    final images = <String, pw.MemoryImage>{};
    final module = reportData.data.eyeModule;
    if (module == null || module.eyeProcedures == null) return images;

    final urls = <String>{};
    for (var p in module.eyeProcedures!) {
      if (p.medicalExaminationImages != null) {
        for (var url in p.medicalExaminationImages!) {
          if (url.isNotEmpty && url != "string") urls.add(url);
        }
      }
      if (p.medicalReportUrl != null) {
        for (var url in p.medicalReportUrl!) {
          if (url.isNotEmpty && url != "string") urls.add(url);
        }
      }
    }

    AppLogger.debug('🔍 Loading ${urls.length} eye images...');
    for (var url in urls) {
      try {
        final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
        images[url] = pw.MemoryImage(data.buffer.asUint8List());
      } catch (e) {
        AppLogger.debug('❌ Failed to load eye image: $url - $e');
      }
    }
    return images;
  }

  pw.Widget _buildHeader(pw.ImageProvider profileImage,
      pw.ImageProvider logoImage, MedicalReportResponseModel reportData) {
    final name = reportData.userName ?? 'غير معروف';

    return pw.Container(
      color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Right Side: Patient Info
          pw.Expanded(
            flex: 3,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Container(
                  width: 70,
                  height: 70,
                  decoration: pw.BoxDecoration(
                    shape: pw.BoxShape.circle,
                    border: pw.Border.all(color: PdfColors.white, width: 2),
                    image: pw.DecorationImage(
                      image: profileImage,
                      fit: pw.BoxFit.cover,
                    ),
                  ),
                ),
                pw.SizedBox(height: 6),
                pw.Text(
                  'الاسم : $name',
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Center: Title + Subtitle
          pw.Expanded(
            flex: 2,
            child: pw.Padding(
              padding: const pw.EdgeInsets.only(top: 20),
              child: pw.Column(
                // mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    'تقرير  طبي شخصي',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 22.5,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'WECARE - Save Your Soul',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 12,
                    ),
                  ),
                  pw.Text(
                    '${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
                    style: pw.TextStyle(
                      color: PdfColors.white,
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Left Side: Logo
          pw.Expanded(
            flex: 3,
            child: pw.Align(
              alignment: pw.Alignment.centerLeft,
              child: pw.Container(
                padding: const pw.EdgeInsets.all(4),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(12),
                ),
                child: pw.Image(
                  logoImage,
                  width: 90,
                  height: 90,
                  fit: pw.BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      // padding: const pw.EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: pw.EdgeInsets.only(top: 4, left: 15, right: 15),
      decoration: pw.BoxDecoration(
        border: pw.Border(
          top: pw.BorderSide(
            color: PdfColor.fromInt(AppColorsManager.babyBlueColor.toARGB32()),
            width: 1.5,
          ),
        ),
      ),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Left: Circular page number
          pw.Container(
            width: 32,
            height: 32,
            alignment: pw.Alignment.center,
            child: pw.Text(
              '${context.pageNumber} / ${context.pagesCount}',
              style: pw.TextStyle(
                color: PdfColors.black,
                fontSize: 12,
                fontWeight: pw.FontWeight.normal,
              ),
            ),
          ),

          // Right: subtle text
          pw.Text(
            'We Care Medical Report',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      decoration: pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(
          color: PdfColor.fromInt(AppColorsManager.babyBlueColor.toARGB32()),
          width: 2,
        )),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
        ),
      ),
    );
  }

  pw.Widget _buildBasicInfoSection(MedicalReportResponseModel reportData) {
    final basicInfo = reportData.data.basicInformation;

    if (basicInfo == null || basicInfo.isEmpty) {
      return pw.SizedBox.shrink();
    }

    final displayInfo = basicInfo
        .where((info) =>
            info.label != 'الصورة' &&
            info.value != null &&
            info.value.toString().isNotEmpty &&
            info.value.toString() != "لم يتم ادخال بيانات")
        .toList();

    return pw.Container(
      margin: pw.EdgeInsets.only(bottom: 10, left: 10, right: 10),
      padding: const pw.EdgeInsets.fromLTRB(15, 5, 15, 15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('البيانات الأساسية'),
          pw.SizedBox(height: 12),
          pw.Wrap(
            runSpacing: 10,
            children: List.generate(displayInfo.length, (index) {
              final info = displayInfo[index];

              if (info.label == 'الاسم' || info.value == 'مش موجود في العرض') {
                return pw.SizedBox.shrink();
              }
              return pw.Padding(
                padding: pw.EdgeInsets.only(
                  left: 15,
                ),
                child: _buildInfoItem(
                    '${info.shortLabel} :', info.value.toString()),
              );
            }),
          )
        ],
      ),
    );
  }

  pw.Widget _buildInfoItem(String label, String value) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey200),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.SizedBox(width: 4),
          pw.Text(
            " ",
            style: const pw.TextStyle(fontSize: 14),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildVitalSignsSection(MedicalReportResponseModel reportData) {
    final vitalSigns = reportData.data.vitalSigns;

    if (vitalSigns == null || vitalSigns.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('القياسات الحيوية'),
          pw.SizedBox(height: 12),
          pw.Wrap(
            spacing: 15,
            runSpacing: 15,
            children: vitalSigns.map((group) {
              return _buildVitalGroupCard(group);
            }).toList(),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildChronicDiseasesSection(
      MedicalReportResponseModel reportData) {
    final diseases = reportData.data.chronicDiseases;

    if (diseases == null || diseases.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأمراض المزمنة'),
          pw.SizedBox(height: 12),
          _buildChronicIllnessHeaderRow(),
          ...diseases.map((disease) {
            return pw.Column(
              children: [
                _buildChronicIllnessRow(disease),
                pw.Divider(
                  color: PdfColors.grey300,
                  height: 1,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildVitalGroupCard(VitalSignGroupModel group) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(12),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            group.categoryName,
            style: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 15,
            runSpacing: 10,
            children: group.reading.map(
              (reading) {
                String value = reading.min;

                // Special case for Blood Pressure (الضغط)
                final isPressureSection =
                    group.categoryName == "الضغط" && reading.max != null;
                if (isPressureSection) {
                  value = "${reading.min}/${reading.max}";
                }

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      value,
                      style: pw.TextStyle(
                        fontSize: 15,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      reading.formattedDate,
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
// ✅ Complaints Section (NO TABLES)

  pw.Widget _buildComplaintsSection(MedicalReportResponseModel reportData,
      Map<String, pw.MemoryImage> complaintImages) {
    final module = reportData.data.complaintsModule;

    if (module == null ||
        module.mainComplaints == null ||
        module.mainComplaints!.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ✅ Title Header
          _buildSectionHeader('الشكاوى الطارئة'),
          pw.SizedBox(height: 12),

          // ✅ Header Row Titles
          _buildComplaintsHeaderRow(),

          // ✅ Main Complaints Rows
          ...module.mainComplaints!.map((complaint) {
            return pw.Column(
              children: [
                _buildComplaintRow(complaint, complaintImages),
                pw.Divider(color: PdfColors.grey300),
              ],
            );
          }),

          // ✅ Additional Complaints (if exists)
          if (module.additionalComplaints != null &&
              module.additionalComplaints!.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text(
              "شكاوى إضافية",
              style: pw.TextStyle(
                fontSize: 15,
                fontWeight: pw.FontWeight.bold,
                color:
                    PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
              ),
            ),
            pw.SizedBox(height: 12),
            _buildAdditionalComplaintsHeaderRow(),
            pw.Divider(color: PdfColors.grey400),
            ...module.additionalComplaints!.map((complaint) {
              return pw.Column(
                children: [
                  _buildAdditionalComplaintRow(complaint, complaintImages),
                  pw.Divider(color: PdfColors.grey300),
                ],
              );
            }),
          ]
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Header Row (Main Complaints)
//////////////////////////////////////////////////////////////////

  pw.Widget _buildComplaintsHeaderRow() {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 5),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell("التاريخ", flex: 2),
          _buildHeaderCell("الشكوى", flex: 5),
          _buildHeaderCell("العضو", flex: 2),
          _buildHeaderCell("طبيعة الشكوى", flex: 2),
          _buildHeaderCell("حدة الشكوى", flex: 2),
          _buildHeaderCell("صورة الشكوى", flex: 2),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Complaint Row (Main Complaints)
//////////////////////////////////////////////////////////////////

  pw.Widget _buildComplaintRow(
      MainComplaint complaint, Map<String, pw.MemoryImage> complaintImages) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(
            complaint.date,
            flex: 2,
          ),
          // ✅ Longest Field Expected: symptoms_Complaint
          _buildValueCell(
            complaint.complaintTitle,
            flex: 5,
            alignRight: true,
          ),
          _buildValueCell(
            complaint.organ,
            flex: 2,
          ),
          _buildValueCell(
            complaint.complaintNature,
            flex: 2,
          ),
          _buildValueCell(
            complaint.severity,
            flex: 2,
          ),
          _buildImageCell(complaint.complaintImage, complaintImages, flex: 2),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Header Row (Additional Complaints)
//////////////////////////////////////////////////////////////////

  pw.Widget _buildAdditionalComplaintsHeaderRow() {
    return pw.Container(
      padding: pw.EdgeInsets.symmetric(vertical: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell("التاريخ", flex: 2),
          _buildHeaderCell("الشكوى", flex: 6),
          _buildHeaderCell("صورة الشكوي", flex: 2),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Complaint Row (Additional Complaints)
//////////////////////////////////////////////////////////////////

  pw.Widget _buildAdditionalComplaintRow(AdditionalComplaint complaint,
      Map<String, pw.MemoryImage> complaintImages) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(
            complaint.date,
            flex: 2,
          ),
          _buildValueCell(
            complaint.complaintTitle,
            flex: 6,
            alignRight: true,
          ),
          _buildImageCell(complaint.complaintImage, complaintImages, flex: 2),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Header Cell Styling
//////////////////////////////////////////////////////////////////

  pw.Widget _buildHeaderCell(String text,
      {required int flex, double fontSize = 14}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: fontSize,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildNutritionHeaderRow() {
    return pw.Container(
      margin: pw.EdgeInsets.zero,
      padding: pw.EdgeInsets.zero,
      decoration: const pw.BoxDecoration(
        color: PdfColors.grey100,
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('اسم العنصر', flex: 12),
          _buildHeaderCell('المتوسط\nاليومى', flex: 12),
          _buildHeaderCell('اليومى\nالمعيارى', flex: 12),
          _buildHeaderCell('التراكمى\nالفعلي', flex: 12),
          _buildHeaderCell('التراكمى\nالمعيارى', flex: 12),
          _buildHeaderCell('الفرق', flex: 10),
          _buildHeaderCell('النسبة', flex: 8),
        ],
      ),
    );
  }

  pw.Widget _buildNutritionRow(NutritionReportItem item) {
    final diff = item.difference ?? 0;
    final percentage = item.percentage ?? 0;

    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(
              item.nutrient == "الطاقة (سعر حراري)"
                  ? "الطاقة (سعر حرارى)"
                  : (item.nutrient ?? "--"),
              flex: 12),
          _buildValueCell(
              item.dailyAverageActual == null
                  ? "--"
                  : formatter.format(item.dailyAverageActual!.round()),
              flex: 12),
          _buildValueCell(
              item.dailyAverageStandard == null
                  ? "--"
                  : formatter.format(item.dailyAverageStandard!.round()),
              flex: 12),
          _buildValueCell(
              item.actualCumulative == null
                  ? "--"
                  : formatter.format(item.actualCumulative!.round()),
              flex: 12),
          _buildValueCell(
              item.standardCumulative == null
                  ? "--"
                  : formatter.format(item.standardCumulative!.round()),
              flex: 12),
          _buildValueCell(diff.toInt().toString(), flex: 10),
          _buildValueCell("${percentage.toStringAsFixed(0)} %", flex: 8),
        ],
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Value Cell Styling
//////////////////////////////////////////////////////////////////

  pw.Widget _buildValueCell(
    String text, {
    double fontSize = 13,
    required int flex,
    bool alignRight = false,
    double horizentalPadding = 4,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Padding(
        padding: pw.EdgeInsets.symmetric(horizontal: horizentalPadding),
        child: pw.Text(
          text,
          style: pw.TextStyle(
            fontSize: fontSize,
            color: PdfColors.black,
          ),
          textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.center,
          softWrap: true,
        ),
      ),
    );
  }

  pw.Widget _buildValueWidgetCell(
    pw.Widget child, {
    required int flex,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4),
        child: pw.Center(child: child),
      ),
    );
  }

  pw.Widget _buildImageCell(
      String? imageUrl, Map<String, pw.MemoryImage> complaintImages,
      {required int flex}) {
    final image = (imageUrl != null) ? complaintImages[imageUrl] : null;

    return pw.Expanded(
      flex: flex,
      child: pw.Center(
        child: (imageUrl != null && imageUrl.isNotEmpty)
            ? pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  if (image != null)
                    pw.Container(
                      child: pw.Image(
                        image,
                      ),
                    ),
                  pw.UrlLink(
                    destination: imageUrl,
                    child: pw.Text(
                      "اضغط للتحميل",
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.blue700,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              )
            : pw.Text(
                "لا يوجد",
                style: const pw.TextStyle(
                  fontSize: 12,
                  color: PdfColors.grey600,
                ),
              ),
      ),
    );
  }

  pw.Widget _buildMedicationsSection(MedicalReportResponseModel reportData) {
    final module = reportData.data.medicationsModule;

    if (module == null) return pw.SizedBox.shrink();

    final current = module.currentMedications;
    final expired = module.expiredLast90Days;

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأدوية'),
          if (current != null && current.isNotEmpty) ...[
            pw.SizedBox(height: 12),
            pw.Text('الأدوية الحالية',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
            pw.SizedBox(height: 2),
            _buildMedicationTable(current, false),
          ],
          if (expired != null && expired.isNotEmpty) ...[
            pw.SizedBox(height: 10),
            pw.Text('الأدوية المنتهية خلال 90 يوم',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13)),
            pw.SizedBox(height: 2),
            _buildMedicationTable(expired, true),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildMedicationTable(List<MedicationModel> meds, bool isExpired) {
    return pw.Column(
      children: [
        _buildMedicationHeaderRow(isExpired),
        ...meds.map((med) {
          return pw.Column(
            children: [
              _buildMedicationRow(med),
              pw.Divider(
                color: PdfColors.grey300,
                height: 1,
              ),
            ],
          );
        }),
      ],
    );
  }

  pw.Widget _buildMedicationHeaderRow(bool isExpired) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell(isExpired ? 'تاريخ الانتهاء' : 'تاريخ الاستخدام',
              flex: 2),
          _buildHeaderCell('اسم الدواء', flex: 4),
          _buildHeaderCell('الجرعة', flex: 1),
          _buildHeaderCell('كمية الدواء', flex: 2),
          _buildHeaderCell('عدد مرات الجرعة', flex: 2),
          _buildHeaderCell('المدد الزمنية', flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildMedicationRow(MedicationModel med) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(med.date), flex: 2),
          _buildValueCell(_safeText(med.medicineName), flex: 4),
          _buildValueCell(_safeText(med.dosage?.toPdfSafeDosage()), flex: 2),
          _buildValueCell(_safeText(med.doseAmount), flex: 2),
          _buildValueCell(_safeText(med.dosageFrequency), flex: 2),
          _buildValueCell(_safeText(med.timeDuration), flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildAllergiesSection(MedicalReportResponseModel reportData) {
    final allergies = reportData.data.allergy;

    if (allergies == null || allergies.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الحساسية'),
          pw.SizedBox(height: 12),
          _buildAllergyHeaderRow(),
          ...allergies.map((allergy) {
            return pw.Column(
              children: [
                _buildAllergyRow(allergy),
                pw.Divider(
                  color: PdfColors.grey300,
                  height: 1,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildAllergyHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('نوع الحساسية', flex: 20),
          _buildHeaderCell('مسببات الحساسية (1)', flex: 20),
          _buildHeaderCell('مسببات الحساسية (2)', flex: 20),
          _buildHeaderCell('مسببات الحساسية (3)', flex: 20),
          _buildHeaderCell('حدة الاعراض', flex: 10),
          _buildHeaderCell('حمل حقنة الابينفرين', flex: 15),
        ],
      ),
    );
  }

  pw.Widget _buildAllergyRow(AllergyModel allergy) {
    final triggers = allergy.allergyTriggers ?? [];
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(allergy.allergyType), flex: 20),
          _buildValueCell(_triggerAt(triggers, 0), flex: 20),
          _buildValueCell(_triggerAt(triggers, 1), flex: 20),
          _buildValueCell(_triggerAt(triggers, 2), flex: 20),
          _buildValueCell(_safeText(allergy.symptomSeverity), flex: 10),
          _buildValueCell(
            allergy.carryEpinephrine.isNull
                ? "--"
                : (allergy.carryEpinephrine! ? "نعم" : "لا"),
            flex: 15,
          ),
        ],
      ),
    );
  }

  String _triggerAt(List<String>? triggers, int index) {
    if (triggers == null || triggers.length <= index) {
      return "لا يوجد";
    }

    return _safeText(triggers[index]);
  }

  String _safeText(String? value, {String fallback = "لا يوجد"}) {
    if (value == null) return fallback;

    final v = value.trim();
    if (v.isEmpty || v == "لم يتم ادخال بيانات") {
      return fallback;
    }

    return v;
  }

  pw.Widget _buildSurgeriesSection(MedicalReportResponseModel reportData,
      Map<String, pw.MemoryImage> surgeryImages) {
    final surgeries = reportData.data.surgeryEntries;

    if (surgeries == null || surgeries.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      width: double.infinity,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('العمليات الجراحية'),
          pw.SizedBox(height: 12),

          // Build each surgery entry with its images
          ...surgeries.asMap().entries.map((entry) {
            final index = entry.key;
            final surgery = entry.value;
            final isLast = index == surgeries.length - 1;
            final images = surgery.medicalReportImage ?? [];
            final validImages = images
                .where((url) => url.isNotEmpty && url != "لم يتم ادخال بيانات")
                .toList();
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Surgery data row
                _buildSurgeryDataRow(surgery),

                if (validImages.isNotEmpty)
                  _buildSurgeryImagesRow(validImages, surgeryImages),

                // Divider between entries (except after last)
                if (!isLast) ...[
                  pw.Divider(color: PdfColors.grey300),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }

  pw.Widget _buildSurgeryDataRow(SurgeryEntry surgery) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      width: double.infinity,
      decoration: pw.BoxDecoration(
        color: PdfColors.grey50,
        borderRadius: pw.BorderRadius.circular(8),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Surgery name (title)
          pw.Text(
            surgery.surgeryName,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
            ),
          ),
          pw.SizedBox(height: 8),

          // Details in grid layout
          pw.Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildSurgeryDetailItem('التاريخ', (surgery.surgeryDate)),
              _buildSurgeryDetailItem('المنطقة', surgery.surgeryRegion),
              _buildSurgeryDetailItem('التقنية', surgery.usedTechnique),
              _buildSurgeryDetailItem('الحالة', surgery.surgeryStatus),
              _buildSurgeryDetailItem('الجراح', surgery.surgeonName),
              _buildSurgeryDetailItem('المستشفى', surgery.hospitalCenter),
              _buildSurgeryDetailItem('الدولة', surgery.country),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSurgeryDetailItem(String label, String value) {
    if (value == "لم يتم ادخال بيانات") {
      return pw.SizedBox.shrink();
    }
    return pw.Container(
      constraints: const pw.BoxConstraints(minWidth: 150),
      child: pw.Row(
        mainAxisSize: pw.MainAxisSize.min,
        children: [
          pw.Text(
            '$label : ',
            style: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(
              fontSize: 14,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSurgeryImagesRow(
      List<String> imageUrls, Map<String, pw.MemoryImage> surgeryImages) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Wrap(
        spacing: 10,
        runSpacing: 10,
        children: imageUrls.map((imageUrl) {
          final image = surgeryImages[imageUrl];

          return pw.Container(
            width: 350,
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              border: pw.Border.all(color: PdfColors.grey400, width: 1),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                if (image != null &&
                    imageUrl.isNotEmpty &&
                    imageUrl != "لم يتم ادخال بيانات") ...[
                  pw.Container(
                    child: pw.Image(
                      image,
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.UrlLink(
                    destination: imageUrl,
                    child: pw.Text(
                      'اضغط للتحميل',
                      style: pw.TextStyle(
                        fontSize: 8,
                        color: PdfColors.blue700,
                        decoration: pw.TextDecoration.underline,
                      ),
                    ),
                  ),
                ] else
                  pw.Container(
                    width: 120,
                    height: 120,
                    child: pw.Center(
                      child: pw.Icon(
                        pw.IconData(0xe3f4),
                        size: 40,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  pw.Widget _buildLabResultsSection(MedicalReportResponseModel reportData) {
    final tests = reportData.data.medicalTests;

    if (tests == null || tests.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التحاليل الطبية'),
          pw.SizedBox(height: 12),
          _buildLabResultHeaderRow(),
          ...tests.map(
            (test) {
              return pw.Column(
                children: [
                  _buildLabResultRow(test),
                  pw.Divider(
                    color: PdfColors.grey300,
                    height: 1,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  pw.Widget _buildLabResultHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('اسم التحليل', flex: 25),
          _buildHeaderCell('الرمز', flex: 12),
          _buildHeaderCell('المجموعة', flex: 20),
          _buildHeaderCell('النتيجة', flex: 15),
          _buildHeaderCell('النتيجة', flex: 15),
          _buildHeaderCell('النتيجة', flex: 15),
        ],
      ),
    );
  }

  pw.Widget _buildLabResultRow(MedicalTestModel test) {
    final results = test.results ?? [];
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(test.testName), flex: 25),
          _buildValueCell(_safeText(test.code), flex: 12),
          _buildValueCell(_safeText(test.group), flex: 20),
          _buildValueWidgetCell(
              _buildTestResultWidget(results.isNotEmpty ? results[0] : null),
              flex: 15),
          _buildValueWidgetCell(
              _buildTestResultWidget(results.length > 1 ? results[1] : null),
              flex: 15),
          _buildValueWidgetCell(
              _buildTestResultWidget(results.length > 2 ? results[2] : null),
              flex: 15),
        ],
      ),
    );
  }

  pw.Widget _buildTestResultWidget(MedicalTestResultModel? result) {
    final hasValue = result?.value != null;
    final valueText = hasValue ? result!.value.toString() : "لا يوجد";
    final dateText =
        result?.testDate != null ? _formatResultDate(result!.testDate!) : "";

    return pw.Column(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          valueText,
          style: pw.TextStyle(
            fontSize: 11,
            fontWeight: hasValue ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        if (dateText.isNotEmpty)
          pw.Text(
            dateText,
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.black,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
      ],
    );
  }

  String _formatResultDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);

      const months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec"
      ];
      return "${date.day}-${months[date.month - 1]}-${date.year.toString().substring(2)}";
    } catch (_) {
      return dateStr;
    }
  }

  Future<pw.ImageProvider> getUserProfileImage(
      MedicalReportResponseModel reportData) async {
    pw.ImageProvider? profileImageProvider;
    final imageUrl = reportData.imageUrl;

    if (imageUrl.isNotNull && imageUrl!.isNotEmpty) {
      try {
        final ByteData data =
            await NetworkAssetBundle(Uri.parse(imageUrl)).load("");
        profileImageProvider = pw.MemoryImage(data.buffer.asUint8List());
      } catch (_) {}
    }

    profileImageProvider ??=
        await _loadAssetImage('assets/images/ai_image.png');
    return profileImageProvider;
  }

  Future<pw.ImageProvider> _loadAssetImage(String path) async {
    final image = await rootBundle.load(path);
    return pw.MemoryImage(image.buffer.asUint8List());
  }

  Future<Map<String, pw.MemoryImage>> _loadComplaintImages(
      MedicalReportResponseModel reportData) async {
    final images = <String, pw.MemoryImage>{};
    final module = reportData.data.complaintsModule;
    if (module == null) return images;

    final urls = <String>{};
    if (module.mainComplaints != null) {
      for (var c in module.mainComplaints!) {
        if (c.complaintImage != null && c.complaintImage!.isNotEmpty) {
          urls.add(c.complaintImage!);
        }
      }
    }
    if (module.additionalComplaints != null) {
      for (var c in module.additionalComplaints!) {
        if (c.complaintImage != null && c.complaintImage!.isNotEmpty) {
          urls.add(c.complaintImage!);
        }
      }
    }

    for (var url in urls) {
      try {
        final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
        images[url] = pw.MemoryImage(data.buffer.asUint8List());
      } catch (_) {
        // Log image load failure if needed
      }
    }
    return images;
  }

  Future<Map<String, pw.MemoryImage>> _loadSurgeryImages(
      MedicalReportResponseModel reportData) async {
    final images = <String, pw.MemoryImage>{};
    final surgeries = reportData.data.surgeryEntries;
    if (surgeries == null) return images;

    final urls = <String>{};
    for (var surgery in surgeries) {
      if (surgery.medicalReportImage != null) {
        for (var imageUrl in surgery.medicalReportImage!) {
          if (imageUrl.isNotEmpty) {
            urls.add(imageUrl);
          }
        }
      }
    }

    AppLogger.debug('🔍 Loading ${urls.length} surgery images...');

    for (var url in urls) {
      try {
        AppLogger.debug('📥 Attempting to load: $url');
        final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
        images[url] = pw.MemoryImage(data.buffer.asUint8List());
        AppLogger.debug('✅ Successfully loaded: $url');
      } catch (e) {
        AppLogger.debug('❌ Failed to load: $url - Error: $e');
      }
    }

    AppLogger.debug('✅ Total surgery images loaded: ${images.length}');
    return images;
  }

  Future<Map<String, pw.MemoryImage>> _loadRadiologyImages(
      MedicalReportResponseModel reportData) async {
    final images = <String, pw.MemoryImage>{};
    final items = reportData.data.radiology;
    if (items == null) return images;

    final urls = <String>{};
    for (var item in items) {
      if (item.xrayImages != null) {
        for (var imageUrl in item.xrayImages!) {
          if (imageUrl.isNotEmpty) {
            urls.add(imageUrl);
          }
        }
      }
      if (item.reportImages != null) {
        for (var imageUrl in item.reportImages!) {
          if (imageUrl.isNotEmpty) {
            urls.add(imageUrl);
          }
        }
      }
    }

    AppLogger.debug('🔍 Loading ${urls.length} radiology images...');

    for (var url in urls) {
      try {
        AppLogger.debug('📥 Attempting to load: $url');
        final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load("");
        images[url] = pw.MemoryImage(data.buffer.asUint8List());
        AppLogger.debug('✅ Successfully loaded: $url');
      } catch (e) {
        AppLogger.debug('❌ Failed to load: $url - Error: $e');
      }
    }

    AppLogger.debug('✅ Total radiology images loaded: ${images.length}');
    return images;
  }

  pw.Widget _buildMentalIlnessSection(MedicalReportResponseModel reportData) {
    final mentalModule = reportData.data.mentalIllnessModule;
    if (mentalModule == null) return pw.SizedBox.shrink();

    final hasMentalIllnesses = mentalModule.mentalIllnesses != null &&
        mentalModule.mentalIllnesses!.isNotEmpty;
    final hasBehavioralDisorders = mentalModule.behavioralDisorders != null &&
        mentalModule.behavioralDisorders!.isNotEmpty;

    if (!hasMentalIllnesses && !hasBehavioralDisorders) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: sectionPadding,
      margin: sectionMargin,
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الامراض النفسية'),
          pw.SizedBox(height: 12),

          // Part 1: Mental Illnesses
          if (hasMentalIllnesses) ...[
            pw.Text(
              'الامراض النفسية',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
                color:
                    PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
              ),
            ),
            pw.SizedBox(height: 2),
            _buildMentalIllnessHeaderRow(),
            ...mentalModule.mentalIllnesses!.map((item) {
              return pw.Column(
                children: [
                  _buildMentalIllnessRow(item),
                  pw.Divider(
                    color: PdfColors.grey300,
                    height: 2,
                  ),
                ],
              );
            }),
            pw.SizedBox(height: 12),
          ],

          // Part 2: Behavioral Disorders
          if (hasBehavioralDisorders) ...[
            pw.Text(
              'الاضطرابات النفسية والسلوكية',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 14,
                color:
                    PdfColor.fromInt(AppColorsManager.mainDarkBlue.toARGB32()),
              ),
            ),
            pw.SizedBox(height: 2),
            _buildBehavioralHeaderRow(),
            ...mentalModule.behavioralDisorders!.map((item) {
              return pw.Column(
                children: [
                  _buildBehavioralRow(item),
                  pw.Divider(
                    color: PdfColors.grey300,
                    height: 2,
                  ),
                ],
              );
            }),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildMentalIllnessHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('التاريخ', flex: 2),
          _buildHeaderCell('نوع المرض النفسي', flex: 4),
          _buildHeaderCell('شدة المرض', flex: 2),
          _buildHeaderCell('مدة المرض', flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildMentalIllnessRow(MentalIllness item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(item.diagnosisDate), flex: 2),
          _buildValueCell(
            _safeText(item.mentalIllnessType),
            flex: 4,
          ),
          _buildValueCell(_safeText(item.illnessSeverity), flex: 2),
          _buildValueCell(_safeText(item.illnessDuration), flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildBehavioralHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('التاريخ', flex: 2),
          _buildHeaderCell('المحور النفسي او السلوكي', flex: 6),
          _buildHeaderCell('درجة التقييم', flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildBehavioralRow(BehavioralDisorder item) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(item.assessmentDate), flex: 2),
          _buildValueCell(
            _safeText(item.axes),
            flex: 6,
          ),
          _buildValueCell(_safeText(item.overallLevel), flex: 2),
        ],
      ),
    );
  }

  pw.Widget _buildChronicIllnessHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('تاريخ بداية التشخيص', flex: 3),
          _buildHeaderCell('اسم المرض المزمن', flex: 4),
          _buildHeaderCell('حالة المرض المزمن', flex: 3),
        ],
      ),
    );
  }

  pw.Widget _buildChronicIllnessRow(ChronicDiseaseModel disease) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(disease.formattedDate), flex: 3),
          _buildValueCell(_safeText(disease.diseaseName), flex: 4),
          _buildValueCell(_safeText(disease.diseaseStatus), flex: 3),
        ],
      ),
    );
  }

  pw.Widget _buildTeethSymptomHeaderRow() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Row(
        children: [
          _buildHeaderCell('التاريخ', flex: 2, fontSize: 10),
          _buildHeaderCell('رقم السن', flex: 1, fontSize: 10),
          _buildHeaderCell('نوع العرض', flex: 2, fontSize: 10),
          _buildHeaderCell('طبيعة الشكوى', flex: 2, fontSize: 10),
          _buildHeaderCell('مدة الاعراض', flex: 2, fontSize: 10),
          _buildHeaderCell('حدة الشكوى', flex: 2, fontSize: 10),
        ],
      ),
    );
  }

  pw.Widget _buildTeethSymptomRow(dynamic symptom) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildValueCell(_safeText(symptom.symptomStartDate),
              flex: 2, fontSize: 10),
          _buildValueCell(_safeText(symptom.teethNumber),
              flex: 1, fontSize: 10),
          _buildValueCell(_safeText(symptom.symptomType),
              flex: 2, fontSize: 10),
          _buildValueCell(_safeText(symptom.complaintNature),
              flex: 2, fontSize: 10),
          _buildValueCell(_safeText(symptom.symptomDuration),
              flex: 2, fontSize: 10),
          _buildValueCell(_safeText(symptom.painNature), flex: 2, fontSize: 10),
        ],
      ),
    );
  }

  List<pw.Widget> _buildSmartNutrationAnalysisSection(
      MedicalReportResponseModel reportData) {
    final nutritionModule = reportData.data.nutritionTrackingModule;

    if (nutritionModule == null || nutritionModule.isEmpty) {
      return [];
    }

    final widgets = <pw.Widget>[];

    for (final entry in nutritionModule) {
      final dateStr = entry.dateRange != null
          ? "من تاريخ : ${_formatNutritionDate(entry.dateRange!.from)}"
              "  الى تاريخ: ${_formatNutritionDate(entry.dateRange!.to)}"
          : "--";

      final items = entry.nutritionReport ?? [];
      if (items.isEmpty) continue;

      // -------------------------------
      // Header container only
      // -------------------------------
      widgets.add(
        pw.Container(
          padding: pw.EdgeInsets.fromLTRB(15, 5, 15, 5),
          margin: pw.EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
          decoration: pw.BoxDecoration(
            color: PdfColors.white,
            borderRadius: pw.BorderRadius.only(
              topLeft: pw.Radius.circular(16),
              topRight: pw.Radius.circular(16),
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              _buildSectionHeader("جدول المتابعة الغذائية"),
              pw.SizedBox(height: 12),
              pw.Text(
                dateStr,
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 12,
                  color: PdfColors.black,
                ),
              ),
              pw.SizedBox(height: 2),
              _buildNutritionHeaderRow(),
            ],
          ),
        ),
      );

      // -------------------------------
      // All rows visually attached
      // -------------------------------
      for (final item in items) {
        final currentIndex = items.indexOf(item);
        final isLast = currentIndex == items.length - 1;

        widgets.add(
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 15),
            margin: const pw.EdgeInsets.only(left: 10, right: 10),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: isLast
                  ? pw.BorderRadius.only(
                      bottomLeft: pw.Radius.circular(16),
                      bottomRight: pw.Radius.circular(16),
                    )
                  : null,
            ),
            child: _buildNutritionRow(item),
          ),
        );

        widgets.add(
          pw.Divider(
            color: PdfColors.grey300,
            height: 1,
          ),
        );
      }
    }

    return widgets;
  }

  // pw.Widget _buildSmartNutrationAnalysisSection(
  //     MedicalReportResponseModel reportData) {
  //   final nutritionModule = reportData.data.nutritionTrackingModule;

  //   if (nutritionModule == null || nutritionModule.isEmpty) {
  //     return pw.SizedBox.shrink();
  //   }

  //   final widgets = <pw.Widget>[];

  //   for (final entry in nutritionModule) {
  //     final dateStr = entry.dateRange != null
  //         ? "من تاريخ : ${_formatNutritionDate(entry.dateRange!.from)}"
  //             "  الى تاريخ: ${_formatNutritionDate(entry.dateRange!.to)}"
  //         : "--";

  //     final items = entry.nutritionReport ?? [];

  //     if (items.isEmpty) continue;

  //     // -------------------------------
  //     // Header + first row together
  //     // -------------------------------
  //     widgets.add(
  //       pw.Container(
  //         padding: sectionPadding,
  //         margin: sectionMargin,
  //         decoration: pw.BoxDecoration(
  //           color: PdfColors.white,
  //           borderRadius: pw.BorderRadius.circular(16),
  //         ),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             _buildSectionHeader("جدول المتابعة الغذائية"),
  //             pw.SizedBox(height: 12),
  //             pw.Text(
  //               dateStr,
  //               style: pw.TextStyle(
  //                 fontWeight: pw.FontWeight.bold,
  //                 fontSize: 12,
  //                 color: PdfColors.black,
  //               ),
  //             ),
  //             pw.SizedBox(height: 2),
  //             _buildNutritionHeaderRow(),
  //             _buildNutritionRow(items.first),
  //             pw.Divider(
  //               color: PdfColors.grey300,
  //               height: 1,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );

  //     // -------------------------------
  //     // Remaining rows (can paginate)
  //     // -------------------------------
  //     for (final item in items.skip(1)) {
  //       widgets.add(
  //         pw.Container(
  //           padding: const pw.EdgeInsets.symmetric(horizontal: 15),
  //           margin: const pw.EdgeInsets.only(left: 10, right: 10),
  //           color: PdfColors.white,
  //           child: _buildNutritionRow(item),
  //         ),
  //       );

  //       widgets.add(
  //         pw.Container(
  //           margin: const pw.EdgeInsets.only(left: 10, right: 10),
  //           child: pw.Divider(
  //             color: PdfColors.grey300,
  //             height: 1,
  //           ),
  //         ),
  //       );
  //     }
  //   }

  //   return pw.Column(children: widgets);
  // }

  // List<pw.Widget> _buildSmartNutrationAnalysisSection(
  //     MedicalReportResponseModel reportData) {
  //   final nutritionModule = reportData.data.nutritionTrackingModule;

  //   if (nutritionModule == null || nutritionModule.isEmpty) {
  //     return [];
  //   }

  //   final widgets = <pw.Widget>[];

  //   for (final entry in nutritionModule) {
  //     final dateStr = entry.dateRange != null
  //         ? "من تاريخ : ${_formatNutritionDate(entry.dateRange!.from)}"
  //             "  الى تاريخ: ${_formatNutritionDate(entry.dateRange!.to)}"
  //         : "--";

  //     // بداية البلوك
  //     widgets.add(
  //       pw.Container(
  //         padding: sectionPadding,
  //         margin: sectionMargin,
  //         decoration: pw.BoxDecoration(
  //           color: PdfColors.white,
  //           borderRadius: pw.BorderRadius.circular(16),
  //         ),
  //         child: pw.Column(
  //           crossAxisAlignment: pw.CrossAxisAlignment.start,
  //           children: [
  //             _buildSectionHeader("جدول المتابعة الغذائية"),
  //             pw.SizedBox(height: 12),
  //             pw.Text(
  //               dateStr,
  //               style: pw.TextStyle(
  //                 fontWeight: pw.FontWeight.bold,
  //                 fontSize: 12,
  //                 color: PdfColors.black,
  //               ),
  //             ),
  //             pw.SizedBox(height: 2),
  //             _buildNutritionHeaderRow(),
  //           ],
  //         ),
  //       ),
  //     );

  //     // الصفوف خارج الكولمن
  //     for (final item in (entry.nutritionReport ?? [])) {
  //       widgets.add(
  //         pw.Container(
  //           padding: const pw.EdgeInsets.symmetric(horizontal: 15),
  //           margin: const pw.EdgeInsets.only(left: 10, right: 10),
  //           color: PdfColors.white,
  //           child: _buildNutritionRow(item),
  //         ),
  //       );

  //       widgets.add(
  //         pw.Container(
  //           margin: const pw.EdgeInsets.only(left: 10, right: 10),
  //           child: pw.Divider(
  //             color: PdfColors.grey300,
  //             height: 1,
  //           ),
  //         ),
  //       );
  //     }
  //   }

  //   return widgets;
  // }

  // pw.Widget _buildSmartNutrationAnalysisSection(
  //     MedicalReportResponseModel reportData) {
  //   final nutritionModule = reportData.data.nutritionTrackingModule;

  //   if (nutritionModule == null || nutritionModule.isEmpty) {
  //     return pw.SizedBox.shrink();
  //   }

  //   return pw.Column(
  //     children: [
  //       for (final entry in nutritionModule) _buildSingleNutritionBlock(entry),
  //     ],
  //   );
  // }

  // pw.Widget _buildSingleNutritionBlock(NutritionTrackingEntry entry) {
  //   final dateStr = entry.dateRange != null
  //       ? "من تاريخ : ${_formatNutritionDate(entry.dateRange!.from)}"
  //           "  الى تاريخ: ${_formatNutritionDate(entry.dateRange!.to)}"
  //       : "--";

  //   return pw.Container(
  //     padding: sectionPadding,
  //     margin: sectionMargin,
  //     decoration: pw.BoxDecoration(
  //       color: PdfColors.white,
  //       borderRadius: pw.BorderRadius.circular(16),
  //     ),
  //     child: pw.Column(
  //       crossAxisAlignment: pw.CrossAxisAlignment.start,
  //       children: [
  //         _buildSectionHeader("جدول المتابعة الغذائية"),
  //         pw.SizedBox(height: 12),
  //         pw.Text(
  //           dateStr,
  //           style: pw.TextStyle(
  //             fontWeight: pw.FontWeight.bold,
  //             fontSize: 12,
  //             color: PdfColors.black,
  //           ),
  //         ),
  //         pw.SizedBox(height: 2),
  //         _buildNutritionHeaderRow(),
  //         for (final item in (entry.nutritionReport ?? [])) ...[
  //           _buildNutritionRow(item),
  //           pw.Divider(
  //             color: PdfColors.grey300,
  //             height: 1,
  //           ),
  //         ],
  //       ],
  //     ),
  //   );
  // }

  String _formatNutritionDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return "--";
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        "يناير",
        "فبراير",
        "مارس",
        "أبريل",
        "مايو",
        "يونيو",
        "يوليو",
        "أغسطس",
        "سبتمبر",
        "أكتوبر",
        "نوفمبر",
        "ديسمبر"
      ];
      return "${date.day} ${months[date.month - 1]} ${date.year}";
    } catch (e) {
      return dateStr;
    }
  }
}
