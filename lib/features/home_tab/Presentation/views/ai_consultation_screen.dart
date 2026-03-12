import 'dart:io';

import 'package:appcheck/appcheck.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:we_care/core/di/dependency_injection.dart';
import 'package:we_care/core/global/Helpers/app_enums.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/appbar_with_centered_title_with_guidance.dart';
import 'package:we_care/core/global/SharedWidgets/module_guidance_alert_dialog.dart';
import 'package:we_care/core/global/SharedWidgets/shared_app_bar_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';
import 'package:we_care/features/home_tab/cubits/ai_consultation_cubit.dart';

class AIConsultationScreen extends StatefulWidget {
  final File? preAttachedReport;
  final String? preAttachedFileName;

  const AIConsultationScreen({
    super.key,
    this.preAttachedReport,
    this.preAttachedFileName,
  });

  @override
  State<AIConsultationScreen> createState() => _AIConsultationScreenState();
}

class _AIConsultationScreenState extends State<AIConsultationScreen> {
  final TextEditingController _complaintController = TextEditingController();
  String? _selectedDate;
  String? _selectedModel;
  bool _isHandoffInProgress = false;
  File? _downloadedPdf;

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

  bool get _isUsingPreAttachedReport => widget.preAttachedReport != null;

  bool get _isPdfAvailable =>
      _isUsingPreAttachedReport ||
      (_selectedDate != null && _downloadedPdf != null);

  bool get _isButtonEnabled {
    return _isPdfAvailable &&
        _complaintController.text.trim().isNotEmpty &&
        _selectedModel != null &&
        !_isHandoffInProgress;
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
        // Use pre-attached report if available, otherwise use downloaded PDF
        final pdfFile = _isUsingPreAttachedReport
            ? widget.preAttachedReport!
            : _downloadedPdf;

        if (pdfFile == null) {
          throw Exception("No PDF available for handoff.");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "سيتم نقلك الآن لمتابعة استشارتك في تطبيق $_selectedModel",
              textAlign: TextAlign.right,
            ),
          ),
        );
        await _copyComplaintToClipboard();

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

  Future<void> _copyComplaintToClipboard() async {
    final text = _complaintController.text.trim();

    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("يرجى كتابة الشكوى أولاً"),
        ),
      );
      return;
    }

    await Clipboard.setData(ClipboardData(text: text));

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        duration: Duration(seconds: 3),
        content: Text(
            "تم نسخ نص الشكوى. يمكنك لصقه داخل المحادثة مع التقرير الطبي."),
      ),
    );
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

  Future<void> _onDateChanged(String? val, AIConsultationCubit cubit) async {
    if (val == null) return;
    setState(() {
      _selectedDate = val;
      _downloadedPdf = null;
    });
    await cubit.getSpecificPdf(val);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AIConsultationCubit>()
        ..emitModuleGuidanceData()
        ..getPdfDates(),
      child: BlocConsumer<AIConsultationCubit, AIConsultationState>(
        listenWhen: (previous, current) =>
            previous.fetchPdfStatus != current.fetchPdfStatus,
        listener: (context, state) async {
          if (state.fetchPdfStatus == RequestStatus.success &&
              state.selectedPdf?.url != null) {
            final tempDir = await getTemporaryDirectory();
            final fileName = state.selectedPdf!.fileName ?? 'medical_report';
            final filePath = await downloadFile(
              state.selectedPdf!.url!.trim(),
              tempDir,
              '$fileName.pdf',
            );
            if (filePath != null) {
              setState(() {
                _downloadedPdf = File(filePath);
              });
            }
          } else if (state.fetchPdfStatus == RequestStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<AIConsultationCubit>();

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
                    CustomAppBarWithCenteredTitleWithGuidance(
                      title: "استشر ال AI",
                      trailingActions: [
                        CircleIconButton(
                          icon: Icons.play_arrow,
                          color:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? AppColorsManager.mainDarkBlue
                                  : Colors.grey,
                          onTap:
                              state.moduleGuidanceData?.videoLink?.isNotEmpty ==
                                      true
                                  ? () => launchYouTubeVideo(
                                      state.moduleGuidanceData!.videoLink)
                                  : null,
                        ),
                        SizedBox(width: 8.w),
                        CircleIconButton(
                          icon: Icons.menu_book_outlined,
                          color: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? AppColorsManager.mainDarkBlue
                              : Colors.grey,
                          onTap: state.moduleGuidanceData?.moduleGuidanceText
                                      ?.isNotEmpty ==
                                  true
                              ? () {
                                  ModuleGuidanceAlertDialog.show(
                                    context,
                                    title: "استشر ال AI",
                                    description: state.moduleGuidanceData!
                                        .moduleGuidanceText!,
                                  );
                                }
                              : null,
                        ),
                      ],
                    ),
                    verticalSpacing(16),
                    // --- Report selection section ---
                    if (!_isUsingPreAttachedReport) ...[
                      Text(
                        "اختر التقرير الطبي",
                        style: AppTextStyles.font16BlackSemiBold,
                      ),
                      SizedBox(height: 8.h),
                      DropdownButtonFormField<String>(
                        initialValue: _selectedDate,
                        hint: state.pdfDatesStatus == RequestStatus.loading
                            ? const Text("جاري تحميل التواريخ...")
                            : Text("اختر التاريخ",
                                style: AppTextStyles.font14blackWeight400),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColorsManager.textfieldInsideColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 12.h),
                        ),
                        items: state.reportDates.map((date) {
                          return DropdownMenuItem(
                            value: date,
                            child: Text(date,
                                style: AppTextStyles.font14blackWeight400),
                          );
                        }).toList(),
                        onChanged: (val) => _onDateChanged(val, cubit),
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
                              const Icon(Icons.picture_as_pdf,
                                  color: Colors.red),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: state.fetchPdfStatus ==
                                        RequestStatus.loading
                                    ? const Text("جاري تجهيز التقرير...")
                                    : Text(
                                        _downloadedPdf != null
                                            ? "تم إرفاق: ${state.selectedPdf?.fileName ?? 'medical_report'}.pdf"
                                            : "فشل تحميل التقرير",
                                        style:
                                            AppTextStyles.font14blackWeight400,
                                      ),
                              ),
                              if (state.fetchPdfStatus == RequestStatus.loading)
                                SizedBox(
                                  width: 15.w,
                                  height: 15.h,
                                  child: const CircularProgressIndicator(
                                      strokeWidth: 2),
                                )
                              else if (_downloadedPdf != null)
                                const Icon(Icons.check_circle,
                                    color: Colors.green, size: 18),
                            ],
                          ),
                        ),
                      ],
                    ] else ...[
                      // Pre-attached report chip
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
                                "تم إرفاق: ${widget.preAttachedFileName ?? 'medical_report.pdf'}",
                                style: AppTextStyles.font14blackWeight400,
                              ),
                            ),
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 18),
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
                                  style: AppTextStyles.font14blackWeight400
                                      .copyWith(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
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
                                    "تتم المحادثة بالكامل خارج تطبيق WECARE حفاظًا على خصوصية بياناتك الطبية.",
                                    style: AppTextStyles.font14blackWeight400,
                                    textAlign: TextAlign.justify,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "سيتم أيضًا نسخ نص الشكوى تلقائيًا لتتمكن من لصقه داخل المحادثة مع التقرير الطبي.",
                              style: AppTextStyles.font14blackWeight400,
                              textAlign: TextAlign.justify,
                            ).paddingRight(32),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: 24.h),
                    AppCustomButton(
                      textFontSize: 16.sp,
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
        },
      ),
    );
  }
}
