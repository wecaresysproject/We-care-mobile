import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_logger.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/doctor/prescription/logic/doctor_prescription_document_builder.dart';

/// "معاينة الروشتة": the exact images the patient will receive.
class DoctorPrescriptionPreviewView extends StatefulWidget {
  const DoctorPrescriptionPreviewView({super.key, required this.data});

  final PrescriptionDocumentData data;

  @override
  State<DoctorPrescriptionPreviewView> createState() =>
      _DoctorPrescriptionPreviewViewState();
}

class _DoctorPrescriptionPreviewViewState
    extends State<DoctorPrescriptionPreviewView> {
  late Future<List<Uint8List>> _pages;

  @override
  void initState() {
    super.initState();
    _pages = _buildPages();
  }

  Future<List<Uint8List>> _buildPages() async {
    try {
      return await const DoctorPrescriptionDocumentBuilder()
          .buildPageImages(widget.data);
    } catch (error) {
      AppLogger.debug('❌ prescription preview failed: $error');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.prescriptionScaffoldBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
              child: Row(
                children: [
                  SizedBox(width: 48.w),
                  Expanded(
                    child: Text(
                      "معاينة الروشتة",
                      textAlign: TextAlign.center,
                      style: AppTextStyles.font20blackWeight700.copyWith(
                        color: AppColorsManager.prescriptionTitleColor,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48.w,
                    child: IconButton(
                      tooltip: "إغلاق",
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close,
                        color: AppColorsManager.prescriptionTitleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Uint8List>>(
                future: _pages,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData) {
                    return _PreviewError(
                      onRetry: () => setState(() => _pages = _buildPages()),
                    );
                  }
                  final pages = snapshot.data!;
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                    itemCount: pages.length,
                    separatorBuilder: (_, __) => verticalSpacing(16),
                    itemBuilder: (context, index) => Column(
                      children: [
                        Text(
                          "صفحة ${index + 1} من ${pages.length}",
                          style: AppTextStyles.font13GreyWeight400.copyWith(
                            color: AppColorsManager.prescriptionSubtitleColor,
                          ),
                        ),
                        verticalSpacing(6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: AppColorsManager.prescriptionCardBorder,
                            ),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: InteractiveViewer(
                            maxScale: 4,
                            child: Image.memory(pages[index]),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PreviewError extends StatelessWidget {
  const _PreviewError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "تعذر تجهيز معاينة الروشتة",
            style: AppTextStyles.font16BlackSemiBold.copyWith(
              color: AppColorsManager.prescriptionTitleColor,
            ),
          ),
          verticalSpacing(8),
          TextButton(onPressed: onRetry, child: const Text("إعادة المحاولة")),
        ],
      ),
    );
  }
}
