import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/features/my_medical_reports/data/models/medical_report_response_model.dart';

import '../../../../core/global/theming/color_manager.dart';

class MedicalReportPdfGenerator {
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

    final prescriptionImageProvider =
        await _loadAssetImage('assets/images/report.png');

    final logoImageProvider =
        await _loadAssetImage('assets/images/we_care_logo.png');

    // Load X-Ray images (simulating multiple images)
    final xRayImageProvider =
        await _loadAssetImage('assets/images/x_ray_sample.png');
    final xRayImages = [
      xRayImageProvider,
      xRayImageProvider,
      xRayImageProvider
    ]; // Example list

    final theme = pw.ThemeData.withFont(
      base: ttfRegular,
      bold: ttfBold,
    );

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          theme: theme,
          pageFormat: PdfPageFormat.a3,
          margin: const pw.EdgeInsets.all(20),
          textDirection: pw.TextDirection.rtl,
          buildBackground: (context) => pw.FullPage(
            ignoreMargins: true,
            child: pw.Container(
              color: PdfColor.fromInt(0xffEBEBEB),
            ),
          ),
        ),
        header: (context) =>
            _buildHeader(profileImageProvider, logoImageProvider, reportData),
        build: (context) => [
          _buildBasicInfoSection(reportData),
          pw.SizedBox(height: 15),
          _buildVitalSignsSection(reportData),
          pw.SizedBox(height: 15),
          _buildChronicDiseasesSection(reportData),
          pw.SizedBox(height: 15),
          _buildComplaintsSection(reportData, complaintImages),
          pw.SizedBox(height: 15),
          _buildMedicationsSection(reportData),
          pw.SizedBox(height: 15),
          _buildAllergiesSection(),
          pw.SizedBox(height: 15),
          _buildSurgeriesSection(),
          pw.SizedBox(height: 15),
          _buildLabResultsSection(reportData),
          pw.SizedBox(height: 15),
          _buildVaccinationsSection(),
          pw.SizedBox(height: 15),
          _buildXRaySection(xRayImages),
          pw.SizedBox(height: 15),
          _buildPrescriptionsSection(prescriptionImageProvider),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildXRaySection(List<pw.ImageProvider> images) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأشعة'),
          pw.SizedBox(height: 8),
          pw.Wrap(
            spacing: 10,
            runSpacing: 10,
            children: images.map((image) {
              return pw.Container(
                width: 350, // Adjust size as needed
                height: 250,
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                  borderRadius: pw.BorderRadius.circular(8),
                  image: pw.DecorationImage(
                    image: image,
                    fit: pw.BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'صور الأشعة المرفقة (${images.length})',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildPrescriptionsSection(pw.ImageProvider prescriptionImage) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الروشتات الطبية'),
          pw.SizedBox(height: 8),
          pw.Container(
            width: 200,
            height: 200,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(8),
              image: pw.DecorationImage(
                image: prescriptionImage,
                fit: pw.BoxFit.cover,
              ),
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            'صورة الروشتة المرفقة',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildHeader(pw.ImageProvider profileImage,
      pw.ImageProvider logoImage, MedicalReportResponseModel reportData) {
    final name = reportData.userName ?? 'غير معروف';

    return pw.Container(
      color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
      padding: const pw.EdgeInsets.symmetric(horizontal: 32, vertical: 25),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          // Right Side: Patient Info
          pw.Row(
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
              pw.SizedBox(width: 16),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'تاريخ الانشاء: ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}',
                    style: const pw.TextStyle(
                        color: PdfColors.white, fontSize: 10),
                  ),
                  pw.Text(
                    'الاسم: $name',
                    style: pw.TextStyle(
                        color: PdfColors.white,
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),

          // Center: Title
          pw.Row(
            children: [
              // pw.Icon(pw.IconData(0xe9fe), color: PdfColors.white, size: 40), // Icons not directly supported in pdf package without font
              pw.SizedBox(width: 10),
              pw.Text(
                'تقرير طبي شخصي',
                style: pw.TextStyle(
                    color: PdfColors.white,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),

          // Left Side: Logo
          pw.Container(
            padding: const pw.EdgeInsets.all(6),
            decoration: pw.BoxDecoration(
              color: PdfColors.white,
              borderRadius: pw.BorderRadius.circular(12),
            ),
            child: pw.Image(
              logoImage,
              width: 50,
              height: 50,
              fit: pw.BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.only(bottom: 8),
      decoration: pw.BoxDecoration(
        border: pw.Border(
            bottom: pw.BorderSide(
                color: PdfColor.fromInt(AppColorsManager.babyBlueColor.value),
                width: 2)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 18,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
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
      margin: const pw.EdgeInsets.only(top: 15),
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('البيانات الأساسية'),
          pw.SizedBox(height: 10),
          pw.Wrap(
            spacing: 20,
            runSpacing: 20,
            children: List.generate(displayInfo.length, (index) {
              final info = displayInfo[index];

              if (info.label == 'الاسم') {
                return pw.SizedBox.shrink();
              }
              return pw.Padding(
                padding: pw.EdgeInsets.only(
                  left: index == 0 ? 0 : 20, // ✅ أول عنصر بدون spacing
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
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
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
    );
  }

  pw.Widget _buildVitalSignsSection(MedicalReportResponseModel reportData) {
    final vitalSigns = reportData.data.vitalSigns;

    if (vitalSigns == null || vitalSigns.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('القياسات الحيوية'),
          pw.SizedBox(height: 10),
          pw.Wrap(
            spacing: 20,
            runSpacing: 20,
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
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأمراض المزمنة'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              'حالة المرض المزمن',
              'اسم المرض المزمن',
              'تاريخ بداية التشخيص',
            ],
            data: diseases
                .map((disease) => [
                      disease.diseaseStatus,
                      disease.diseaseName,
                      disease.formattedDate,
                    ])
                .toList(),
            headerStyle: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
            cellStyle: const pw.TextStyle(
              fontSize: 14,
            ),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildVitalGroupCard(VitalSignGroupModel group) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey200),
        borderRadius: pw.BorderRadius.circular(12),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            group.categoryName,
            style: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
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
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // ✅ Title Header
          _buildSectionHeader('الشكاوي الطارئة'),
          pw.SizedBox(height: 12),

          // ✅ Header Row Titles
          _buildComplaintsHeaderRow(),
          pw.Divider(color: PdfColors.grey400),

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
                color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
              ),
            ),
            pw.SizedBox(height: 10),
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
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        children: [
          _buildHeaderCell("التاريخ", flex: 2),
          _buildHeaderCell("الشكوى", flex: 5),
          _buildHeaderCell("العضو", flex: 2),
          _buildHeaderCell("طبيعة الشكوى", flex: 2),
          _buildHeaderCell("حدة الشكوى", flex: 2),
          _buildHeaderCell("صورة الشكوي", flex: 2),
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
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
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

  pw.Widget _buildHeaderCell(String text, {required int flex}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

//////////////////////////////////////////////////////////////////
// ✅ Value Cell Styling
//////////////////////////////////////////////////////////////////

  pw.Widget _buildValueCell(
    String text, {
    required int flex,
    bool alignRight = false,
  }) {
    return pw.Expanded(
      flex: flex,
      child: pw.Padding(
        padding: const pw.EdgeInsets.symmetric(horizontal: 4),
        child: pw.Text(
          text,
          style: const pw.TextStyle(
            fontSize: 14,
            color: PdfColors.black,
          ),
          textAlign: alignRight ? pw.TextAlign.right : pw.TextAlign.center,
          softWrap: true,
        ),
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

    if (module == null) {
      return pw.SizedBox.shrink();
    }

    final current = module.currentMedications;
    final expired = module.expiredLast90Days;

    if ((current == null || current.isEmpty) &&
        (expired == null || expired.isEmpty)) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأدوية'),
          if (current != null && current.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pw.Text('الادوية الحالية',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(height: 10),
            _buildMedicationsTable(current),
          ],
          if (expired != null && expired.isNotEmpty) ...[
            pw.SizedBox(height: 20),
            pw.Text('الأدوية المنتهية خلال 90 يوم',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
            pw.SizedBox(height: 10),
            _buildMedicationsTable(expired, isExpired: true),
          ],
        ],
      ),
    );
  }

  pw.Widget _buildMedicationsTable(
    List<MedicationModel> medications, {
    bool isExpired = false,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: [
        isExpired ? 'تاريخ انتهاء الدواء' : 'تاريخ استخدام الدواء',
        'اسم الدواء',
        'الجرعة',
        'كمية الادوية',
        'عدد مرات الجرعة',
        'المدد الزمنية',
      ],
      data: medications.map((med) {
        return [
          med.date,
          med.medicineName,
          med.dosage ?? 'لا يوجد',
          med.doseAmount ?? 'لا يوجد',
          med.dosageFrequency ?? 'لا يوجد',
          med.timeDuration ?? 'لا يوجد',
        ];
      }).toList(),
      headerStyle: pw.TextStyle(
        color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
        fontWeight: pw.FontWeight.bold,
        fontSize: 14,
      ),
      cellStyle: const pw.TextStyle(
        fontSize: 14,
      ),
      headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
      cellAlignment: pw.Alignment.center,
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
    );
  }

  pw.Widget _buildAllergiesSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الحساسية'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['المادة', 'رد الفعل', 'الشدة'],
            data: [
              ['البنسلين', 'طفح جلدي', 'متوسطة'],
              ['الفول السوداني', 'ضيق تنفس', 'شديدة'],
            ],
            headerStyle: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildSurgeriesSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('العمليات الجراحية'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['العملية', 'التاريخ', 'المستشفى', 'ملاحظات'],
            data: [
              ['استئصال الزائدة', '15/03/2018', 'مستشفى السلام', 'ناجحة'],
              ['تصحيح نظر', '10/11/2020', 'مستشفى العيون', 'ليزر'],
            ],
            headerStyle: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildLabResultsSection(MedicalReportResponseModel reportData) {
    final tests = reportData.data.medicalTests;

    if (tests == null || tests.isEmpty) {
      return pw.SizedBox.shrink();
    }

    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التحاليل الطبية'),
          pw.SizedBox(height: 12),
          pw.TableHelper.fromTextArray(
            headers: [
              'النتيجة',
              'النتيجة',
              'النتيجة',
              'المجموعة',
              'الرمز',
              'اسم التحليل',
            ],
            data: tests.map((test) {
              final results = test.results ?? [];
              return [
                _buildTestResultWidget(results.length > 2 ? results[2] : null),
                _buildTestResultWidget(results.length > 1 ? results[1] : null),
                _buildTestResultWidget(results.isNotEmpty ? results[0] : null),
                test.group ?? "---",
                test.code ?? "---",
                test.testName,
              ];
            }).toList(),
            headerStyle: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: const pw.TextStyle(fontSize: 11),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            cellAlignment: pw.Alignment.center,
            columnWidths: {
              0: const pw.FlexColumnWidth(1.5), // النتيجة 3
              1: const pw.FlexColumnWidth(1.5), // النتيجة 2
              2: const pw.FlexColumnWidth(1.5), // النتيجة 1
              3: const pw.FlexColumnWidth(2), // المجموعة
              4: const pw.FlexColumnWidth(1.2), // الرمز
              5: const pw.FlexColumnWidth(2.5), // اسم التحليل
            },
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
            cellPadding: const pw.EdgeInsets.all(6),
          ),
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
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
          ),
      ],
    );
  }

  String _formatResultDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
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

  pw.Widget _buildVaccinationsSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('التطعيمات'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['اللقاح', 'التاريخ', 'الجرعة'],
            data: [
              ['Influenza', '01/10/2012', '0.5 ml'],
              ['COVID-19', '15/05/2021', 'الجرعة الأولى'],
            ],
            headerStyle: pw.TextStyle(
              color: PdfColor.fromInt(AppColorsManager.mainDarkBlue.value),
              fontWeight: pw.FontWeight.bold,
              fontSize: 12,
            ),
            cellStyle: const pw.TextStyle(fontSize: 10),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey100),
            cellAlignment: pw.Alignment.center,
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          ),
        ],
      ),
    );
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
}
