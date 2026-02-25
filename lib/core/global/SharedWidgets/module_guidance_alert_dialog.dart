import 'package:flutter/material.dart';
import 'package:we_care/core/global/theming/app_text_styles.dart';
import 'package:we_care/core/global/theming/color_manager.dart';

class ModuleGuidanceAlertDialog extends StatelessWidget {
  final String title;
  final String description;

  const ModuleGuidanceAlertDialog({
    super.key,
    required this.title,
    required this.description,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String description,
  }) {
    return showDialog(
      context: context,
      builder: (context) => ModuleGuidanceAlertDialog(
        title: title,
        description: description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Dialog(
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 10), // 👈 هنا التحكم الحقيقي
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      child: SizedBox(
        width: width - 15, // 👈 كده ياخد أقصى عرض مسموح
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: AppTextStyles.font18blackWight500.copyWith(
                  color: AppColorsManager.mainDarkBlue,
                ),
              ),

              const SizedBox(height: 16),

              /// Description
              Flexible(
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    textAlign: TextAlign.justify,
                    style: AppTextStyles.font14blackWeight400.copyWith(
                      height: 1.5,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// Button
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("حسنا فهمت"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
