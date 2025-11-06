import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:we_care/core/global/Helpers/app_toasts.dart';
import 'package:we_care/core/global/Helpers/extensions.dart';
import 'package:we_care/core/global/SharedWidgets/app_custom_button.dart';
import 'package:we_care/core/global/SharedWidgets/custom_app_bar_with_centered_title_widget.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';

class WriteReportScreenSharedWidget extends StatelessWidget {
  final TextEditingController reportController;
  final String? screenTitle;
  final String? infoMessage;
  final String? fieldLabel;
  final String? hintText;
  final String? saveButtonText;
  final String? clearButtonText;
  final String? emptyFieldErrorMessage;
  final String? saveSuccessMessage;
  final String? clearSuccessMessage;
  final VoidCallback? onSave;

  const WriteReportScreenSharedWidget({
    super.key,
    required this.reportController,
    this.screenTitle,
    this.infoMessage,
    this.fieldLabel,
    this.hintText,
    this.saveButtonText,
    this.clearButtonText,
    this.emptyFieldErrorMessage,
    this.saveSuccessMessage,
    this.clearSuccessMessage,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          AppBarWithCenteredTitle(
            title: screenTitle ?? "كتابة التقرير الطبي",
            showActionButtons: false,
          ).paddingSymmetricHorizontal(20),

          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: Colors.blue.shade100,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Colors.blue.shade700,
                          size: 24.w,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "اكتب التقرير الطبي بالتفصيل، يمكنك ذكر النتائج والملاحظات والتوصيات",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.blue.shade900,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                  // Header Info (optional)
                  if (infoMessage != null) ...[
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: Colors.blue.shade100,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Colors.blue.shade700,
                            size: 24.w,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              infoMessage!,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.blue.shade900,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                  ],

                  // Section Title
                  Text(
                    fieldLabel ?? "التقرير الطبي",
                    style: AppTextStyles.font18blackWight500,
                  ),

                  SizedBox(height: 12.h),

                  // TextField
                  TextField(
                    controller: reportController,
                    maxLines: null,
                    minLines: 12,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 16.sp,
                      height: 1.8,
                    ),
                    decoration: InputDecoration(
                      hintText: hintText ??
                          "ابدأ الكتابة هنا...\n\nمثال:\n- نتائج الفحص\n- الملاحظات الطبية\n- التوصيات",
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14.sp,
                        height: 1.8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: EdgeInsets.all(16.w),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Character Counter
                  Align(
                    alignment: Alignment.centerLeft,
                    child: ValueListenableBuilder(
                      valueListenable: reportController,
                      builder: (context, value, child) {
                        return Text(
                          "${value.text.length} حرف",
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppCustomButton(
                  title: saveButtonText ?? "حفظ التقرير",
                  onPressed: () async {
                    if (reportController.text.trim().isEmpty) {
                      await showError(
                        emptyFieldErrorMessage ?? "الرجاء كتابة التقرير أولاً",
                      );
                      return;
                    }

                    // Custom callback if provided
                    if (onSave != null) {
                      onSave!();
                    }

                    Navigator.pop(context);
                    await showSuccess(
                      saveSuccessMessage ?? "تم حفظ التقرير بنجاح ✓",
                    );
                  },
                  isEnabled: true,
                ),

                SizedBox(height: 12.h),

                // Clear Button
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: OutlinedButton(
                    onPressed: () {
                      if (reportController.text.isEmpty) return;

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("تأكيد المسح"),
                          content: const Text("هل تريد مسح كل ما كتبته؟"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("إلغاء"),
                            ),
                            TextButton(
                              onPressed: () async {
                                reportController.clear();
                                Navigator.pop(context);
                                await showSuccess(
                                  clearSuccessMessage ?? "تم مسح التقرير بنجاح",
                                );
                              },
                              child: const Text(
                                "مسح",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      clearButtonText ?? "مسح الكل",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
