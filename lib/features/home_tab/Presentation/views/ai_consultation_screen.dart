import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class AIConsultationScreen extends StatefulWidget {
  const AIConsultationScreen({super.key});

  @override
  State<AIConsultationScreen> createState() => _AIConsultationScreenState();
}

class _AIConsultationScreenState extends State<AIConsultationScreen> {
  final TextEditingController _complaintController = TextEditingController();
  String? _selectedDate;
  String? _selectedModel;
  bool _isHandoffInProgress = false;

  final List<String> _reportDates = [
    '2024-05-20',
    '2024-03-15',
    '2024-01-10',
  ];

  final Map<String, String> _aiModels = {
    'ChatGPT': 'com.openai.chatgpt',
    'Gemini': 'com.google.android.apps.bard',
    'DeepSeek': 'com.deepseek.chat',
    'Perplexity': 'ai.perplexity.app.android',
  };
  @override
  void dispose() {
    _complaintController.dispose();
    super.dispose();
  }

  bool get _isButtonEnabled {
    return _selectedDate != null &&
        _complaintController.text.trim().isNotEmpty &&
        _selectedModel != null &&
        !_isHandoffInProgress;
  }

  Future<File> _getTemporaryFileFromAsset() async {
    final byteData = await rootBundle
        .load('assets/medical_report_pdf/My Medical Report.pdf');
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/medical_report.pdf');
    await file.writeAsBytes(byteData.buffer
        .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    return file;
  }

  Future<void> _handleHandoff() async {
    if (_selectedModel == null) return;

    setState(() {
      _isHandoffInProgress = true;
    });

    final packageName = _aiModels[_selectedModel!];
    final isInstalled = await _checkIfAppInstalled(packageName!);

    if (isInstalled) {
      try {
        final pdfFile = await _getTemporaryFileFromAsset();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "سيتم نقلك الآن لمتابعة استشارتك في تطبيق $_selectedModel",
              textAlign: TextAlign.right,
            ),
          ),
        );

        await Share.shareXFiles(
          [XFile(pdfFile.path, mimeType: 'application/pdf')],
          text: _complaintController.text,
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error attaching PDF. Please try again."),
          ),
        );
      }
    } else {
      _showNotInstalledDialog(_selectedModel!, packageName);
    }

    setState(() {
      _isHandoffInProgress = false;
    });
  }

  Future<bool> _checkIfAppInstalled(String packageName) async {
    return await AppCheck().isAppInstalled(packageName);
  }

  void _showNotInstalledDialog(String modelName, String packageName) {
    showDialog(
      context: context,
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text("التطبيق غير مثبت",
              style: AppTextStyles.font16BlackSemiBold),
          content: Text("تطبيق $modelName غير مثبت على جهازك. هل تريد تثبيته؟",
              style: AppTextStyles.font14blackWeight400),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final url = Uri.parse("market://details?id=$packageName");
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                } else {
                  await launchUrl(Uri.parse(
                      "https://play.google.com/store/apps/details?id=$packageName"));
                }
              },
              child: const Text("تثبيت"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorsManager.backGroundColor,
      appBar: AppBar(
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppBarWithCenteredTitle(
                title: "استشر ال AI",
                showActionButtons: false,
              ),
              verticalSpacing(16),
              Text(
                "اختر التقرير الطبي",
                style: AppTextStyles.font16BlackSemiBold,
              ),
              SizedBox(height: 8.h),
              DropdownButtonFormField<String>(
                initialValue: _selectedDate,
                hint: Text("اختر التاريخ",
                    style: AppTextStyles.font14blackWeight400),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColorsManager.textfieldInsideColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                ),
                items: _reportDates.map((date) {
                  return DropdownMenuItem(
                    value: date,
                    child:
                        Text(date, style: AppTextStyles.font14blackWeight400),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedDate = val),
              ),
              if (_selectedDate != null) ...[
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColorsManager.secondaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.red),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "تم إرفاق: My Medical Report.pdf",
                          style: AppTextStyles.font14blackWeight400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              Text(
                "اكتب الشكوى أو استفسارك",
                style: AppTextStyles.font16BlackSemiBold,
              ),
              SizedBox(height: 8.h),
              TextFormField(
                controller: _complaintController,
                maxLines: 5,
                style: AppTextStyles.font14blackWeight400,
                onChanged: (val) => setState(() {}),
                decoration: InputDecoration(
                  hintText:
                      "اكتب الشكوى أو السؤال الذي تريد مناقشته بناءً على البيانات\nمثال: ألم المعدة مستمر منذ أسبوع، هل العلاج مناسب؟",
                  hintStyle: AppTextStyles.font14blackWeight400
                      .copyWith(color: AppColorsManager.placeHolderColor),
                  filled: true,
                  fillColor: AppColorsManager.textfieldInsideColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                "اختر نموذج الذكاء الاصطناعي",
                style: AppTextStyles.font16BlackSemiBold,
              ),
              SizedBox(height: 12.h),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.6,
                children: _aiModels.keys.map((model) {
                  final isSelected = _selectedModel == model;

                  return GestureDetector(
                    onTap: () => setState(() => _selectedModel = model),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColorsManager.mainDarkBlue
                            : AppColorsManager.textfieldInsideColor,
                        borderRadius: BorderRadius.circular(12.r),
                        border: isSelected
                            ? null
                            : Border.all(
                                color: AppColorsManager
                                    .textfieldOutsideBorderColor
                                    .withOpacity(0.3),
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            model == 'ChatGPT'
                                ? Icons.chat_bubble_outline
                                : Icons.auto_awesome,
                            color: isSelected
                                ? Colors.white
                                : AppColorsManager.mainDarkBlue,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            model,
                            style: AppTextStyles.font14blackWeight400.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColorsManager.textColor,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              if (_selectedModel != null) ...[
                SizedBox(height: 16.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColorsManager.secondaryColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.privacy_tip_outlined,
                        color: AppColorsManager.mainDarkBlue,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          "سيتم تحويلك إلى تطبيق الذكاء الاصطناعي المختار لإكمال الاستشارة. "
                          "تتم المحادثة بالكامل خارج تطبيق WECARE حفاظًا على خصوصية بياناتك الطبية، "
                          "ولا يمكن للتطبيق الاطلاع على ردود الذكاء الاصطناعي.",
                          style: AppTextStyles.font14blackWeight400,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              SizedBox(height: 24.h),
              AppCustomButton(
                title: "متابعة الإستشارة مع ${_selectedModel ?? '...'}",
                isEnabled: _isButtonEnabled,
                isLoading: _isHandoffInProgress,
                onPressed: _handleHandoff,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
