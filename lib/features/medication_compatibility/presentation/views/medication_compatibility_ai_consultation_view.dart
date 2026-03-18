import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/ai_handoff_helper.dart';
import 'package:we_care/core/global/Helpers/functions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class MedicationCompatibilityConsultationView extends StatefulWidget {
  final String initialMessage;

  const MedicationCompatibilityConsultationView({
    super.key,
    required this.initialMessage,
  });

  @override
  State<MedicationCompatibilityConsultationView> createState() =>
      _MedicationCompatibilityConsultationViewState();
}

class _MedicationCompatibilityConsultationViewState
    extends State<MedicationCompatibilityConsultationView> {
  late TextEditingController _controller;
  String? _selectedModel;
  bool _isHandoffInProgress = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialMessage);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _getModelIcon(String model, bool isSelected) {
    String? assetPath;
    if (model == 'ChatGPT') {
      assetPath = 'assets/images/chat_gbt_icon.png';
    } else if (model == 'DeepSeek') {
      assetPath = 'assets/images/deep_seek_icon.png';
    } else if (model == 'Claude') {
      assetPath = 'assets/images/claude_icon.png';
    } else if (model == 'Gemini') {
      assetPath = 'assets/images/gemini_icon.png';
    } else if (model == 'Perplexity') {
      assetPath = 'assets/images/perplexity_icon.png';
    }

    if (assetPath != null) {
      return Image.asset(
        assetPath,
        width: 24.w,
        height: 24.h,
      );
    }

    return Icon(
      model == 'Gemini' ? Icons.auto_awesome : Icons.bolt,
      color: isSelected ? Colors.white : AppColorsManager.mainDarkBlue,
      size: 24.w,
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
              AppBarWithCenteredTitle(
                title: "تجهيز استشارة AI",
                showActionButtons: false,
              ),
              verticalSpacing(24),
              Text(
                "راجع نص الرسالة قبل الإرسال",
                style: AppTextStyles.font16BlackSemiBold,
              ),
              verticalSpacing(8),
              TextFormField(
                controller: _controller,
                maxLines: 15,
                style: AppTextStyles.font14blackWeight400,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColorsManager.textfieldInsideColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              verticalSpacing(16),
              AppCustomButton(
                title: "نسخ النص",
                textFontSize: 16.sp,
                isEnabled: true,
                onPressed: () => ConsultAIHelper.copyToClipboard(
                  context,
                  _controller.text,
                ),
              ),
              verticalSpacing(24),
              Text(
                "اختر تطبيق الذكاء الاصطناعي",
                style: AppTextStyles.font16BlackSemiBold,
              ),
              verticalSpacing(12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16.w,
                mainAxisSpacing: 16.h,
                childAspectRatio: 1.6,
                children: ConsultAIHelper.aiModels.keys.map((model) {
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
                          _getModelIcon(model, isSelected),
                          verticalSpacing(8),
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
              verticalSpacing(24),
              AppCustomButton(
                title: "استشر ${_selectedModel ?? '...'}",
                isEnabled: _selectedModel != null && !_isHandoffInProgress,
                isLoading: _isHandoffInProgress,
                onPressed: () async {
                  setState(() => _isHandoffInProgress = true);
                  await ConsultAIHelper.handleHandoff(
                    context: context,
                    modelName: _selectedModel!,
                    text: _controller.text,
                  );
                  if (mounted) setState(() => _isHandoffInProgress = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
