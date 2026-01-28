import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
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
          _buildComplaintsSection(),
          pw.SizedBox(height: 15),
          _buildMedicationsSection(),
          pw.SizedBox(height: 15),
          _buildAllergiesSection(),
          pw.SizedBox(height: 15),
          _buildSurgeriesSection(),
          pw.SizedBox(height: 15),
          _buildLabResultsSection(),
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
    final name = reportData.data.basicInformation
            ?.firstWhere((info) => info.label == 'الاسم',
                orElse: () => BasicInformationData(label: '', value: ''))
            .value ??
        'غير معروف';

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

  pw.Widget _buildComplaintsSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الشكاوى المرضية'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              'المنطقة',
              'الشكوى',
              'طبيعة الشكوى',
              'حدة الشكوى',
              'تاريخ الشكوى'
            ],
            data: [
              [
                'اليد',
                'هذا النص مثال لنص اخر يمكن استبداله',
                'مستمرة',
                'خفيف',
                '22/7/2012'
              ],
              [
                'الرأس',
                'هذا النص مثال لنص اخر يمكن استبداله',
                'مستمرة',
                'خفيف',
                '22/7/2012'
              ],
              [
                'الرأس',
                'صداع نصفي هذا النص مثال',
                'مستمرة',
                'خفيف',
                '22/7/2012'
              ],
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

  pw.Widget _buildMedicationsSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('الأدوية الحالية المستمرة'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: [
              'اسم الدواء',
              'الجرعة',
              'عدد مرات الجرعة اليومية',
              'مدة الاستخدام'
            ],
            data: [
              ['الكلورديازيبوكسيد', 'قرصين', 'بعد العشاء', '3 أسابيع'],
              ['نوردازيام', 'قرص', '3 مرات باليوم', '4 أسابيع'],
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

  pw.Widget _buildLabResultsSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.white,
        borderRadius: pw.BorderRadius.circular(16),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('نتائج التحاليل'),
          pw.SizedBox(height: 8),
          pw.TableHelper.fromTextArray(
            headers: ['اسم التحليل', 'النتيجة', 'المعدل الطبيعي', 'التاريخ'],
            data: [
              ['Hemoglobin', '13.5 g/dL', '13.0 - 17.0', '20/12/2012'],
              ['Cholesterol', '190 mg/dL', '< 200', '20/12/2012'],
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
    final basicInfo = reportData.data.basicInformation;
    final imageUrl = basicInfo
        ?.firstWhere((info) => info.label == 'الصورة',
            orElse: () => BasicInformationData(label: '', value: ''))
        .value;

    if (imageUrl != null && imageUrl is String && imageUrl.isNotEmpty) {
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
}
